# papis python config — auto-maintain the shared Typst bibliography.
#
# Two on_add_done hooks fire in registration order:
#   1. _normalize_metadata — TitleCase author names always; aggressive
#      TitleCase for title/publisher/journal fields with acronym
#      preservation via two paths:
#        (a) all-caps source: .title() + restore _ACRONYMS allowlist
#        (b) mixed-case source: .title() + restore any all-caps tokens
#            already present in the source (no allowlist needed)
#      Extend _ACRONYMS below with tokens you commonly hit that arrive
#      all-caps from publishers. Edge cases (uncommon acronyms not in
#      the list, or unusual style choices) — manual info.yaml edit.
#   2. _regen_shared_bib — export the library to ~/research/bib.yml
#      (Hayagriva) for Typst notes that #bibliography("/bib.yml").
#
# on_add_done fires BEFORE papis moves the just-added doc into its final
# folder ("tmp_doc argument is not the final document" per papis docs).
# So _regen_shared_bib walks the filesystem for previously-committed
# entries, then unions with the hook's tmp_doc argument for the just-
# added one.
#
# NOTE: bib's ctrl-shift-d delete and `papis rm` bypass papis hooks
# entirely, so a periodic re-export (cron, or a bib code change to
# call _regen_shared_bib after its delete flow) is the catch-all for
# those.
import os
import re
from glob import glob

_BIB_OUT = os.path.expanduser("~/research/bib.yml")

# Acronyms preserved after aggressive .title() on all-caps source. Add
# tokens you frequently see mangled. Case-sensitive; word-boundary matched.
_ACRONYMS = {
    "IEEE", "ACM", "IETF", "W3C", "ISO", "ANSI", "IEC",
    "NASA", "ESA", "NOAA", "USGS", "OGC", "ISPRS",
    "NATO", "USA",
    "MIT", "CERN",
    "GIS", "GPS", "GNSS", "GDAL", "GPT", "GDPR",
    "PDF", "HTML", "CSS", "JSON", "XML", "YAML", "TOML",
    "API", "CLI", "GUI", "TUI", "SDK",
    "CPU", "GPU", "RAM", "SSD", "HDD",
    "NLP", "LLM", "RAG",
}


def _titlecase_preserving(s):
    """Aggressive .title() with acronym preservation.

    Two paths: all-caps source uses the _ACRONYMS allowlist to restore
    known acronyms; mixed-case source auto-preserves any all-caps token
    already visible in the source (self-adaptive).
    """
    result = s.title()
    if s.isupper():
        for acronym in _ACRONYMS:
            result = re.sub(r"\b" + acronym.title() + r"\b", acronym, result)
    else:
        for match in re.finditer(r"\b[A-Z]{2,}\b", s):
            token = match.group(0)
            titled = token.title()
            result = re.sub(r"\b" + re.escape(titled) + r"\b", token, result)
    return result


def _normalize_metadata(tmp_doc=None, *_args, **_kwargs):
    if tmp_doc is None or not hasattr(tmp_doc, "get"):
        return
    author_list_changed = False
    other_changed = False

    for author in tmp_doc.get("author_list", []) or []:
        if isinstance(author, dict):
            for key in ("family", "given"):
                val = author.get(key)
                if isinstance(val, str) and val:
                    new_val = val.title()
                    if new_val != val:
                        author[key] = new_val
                        author_list_changed = True

    def _fix(container, key):
        nonlocal other_changed
        val = container.get(key)
        if isinstance(val, str) and val:
            new_val = _titlecase_preserving(val)
            if new_val != val:
                container[key] = new_val
                other_changed = True

    for key in ("title", "publisher", "journal"):
        _fix(tmp_doc, key)

    parent = tmp_doc.get("parent")
    if isinstance(parent, dict):
        for pkey in ("title", "publisher"):
            _fix(parent, pkey)

    if author_list_changed:
        try:
            from papis.document import author_list_to_author
            tmp_doc["author"] = author_list_to_author(tmp_doc)
        except Exception:
            au = tmp_doc.get("author")
            if isinstance(au, str) and au:
                tmp_doc["author"] = au.title()

    if author_list_changed or other_changed:
        try:
            tmp_doc.save()
        except Exception:
            pass


def _regen_shared_bib(tmp_doc=None, *_args, **_kwargs):
    """Best-effort: walk the library for committed entries, union with the
    hook's tmp_doc (which for on_add_done is the just-added doc, not yet
    on disk in its final folder). Silent on failure — a stale bib.yml is
    better than a broken add/edit flow."""
    try:
        import papis.config
        import papis.document
        from papis.commands.export import run as export_run

        docs = []
        seen_refs = set()
        for lib_dir in papis.config.get_lib_dirs():
            lib_dir = os.path.expanduser(lib_dir)
            for info in glob(os.path.join(lib_dir, "*", "info.yaml")):
                try:
                    d = papis.document.from_folder(os.path.dirname(info))
                    docs.append(d)
                    if d.get("ref"):
                        seen_refs.add(d["ref"])
                except Exception:
                    continue

        if tmp_doc is not None:
            ref = tmp_doc.get("ref") if hasattr(tmp_doc, "get") else None
            if ref not in seen_refs:
                docs.append(tmp_doc)

        text = export_run(docs, "typst")
        with open(_BIB_OUT, "w", encoding="utf-8") as fd:
            fd.write(text)
    except Exception:
        pass


import papis.hooks

papis.hooks.add("on_add_done", _normalize_metadata)
papis.hooks.add("on_add_done", _regen_shared_bib)
papis.hooks.add("on_edit_done", _regen_shared_bib)
