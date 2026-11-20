---
source: terminal-consoles.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/terminal-consoles.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [tui, console-architecture, human-ux]
why_included: >
  Dec 17 2025. TUI/console architecture research from the Gemini-CLI and Codex-CLI codebases (three-pane layout, input handling). Relevant if UDON tooling or a harness grows a console/TUI surface; human-side steering-surface witness.
---

# Terminal Console Architecture Research

**Date:** 2025-12-17
**Purpose:** Reference document for TUI console implementation patterns, based on exploration of Gemini CLI and Codex CLI codebases.

---

## The Three-Pane Layout Pattern

Modern CLI LLM tools share a common layout:

```
┌──────────────────────────────────────────────────┐
│  Scrollable History                               │  ← Grows upward, terminal scrollback
│  [user] Hello                                     │
│  [assistant] Hi there!                            │
├──────────────────────────────────────────────────┤
│  Input Area (bounded, expands as typing)          │  ← Dynamic height, stays visible
│  > Currently typing...                            │
├──────────────────────────────────────────────────┤
│  Model: opus · Context: 2% · INSERT               │  ← Fixed status (optional)
└──────────────────────────────────────────────────┘
```

**Key interaction pattern:**
1. User types in input area (nothing is scrolling)
2. Input area expands as content grows
3. On submit: message moves to scrollable history, input clears
4. Response streams/appears in history
5. Input area remains visible throughout

---

## Gemini CLI Implementation (TypeScript/Ink)

**Source:** `~/src/_ref/gemini-cli/`
**Stack:** React 19 + Ink (custom fork `@jrichman/ink@6.4.0`)

### Architecture Overview

Gemini CLI does **NOT use ANSI scroll regions (DECSTBM)**. Instead, it relies on Ink's React-based layout engine.

### Layout Structure

From `packages/core/src/app/layouts/DefaultAppLayout.tsx`:

```typescript
<Box flexDirection="column" width={width} height={terminalHeight - 1}>
  <MainContent />  {/* History pane */}

  <Box flexDirection="column" ref={mainControlsRef}>
    <Notifications />  {/* Status pane */}
    <Composer />        {/* Input pane - conditionally shown */}
    <ExitWarning />     {/* Additional status */}
  </Box>
</Box>
```

### Static vs Dynamic Content Pattern

The key innovation is splitting rendering into two parts:

From `MainContent.tsx`:

```typescript
// Completed history - rendered once with <Static>, then frozen
<Static key={uiState.historyRemountKey} items={historyItems}>
  {(item) => item}
</Static>

// Pending items - dynamic, updates during streaming
{pendingItems}
```

**Why this works:**
- `<Static>` component "freezes" rendered output and scrolls it up
- Prevents expensive re-renders of completed history
- Pending items update freely without affecting frozen history
- Messages split into separate items if >65,536 lines for performance

### Height Measurement Pattern

From `AppContainer.tsx`:

```typescript
import { useLayoutEffect, useState, useRef } from 'react';
import { measureElement, type DOMElement } from 'ink';

const mainControlsRef = useRef<DOMElement>(null);
const [controlsHeight, setControlsHeight] = useState(0);

useLayoutEffect(() => {
  if (mainControlsRef.current) {
    const measurement = measureElement(mainControlsRef.current);
    setControlsHeight(measurement.height);
  }
}, [buffer, terminalWidth, terminalHeight]);

// Available height for history = total - controls - padding
const availableTerminalHeight = Math.max(
  0,
  terminalHeight - controlsHeight - staticExtraHeight - 2,
);
```

### Streaming Response Handling

**Normal Mode (Default):**
```typescript
// History frozen via Static
<Static key={historyRemountKey} items={historyItems}>
  {(item) => item}
</Static>

// Streaming content appears here, updates visible at bottom
{pendingItems}

// Input always at bottom via flex order
<Composer />
```

**Alternate Buffer Mode** (placeholder, not fully implemented):
```typescript
<Box
  flexDirection="column"
  overflowY="scroll"
  scrollTop={Number.MAX_SAFE_INTEGER}  // Always scroll to bottom
  maxHeight={availableTerminalHeight}
>
  <Box flexDirection="column" flexShrink={0}>
    {historyItems}
    {pendingItems}
  </Box>
</Box>
```

### Scroll Handling

From `ScrollProvider.tsx`:

