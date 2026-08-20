#import "/.templates/note.typ": back-link, highlight-box, note-template, source-link
#show: note-template

= {doc[ref]} - (Notes) {doc[title]} <{doc[ref]}-notes>

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + luma(220),
  [*Key*], [{doc[ref]}],
  [*Authors*], [{doc[author]}],
  [*Year*], [{doc[year]}],
  [*Type*], [{doc[type]}],
  [*Journal*], [{doc[journal]}],
  [*Booktitle*], [{doc[booktitle]}],
  [*Publisher*], [{doc[publisher]}],
  [*Volume*], [{doc[volume]}],
  [*Number*], [{doc[number]}],
  [*Issue*], [{doc[issue]}],
  [*Pages*], [{doc[pages]}],
  [*Month*], [{doc[month]}],
  [*DOI*], [{doc[doi]}],
  [*ISBN*], [{doc[isbn]}],
  [*URL*], [{doc[url]}],
  [*Keywords*], [{doc[keywords]}],
  [*Tags*], [{doc[tags]}],
  [*Citations*], [{doc[s2_citation_count]}],
  [*References*], [{doc[s2_reference_count]}],
  [*Influential*], [{doc[s2_influential_citation_count]}],
  [*Papis ID*], [{doc[papis_id]}],
  [*Added*], [{doc[time-added]}],
)

== Cards

// AUTO-CARDS BEGIN — managed by research-cards-daemon
// (no cards yet)
// AUTO-CARDS END

== Intentions

=== What is this paper's one claim?

=== What evidence would actually convince me?

=== How does it connect to what I already know?

== Claims

== Evidence

== Limits

== Links

