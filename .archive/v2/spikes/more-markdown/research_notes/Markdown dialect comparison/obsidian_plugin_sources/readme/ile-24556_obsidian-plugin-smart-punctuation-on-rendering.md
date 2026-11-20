# Obsidian *Smart Punctuation on Rendering* plugin

Renders ASCII punctuation characters in typographic forms, so you don’t have to struggle to enter desired characters in different editors anymore, for a better reading view.

<div style="font-family: serif;">

| Source | Rendered |
| ------ | -------- |
| `--`   | –        |
| `---`  | —        |
| `...`  | …        |
| `""`   | “”       |
| `''`   | ‘’       |

</div>

## Limitations

- Live Preview is not supported.
- It may break some elements.
- It may slow down the rendering of a huge note.
- It cannot recognize backslash escaping (e.g. `\-\-`),
  since it receives already rendered HTML documents (`--`).
  If you really want to avoid character replacements,
  please use zero-width spaces (`-&ZeroWidthSpace;-`).
- It cannot handle complex text because it uses simple regexes and is not aware of AST.
  Known issues are the following:
  - [Element containing a callout is not modified](https://github.com/ile-24556/obsidian-plugin-smart-punctuation-on-rendering/issues/10).
  - [Element containing a Mermaid diagram is not modified](https://github.com/ile-24556/obsidian-plugin-smart-punctuation-on-rendering/issues/16).
  - [Element holding links with URI containing specific characters are ignored](https://github.com/ile-24556/obsidian-plugin-smart-punctuation-on-rendering/issues/17).

## Alternatives

If you want to replace text when you type, consider using another plugin.
Of course you can use both plugins:
Even the notes you wrote before introducing Smart Typography will be rendered as you wish.

Additionally, your system may have relevant settings as [macOS does].

[macOS does]: https://support.apple.com/guide/mac-help/mh35735/mac

## Acknowledgement

Test cases are taken from a reference implementation of [CommonMark], [commonmark.js].

[CommonMark]: https://commonmark.org/
[commonmark.js]: https://github.com/commonmark/commonmark.js