```typescript
const findScrollableCandidates = (mouseEvent, scrollables) => {
  // Find all scrollable regions containing mouse position
  // Sort by area (smallest first = innermost)
  // Return candidates in nesting order
};

useMouse((event) => {
  if (event.name === 'scroll-up') handleScroll('up', event);
  else if (event.name === 'scroll-down') handleScroll('down', event);
  else if (event.name === 'left-press') handleClick(event);
});
```

Mouse events are processed at the smallest enclosing scrollable region.

### VirtualizedList for Large Content

```typescript
const listRef = useRef<VirtualizedListRef<Item>>(null);

<ScrollableList
  ref={listRef}
  data={items}
  renderItem={({ item }) => <Text>{item.title}</Text>}
  estimatedItemHeight={() => 14}
  hasFocus={true}
  initialScrollIndex={Number.MAX_SAFE_INTEGER}  // Start at end
  initialScrollOffsetInIndex={Number.MAX_SAFE_INTEGER}
/>
```

### Dependencies

- **Ink** (custom fork `@jrichman/ink@6.4.0`) - React for TUIs
- **React 19.2.0** - Core UI framework
- **ansi-escapes** - Raw ANSI commands (e.g., `clearTerminal`)
- **string-width** - Measuring text width with wide characters
- **strip-ansi** - Removing ANSI codes for measurement

### Design Patterns Summary

| Pattern | Purpose | Implementation |
|---------|---------|----------------|
| Static Component | Prevent re-renders of history | Ink's `<Static>` wraps completed messages |
| Pending Items | Dynamic streaming updates | Separate render tree below static content |
| Height Measurement | Exact space allocation | `measureElement()` + state-driven layout |
| Scroll Context | Unified scroll handling | Mouse events delegated to innermost scrollable |
| Virtualization | Large list performance | VirtualizedList for data views |
| Split Messages | Streaming performance | Long responses split into multiple items |
| Sticky-to-Bottom | Auto-scroll behavior | Tracks scroll anchor with `SCROLL_TO_ITEM_END` |

### Deep Dive: How Ink's `<Static>` Actually Works

**Source:** `~/src/_ref/ink/` (cloned from github.com/vadimdemedes/ink)

The key insight: **Ink does NOT use scroll regions (DECSTBM)**. It uses a clear-and-redraw pattern with cursor manipulation.

#### The Static Component (Static.tsx)

```typescript
// Surprisingly simple!
export default function Static<T>(props: Props<T>) {
  const {items, children: render, style: customStyle} = props;
  const [index, setIndex] = useState(0);

  // Only render NEW items (items added since last render)
  const itemsToRender: T[] = useMemo(() => {
    return items.slice(index);
  }, [items, index]);

  // After render, remember we've rendered these
  useLayoutEffect(() => {
    setIndex(items.length);
  }, [items.length]);

  const children = itemsToRender.map((item, itemIndex) => {
    return render(item, index + itemIndex);
  });

  // internal_static flag tells renderer to collect this output separately
  return (
    <ink-box internal_static style={style}>
      {children}
    </ink-box>
  );
}
```

The `internal_static` attribute signals to the renderer that this content should be handled separately.

#### The Renderer (renderer.ts)

The renderer produces **two separate outputs**:

```typescript
const renderer = (node: DOMElement, isScreenReaderEnabled: boolean): Result => {
  // Render main content, SKIPPING static elements
  const output = new Output({...});
  renderNodeToOutput(node, output, { skipStaticElements: true });

  // Render static content separately
  let staticOutput;
  if (node.staticNode?.yogaNode) {
    staticOutput = new Output({...});
    renderNodeToOutput(node.staticNode, staticOutput, { skipStaticElements: false });
  }

  return {
    output: generatedOutput,
    outputHeight,
    staticOutput: staticOutput ? `${staticOutput.get().output}\n` : '',
  };
};
```

#### The Main Render Loop (ink.tsx)

Here's where the magic happens:

```typescript
onRender: () => void = () => {
  const {output, outputHeight, staticOutput} = render(this.rootNode, ...);

  const hasStaticOutput = staticOutput && staticOutput !== '\n';

  if (hasStaticOutput) {
    // 1. Clear the dynamic output (erase lines, cursor up)
    this.log.clear();

    // 2. Write static content (scrolls up naturally via terminal)
    this.options.stdout.write(staticOutput);

    // 3. Redraw dynamic output below it
    this.log(output);
  }

  if (!hasStaticOutput && output !== this.lastOutput) {
    this.throttledLog(output);
  }

  this.lastOutput = output;
  this.lastOutputHeight = outputHeight;
};
```

#### The Log Update Mechanism (log-update.ts)

The `log` object handles erasing and redrawing:

