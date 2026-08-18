# templates/

Shared Typst styling for every note in the `~/research` vault. Change
something here and every note picks it up on the next preview refresh.

## Files

- `note.typ` — the template function `note-template(body)`. Applies
  vault-wide `#set` rules (block quotes with quote marks, etc.),
  renders the note's body, then appends the bibliography.
- `csl/` — Citation Style Language files fetched from
  [citation-style-language/styles](https://github.com/citation-style-language/styles).
  Current default: `taylor-and-francis-harvard-x.csl` (T&F Harvard,
  the style IJGIS submissions use).

## Using from a note

Every note (paper review or card) opens with:

```typst
#import "/templates/note.typ": note-template
#show: note-template

= Note title <label>

// ... body ...
```

The `/templates/note.typ` path is root-relative — resolved against
`~/research/typst.toml`, so any depth of nesting works.

New paper notes get this preamble automatically from
`~/.config/papis/notes-template.typ`. New cards get it from
`~/dotfiles/nvim/dot-config/nvim/lua/config/zettel.lua`
(`grounded_lines` / `ungrounded_lines`).

## Changing house style

Swap the CSL filename in `note.typ`:

```typst
bibliography("/bib.yml", style: "/templates/csl/<new-style>.csl")
```

Drop the new `.csl` into `csl/` first (fetch from the CSL styles
repo). Every note re-renders on next preview.

Built-in Typst style names (`"apa"`, `"mla"`, `"ieee"`,
`"chicago-author-date"`, `"chicago-notes"`,
`"harvard-cite-them-right"`) work too — no CSL file needed.

## Adding vault-wide styling

Add `#set` / `#show` rules inside `note-template(body) = { ... }`
before `body`. They apply to every note automatically.

Example — smaller headings and a serif body font:

```typst
set text(font: "New Computer Modern", size: 11pt)
show heading: it => text(size: 1.1em, it)
```
