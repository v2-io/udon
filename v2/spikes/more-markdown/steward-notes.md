# Steward notes: more-markdown spike

Joseph's statements during this spike, quoted verbatim. They are inputs for the later udon-markdown discussion, not for the dialect-landscape research, which ran without udon context. The report writer finished before this file was recreated here. The first copy is archived with the primed run at `~/.archive/udon-more-markdown-primed-2026-10-14/spike-dir/steward-notes.md`.

## 2026-10-14: losslessness and "streaming"

A primed-run researcher had asked whether the parsed prose tree must be lossless down to the byte, and what "streaming" meant.

> - parsed prose tree -- no, not necessarily lossless to the byte-- that's part of what we're discovering is what the expectations would/should be
> - don't know what "streaming" is being referenced. udon-lite doesn't stream, so not sure what they're talking about.

"Streaming" was a criterion the coordinator invented in a brief. udon-lite does not stream.

## 2026-10-14: djot as canonical udon-md?

The coordinator's answer was provisional: no, not as the undeclared default parse; a declared per-block djot is viable. Joseph replied:

> It's pretty common, in my experience, to see lists start right after paragraphs, and other newline variability. You are correct, and in many ways the strongest argument for me is that udon already does a lot of what djot is reaching for (including, interestingly enough, linear parsing that's very fast- except, ironically, this markdown prose section which will still be pretty fast via [comrak] I'll bet...)

So canonical udon-md keeps CommonMark's paragraph interruption. A list may follow a paragraph directly.

## 2026-10-14: wishes raised while the feature matrix was being extended

These came up during the matrix work. They may bear on what udon or udon-md should do natively.

> table cell linebreaks (usually with inline <br> but I wish there was a more layout-friendly way for agents)

> it would be nice if someone has a syntax for sparklines or something too :-)

## 2026-10-15: Unicode math

Said while the unprimed probes were running:

> We should note that most agents will usually write unicode math where they can instead of any delimiters/latex at all...

The single-prompt runs confirm this: `3.5 × 10⁸ m/s`, `21 °C`, `H₂O`, `2¹⁰` and `CH₄ + 2 O₂ → CO₂ + 2 H₂O` came back with no delimiters. `$…$` appeared only when a prompt asked for a typeset formula, or when the request was framed as source syntax. Analysis in `unprimed-fill.md`.