```typescript
const render = (str: string) => {
  const output = str + '\n';
  if (output === previousOutput) return;

  previousOutput = output;
  // Erase previous output, then write new output
  stream.write(ansiEscapes.eraseLines(previousLineCount) + output);
  previousLineCount = output.split('\n').length;
};

render.clear = () => {
  stream.write(ansiEscapes.eraseLines(previousLineCount));
  previousOutput = '';
  previousLineCount = 0;
};
```

#### The Escape Sequences (ansi-escapes)

`eraseLines` is simply:

```javascript
export const eraseLines = count => {
  let clear = '';
  for (let i = 0; i < count; i++) {
    clear += eraseLine + (i < count - 1 ? cursorUp() : '');
  }
  if (count) {
    clear += cursorLeft;
  }
  return clear;
};

// Where:
// eraseLine = ESC[2K  (erase entire line)
// cursorUp  = ESC[A   (move cursor up one line)
// cursorLeft = ESC[G  (move cursor to column 0)
```

#### Visual Flow

```
Frame 1:
┌────────────────┐
│ [dynamic UI]   │  ← log() renders here, tracks line count
└────────────────┘

Frame 2 (new static content arrives):
Step 1: log.clear()
  → For each line: ESC[2K (erase) + ESC[A (cursor up)
  → Cursor now at top of where dynamic UI was

Step 2: stdout.write(staticOutput)
  → Write static content
  → Terminal scrolls it up naturally into scrollback

Step 3: log(output)
  → Redraw dynamic UI at current cursor position

Result:
┌────────────────┐
│ [static - now  │  ← In terminal scrollback, "frozen"
│  in history]   │
├────────────────┤
│ [dynamic UI]   │  ← Redrawn fresh each frame
└────────────────┘
```

#### Why This Works

1. **Static content uses terminal's native scrollback** — just `stdout.write()`, terminal handles scrolling
2. **Dynamic content is erased and redrawn** — tracked by line count, cleared with cursor-up + erase-line
3. **The "freeze" is logical, not ANSI** — Ink just stops including old items in `<Static>` renders
4. **No DECSTBM needed** — simple cursor manipulation achieves the effect

#### Ruby Translation

The pattern translates directly to Ruby:

```ruby
class ConsoleRenderer
  def initialize(output = $stdout)
    @output = output
    @dynamic_line_count = 0
    @dynamic_content = ''
  end

  # Erase the dynamic area
  def clear_dynamic
    @dynamic_line_count.times do |i|
      @output.print "\e[2K"  # Erase line
      @output.print "\e[A" if i < @dynamic_line_count - 1  # Cursor up
    end
    @output.print "\e[G"  # Cursor to column 0
    @dynamic_line_count = 0
  end

  # Write content that becomes "frozen" (scrolls into history)
  def write_static(content)
    clear_dynamic
    @output.print content
    @output.print "\n" unless content.end_with?("\n")
  end

  # Write/update the dynamic area (input + status)
  def write_dynamic(content)
    if content != @dynamic_content
      clear_dynamic
      @output.print content
      @dynamic_content = content
      @dynamic_line_count = content.count("\n") + 1
    end
  end
end
```

---

## Codex CLI Implementation (Rust/Ratatui)

**Source:** `~/src/_ref/codex/`
**Stack:** Rust + Ratatui + Crossterm

### Architecture Overview

Codex **DOES use ANSI scroll regions (DECSTBM)** with a custom terminal wrapper that tracks inline viewports.

### Layout Structure

From `codex-rs/tui/src/chatwidget.rs`:

```rust
fn as_renderable(&self) -> RenderableItem<'_> {
    let active_cell_renderable = match &self.active_cell {
        Some(cell) => RenderableItem::Borrowed(cell).inset(Insets::tlbr(1, 0, 0, 0)),
        None => RenderableItem::Owned(Box::new(())),
    };

    let mut flex = FlexRenderable::new();
    flex.push(1, active_cell_renderable);  // Flex=1: history expands to fill
    flex.push(
        0,
        RenderableItem::Borrowed(&self.bottom_pane).inset(Insets::tlbr(1, 0, 0, 0)),
    );  // Flex=0: input fixed height at bottom

    RenderableItem::Owned(Box::new(flex))
}
```

**Key insight:** FlexRenderable divides screen into:
- **History pane** (flex=1): Takes remaining space, scrolls independently
- **Bottom pane** (flex=0): Input area with fixed height, always visible

### ANSI Scroll Regions (DECSTBM)

From `codex-rs/tui/src/insert_history.rs`:

