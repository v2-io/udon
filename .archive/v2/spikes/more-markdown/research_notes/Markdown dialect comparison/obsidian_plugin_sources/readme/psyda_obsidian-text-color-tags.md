# Text Color Tags

Simple inline text coloring for Obsidian. No markup pollution in your files.

## Usage

```
$red This text is red
$blue Blue text here
$ff5500 Custom hex color
$#00ff00 Also works with hash
```

**Behavior:**
- Click on colored text → reveals the `$color` syntax and swatch for editing
- Click elsewhere → syntax hides, just colored text visible
- Click swatch → opens color picker

**Right-click menu:**
- Text Color to add color at cursor or wrap selection

## Features

- **Named colors:** red, orange, yellow, green, blue, purple, pink, cyan, gray, white, black
- **Hex colors:** `$fff`, `$#ff5500`, etc.
- **Clickable swatches** with full color picker
- **8 vault swatches** (configurable in settings)
- **8 recent colors** auto-tracked
- **Context menu** integration

## Installation

### From Community Plugins
1. Open Settings → Community Plugins
2. Search "Text Color Tags"
3. Install and enable

### Manual
1. Download `main.js`, `manifest.json`, and `styles.css`
2. Create folder: `.obsidian/plugins/text-color-tags/`
3. Place files in folder
4. Enable in Settings → Community Plugins

## Settings

- **Vault Swatches:** Define 8 quick-access colors for your vault
- **Recent Colors:** Auto-populated as you use colors, can be cleared

## License

MIT