#!/usr/bin/env python3
"""Convert a historical Grok session into memory-shaped Markdown (offline).

This is a *spike* converter for bulk-import planning. It does **not** call an LLM
and therefore cannot reproduce `/flush` quality. It produces:

1. A metadata-style summary (closer to automatic session-end save).
2. Optionally a flush-shaped skeleton with user topics filled in.

Live import path (after review):
  cp samples/*.md ~/.grok/memory/udon-4fdadfea/sessions/
  # With memory enabled in a Grok session, the file watcher reindexes on next
  # memory_search / first-turn injection. Do NOT hand-edit index.sqlite.

Usage:
  python3 convert_session_to_memory_md.py <session-id> [--out DIR]
  python3 convert_session_to_memory_md.py --list-udon
  python3 convert_session_to_memory_md.py --export-first <session-id>  # also runs grok export

Safety:
  - Never writes under ~/.grok/ by default.
  - Never deletes sessions.
  - Default output: ./samples/ next to this script.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from urllib.parse import quote

HOME = Path.home()
GROK_SESSIONS = HOME / ".grok" / "sessions"
DEFAULT_UDON_CWD = "/Users/josephwecker-v2/src/udon"
SPIKE_DIR = Path(__file__).resolve().parent
DEFAULT_OUT = SPIKE_DIR / "samples"


def encoded_cwd(cwd: str) -> str:
    return quote(cwd, safe="")


def session_dir(session_id: str, cwd: str = DEFAULT_UDON_CWD) -> Path:
    return GROK_SESSIONS / encoded_cwd(cwd) / session_id


def find_session(session_id: str) -> Path:
    """Locate a session dir by id under any cwd group."""
    # Prefer exact udon roots first
    candidates = [
        session_dir(session_id, DEFAULT_UDON_CWD),
        session_dir(session_id, f"{DEFAULT_UDON_CWD}/spec/msc/greenfield-3b"),
    ]
    for c in candidates:
        if (c / "summary.json").exists():
            return c
    for group in GROK_SESSIONS.iterdir():
        if not group.is_dir():
            continue
        d = group / session_id
        if (d / "summary.json").exists():
            return d
    raise FileNotFoundError(f"session not found: {session_id}")


def load_summary(sess: Path) -> dict[str, Any]:
    return json.loads((sess / "summary.json").read_text())


def extract_user_topics(chat_path: Path, limit: int = 8) -> list[str]:
    if not chat_path.exists():
        return []
    topics: list[str] = []
    seen: set[str] = set()
    with chat_path.open(errors="replace") as fh:
        for line in fh:
            try:
                o = json.loads(line)
            except json.JSONDecodeError:
                continue
            if o.get("type") != "user" or o.get("synthetic_reason"):
                continue
            content = o.get("content")
            texts: list[str] = []
            if isinstance(content, list):
                for c in content:
                    if isinstance(c, dict) and c.get("type") == "text":
                        texts.append(c.get("text") or "")
            elif isinstance(content, str):
                texts.append(content)
            text = "\n".join(texts).strip()
            if text.startswith(("<user_info>", "<system-reminder>", "<environment")):
                continue
            cleaned = re.sub(r"<[^>]+>", " ", text)
            cleaned = re.sub(r"\s+", " ", cleaned).strip()
            if len(cleaned) < 20:
                continue
            if cleaned.startswith(("OS Version:", "As you answer", "You are Grok")):
                continue
            key = cleaned[:80]
            if key in seen:
                continue
            seen.add(key)
            topics.append(cleaned[:500])
            if len(topics) >= limit:
                break
    return topics


def render_metadata(summary: dict[str, Any], sid: str, topics: list[str], source: Path) -> str:
    title = summary.get("generated_title") or summary.get("session_summary") or "(untitled)"
    cwd = (summary.get("info") or {}).get("cwd")
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
    lines = [
        "# Session metadata summary (imported; non-LLM)",
        "",
        f"- **Session ID:** `{sid}`",
        f"- **Title:** {title}",
        f"- **Created:** {summary.get('created_at')}",
        f"- **Updated:** {summary.get('updated_at')}",
        f"- **Messages:** {summary.get('num_messages')} updates / {summary.get('num_chat_messages')} chat",
        f"- **Model:** {summary.get('current_model_id')}",
        f"- **CWD:** {cwd}",
        f"- **Branch:** {summary.get('head_branch')}",
        "- **Import note:** Offline conversion. Prefer LLM `/flush` body for live memory quality.",
        "",
        "## Topics (first substantive user prompts)",
        "",
    ]
    if topics:
        for i, t in enumerate(topics[:5], 1):
            lines.append(f"{i}. {t}")
    else:
        lines.append("*(no substantive user prompts extracted)*")
    lines += [
        "",
        "## Source",
        "",
        f"- Raw session dir: `{source}`",
        f"- Full transcript: `grok export {sid} /path/to/out.md`",
        "",
        f"<!-- imported-metadata {now} UTC -->",
        "",
    ]
    return "\n".join(lines)


def render_flush_skeleton(summary: dict[str, Any], sid: str, topics: list[str]) -> str:
    title = summary.get("generated_title") or summary.get("session_summary") or "(untitled)"
    created = str(summary.get("created_at") or "")[:10]
    updated = str(summary.get("updated_at") or "")[:10]
    lines = [
        f"# Imported historical session — {title}",
        "",
        f"> Source: Grok session `{sid}` ({created} → {updated})",
        "> Conversion: offline skeleton — replace sections with an LLM summary before live drop-in.",
        "",
        "## Decisions & rationale",
        "",
        f"- *(fill via LLM summary of `grok export {sid}` output, or resume with memory and `/flush`)*",
        "",
        "## Technical context",
        "",
        "### Session identity",
        f"- Title: {title}",
        f"- Model: {summary.get('current_model_id')}",
        f"- Agent: {summary.get('agent_name')}",
        f"- Head: `{summary.get('head_branch')}` @ `{str(summary.get('head_commit') or '')[:12]}`",
        "",
        "### User topics captured from chat_history",
    ]
    if topics:
        for t in topics[:5]:
            lines.append(f"- {t[:240]}")
    else:
        lines.append("- *(none extracted)*")
    lines += [
        "",
        "## Problems & solutions",
        "",
        "- *(fill from transcript)*",
        "",
        "---",
        "",
        "<!-- imported-skeleton -->",
        "",
    ]
    return "\n".join(lines)


def list_udon_sessions() -> None:
    groups = [
        GROK_SESSIONS / encoded_cwd(DEFAULT_UDON_CWD),
        GROK_SESSIONS / encoded_cwd(f"{DEFAULT_UDON_CWD}/spec/msc/greenfield-3b"),
    ]
    for group in groups:
        if not group.exists():
            continue
        print(f"## {group.name}")
        for d in sorted(group.iterdir()):
            if not d.is_dir():
                continue
            sj = d / "summary.json"
            if not sj.exists():
                continue
            s = json.loads(sj.read_text())
            title = s.get("generated_title") or s.get("session_summary") or ""
            print(
                f"{d.name}  {s.get('created_at','?')[:10]}  "
                f"msgs={s.get('num_messages')}  {title[:70]}"
            )


def maybe_export(sid: str, out_md: Path) -> None:
    grok = HOME / ".grok" / "bin" / "grok"
    cmd = [str(grok) if grok.exists() else "grok", "export", sid, str(out_md)]
    print("running:", " ".join(cmd), file=sys.stderr)
    subprocess.run(cmd, check=False)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("session_id", nargs="?", help="Grok session UUID")
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT, help="Output directory (default: ./samples)")
    ap.add_argument("--list-udon", action="store_true", help="List udon-related Grok sessions")
    ap.add_argument("--export-first", action="store_true", help="Also run `grok export` into out/")
    ap.add_argument("--cwd", default=DEFAULT_UDON_CWD, help="Working directory group to prefer")
    args = ap.parse_args()

    if args.list_udon:
        list_udon_sessions()
        return 0
    if not args.session_id:
        ap.error("session_id required unless --list-udon")

    sess = find_session(args.session_id)
    summary = load_summary(sess)
    topics = extract_user_topics(sess / "chat_history.jsonl")
    sid = args.session_id
    date = str(summary.get("created_at") or "unknown")[:10]
    args.out.mkdir(parents=True, exist_ok=True)

    meta_path = args.out / f"{date}-import-{sid[:8]}-metadata.md"
    skel_path = args.out / f"{date}-import-{sid[:8]}-flush-skeleton.md"
    meta_path.write_text(render_metadata(summary, sid, topics, sess))
    skel_path.write_text(render_flush_skeleton(summary, sid, topics))
    print(f"wrote {meta_path}")
    print(f"wrote {skel_path}")

    if args.export_first:
        export_path = args.out / f"{date}-export-{sid[:8]}.md"
        maybe_export(sid, export_path)
        if export_path.exists():
            print(f"wrote {export_path} ({export_path.stat().st_size} bytes)")

    print(
        "\nNext (manual, after review):\n"
        f"  # Prefer enriching skeleton with LLM summary first\n"
        f"  cp {skel_path} ~/.grok/memory/udon-4fdadfea/sessions/\n"
        "  # Then open grok --experimental-memory and query memory, or /dream\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