```rust
/// Insert history lines above the viewport using scroll regions.
/// This is how streaming responses scroll without affecting the input.
pub fn insert_history_lines<B>(
    terminal: &mut crate::custom_terminal::Terminal<B>,
    lines: Vec<Line>,
) -> io::Result<()>
where
    B: Backend + Write,
{
    let area = terminal.viewport_area;
    let writer = terminal.backend_mut();

    // If viewport is not at bottom, scroll it down to make room
    if area.bottom() < screen_size.height {
        let scroll_amount = wrapped_lines.min(screen_size.height - area.bottom());

        // Set scroll region to [area.top()+1 .. screen_height] (1-based DECSTBM bounds)
        let top_1based = area.top() + 1;
        queue!(writer, SetScrollRegion(top_1based..screen_size.height))?;
        queue!(writer, MoveTo(0, area.top()))?;

        // Emit Reverse Index (RI: ESC M) to scroll the region upward
        for _ in 0..scroll_amount {
            queue!(writer, Print("\x1bM"))?;  // Reverse Index
        }
        queue!(writer, ResetScrollRegion)?;
    }

    // Now insert history in the scroll region [1 .. area.top()]
    queue!(writer, SetScrollRegion(1..area.top()))?;
    queue!(writer, MoveTo(0, cursor_top))?;

    for line in wrapped {
        queue!(writer, Print("\r\n"))?;
        // ... render line content
    }

    queue!(writer, ResetScrollRegion)?;

    Ok(())
}
```

**The ANSI commands used:**
- `ESC [ top ; bottom r` — Set scroll region (DECSTBM)
- `ESC M` — Reverse Index (scroll up within region)
- `ESC [ r` — Reset scroll region to full screen

**Visual diagram from code comments:**
```
┌─Screen───────────────────────┐
│┌╌Scroll region╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐│
│┆ (history scrolls here)      ┆│
│┆                            ┆│
│█╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘│  ← Viewport boundary
│╭─Input Area────────────────╮│
││ (stays fixed)              ││
│╰────────────────────────────╯│
└──────────────────────────────┘
```

### Custom Terminal with Viewport Tracking

From `codex-rs/tui/src/custom_terminal.rs`:

```rust
pub struct Terminal<B>
where
    B: Backend + Write,
{
    backend: B,
    buffers: [Buffer; 2],
    current: usize,
    pub viewport_area: Rect,  // KEY: tracks the inline viewport
    pub last_known_screen_size: Size,
    pub last_known_cursor_pos: Position,
}

impl<B> Terminal<B> {
    /// Sets the viewport area for inline rendering
    pub fn set_viewport_area(&mut self, area: Rect) {
        self.buffers[self.current].resize(area);
        self.buffers[1 - self.current].resize(area);
        self.viewport_area = area;
    }
}
```

**Why this matters:** Instead of using alternate screen mode (which takes over the whole terminal), Codex uses inline viewports. This preserves terminal scrollback history.

### Drawing/Rendering Flow

From `codex-rs/tui/src/app.rs`:

```rust
tui.draw(
    self.chat_widget.desired_height(tui.terminal.size()?.width),
    |frame| {
        self.chat_widget.render(frame.area(), frame.buffer);
    }
)?;
```

From `codex-rs/tui/src/tui.rs` (lines 488-571):

```rust
pub fn draw(
    &mut self,
    height: u16,  // Requested height from desired_height()
    draw_fn: impl FnOnce(&mut custom_terminal::Frame),
) -> Result<()> {
    std::io::stdout().sync_update(|_| {
        let terminal = &mut self.terminal;
        let size = terminal.size()?;

        let mut area = terminal.viewport_area;
        area.height = height.min(size.height);
        area.width = size.width;

        // If viewport exceeds screen bottom, scroll it up
        if area.bottom() > size.height {
            terminal
                .backend_mut()
                .scroll_region_up(0..area.top(), area.bottom() - size.height)?;
            area.y = size.height - area.height;
        }

        if area != terminal.viewport_area {
            terminal.clear()?;
            terminal.set_viewport_area(area);
        }

        // Insert any pending history lines from streaming
        if !self.pending_history_lines.is_empty() {
            insert_history_lines(terminal, self.pending_history_lines.clone())?;
            self.pending_history_lines.clear();
        }

        terminal.draw(|frame| {
            draw_fn(frame);
        })
    })?;

    Ok(())
}
```

### Streaming Response Handling

From `codex-rs/tui/src/streaming/controller.rs`:

```rust
pub(crate) fn push(&mut self, delta: &str) -> bool {
    state.collector.push_delta(delta);

    if delta.contains('\n') {
        let newly_completed = state.collector.commit_complete_lines();
        if !newly_completed.is_empty() {
            state.enqueue(newly_completed);
            return true;  // Trigger frame render
        }
    }

    false
}
```

**Key behavior:**
- Deltas collected until newline encountered
- Completed lines immediately queued for rendering
- Incomplete lines held in collector (shown in real-time)
- Input area **always remains visible** — rendered fresh every frame by FlexRenderable

### Dependencies

- **Ratatui** — Core TUI widget framework
- **Crossterm** — Low-level terminal control (ANSI codes, raw mode, events)
- **Custom Terminal wrapper** — Extends ratatui for inline viewports
- **Custom Renderable trait** — Flex layout algorithm similar to Flutter

### Design Patterns Summary

| Feature | Implementation | Benefit |
|---------|----------------|---------|
| Input always visible | Fixed-height bottom pane (flex=0) | No need to scroll to type |
| History scrolls independently | ANSI scroll regions above input | Preserves terminal scrollback |
| Inline viewport | Custom Terminal with viewport_area | No alternate screen flicker |
| Streaming rendered live | StreamController with newline gates | Responsive without full re-renders |
| Cursor position tracking | last_known_cursor_pos in Terminal | Accurate resume after suspend/Ctrl-Z |

---

## Comparison Summary

| Aspect | Gemini CLI | Codex CLI |
|--------|------------|-----------|
| **Language** | TypeScript | Rust |
| **Framework** | React/Ink | Ratatui + Crossterm |
| **Scroll Regions (DECSTBM)** | No | Yes |
| **Layout Engine** | Ink's flexbox | Custom FlexRenderable |
| **History Rendering** | `<Static>` freezes completed | Scroll region inserts above |
| **Streaming** | Pending items below frozen | Insert lines via scroll region |
| **Scrollback Preserved** | Via Ink's Static | Inline viewport (no alt screen) |
| **Complexity** | Higher (React paradigm) | Lower (direct ANSI control) |

---

## Implications for Autopax (Ruby)

### Two Viable Approaches

**Approach A: Ink-style (Clear-and-Redraw)**
- Simpler: just cursor-up + erase-line + redraw
- No DECSTBM needed
- Relies on terminal's native scrollback for history
- Proven by Gemini CLI at scale

**Approach B: Codex-style (Scroll Regions)**
- More "correct" ANSI usage
- Explicit control over what scrolls where
- More complex to implement
- Better for very long streaming outputs

### Recommended: Start with Ink-style

The Ink pattern is simpler and maps cleanly to Ruby:

1. **Track dynamic area line count**
2. **When history content arrives:** clear dynamic → write history → redraw dynamic
3. **Terminal handles scrollback naturally**

No special ANSI beyond:
- `ESC[2K` — Erase line
- `ESC[A` — Cursor up
- `ESC[G` — Cursor to column 0

### Ruby Library Landscape

No Ruby library provides either pattern. TTY toolkit provides basic cursor control but not this rendering model. We build it ourselves.

For the Ink-style approach, the core is ~30 lines (see Ruby Translation above).

For scroll regions (if needed later):

```ruby
# Set scroll region (DECSTBM)
def set_scroll_region(top, bottom)
  print "\e[#{top};#{bottom}r"
end

# Reset scroll region
def reset_scroll_region
  print "\e[r"
end

# Reverse Index (scroll up within region)
def reverse_index
  print "\eM"
end
```

### Existing Autopax TUI Infrastructure

Already have:
- `TUI::KittyKeys` — Kitty keyboard protocol (Shift+Enter, modifiers)
- `TUI::LineBuffer` — Text editing buffer
- `TUI::LineRenderer` — Basic ANSI rendering
- `TUI::Prompt` — Multi-line input capture
- `TUI::Testing::KittyHarness` — Kitty remote control testing

---

## References

- [ANSI Escape Sequences](https://vt100.net/docs/vt100-ug/chapter3.html) — Scroll region reference
- [Kitty Keyboard Protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
- [Kitty Remote Control](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Bubble Tea](https://github.com/charmbracelet/bubbletea) — Elm Architecture reference (Go)
- [Bubbles](https://github.com/charmbracelet/bubbles) — Viewport, TextArea components (Go)
- [Ratatui](https://ratatui.rs/) — Rust TUI framework, constraint-based layout
- [Ink](https://github.com/vadimdemedes/ink) — React for CLIs (TypeScript)
