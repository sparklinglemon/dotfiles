#!/bin/bash
# Claude Code statusLine, two lines:
#   1) model name + reasoning effort + context-window usage + 5h session usage
#   2) git branch (omitted entirely outside a repo / in detached HEAD)
#
# Model, effort, context usage, and 5h session usage come straight from the
# stdin JSON - no shelling out for those. Parsed with python3 (jq is not
# installed on this host).

# Unit separator, not tab: tab counts as IFS whitespace, so `read` collapses
# runs of it and every field after an empty one shifts left. `effort` and
# `session` are absent when the model doesn't report effort or the account
# has no rate-limit data yet, which made those the common case, not an edge.
IFS=$'\x1f' read -r model effort used session dir <<<"$(python3 -c '
import json, re, sys
d = json.load(sys.stdin)
model = d.get("model", {}).get("display_name") or d.get("model", {}).get("id") or "?"
# Drop a trailing long-context annotation like "(1M context)" or "[1m]".
model = re.sub(r"\s*[\(\[][^)\]]+[\)\]]\s*$", "", model)
effort = d.get("effort", {}).get("level") or ""
pct = d.get("context_window", {}).get("used_percentage")
used = "-" if pct is None else str(round(float(pct)))
session_pct = d.get("rate_limits", {}).get("five_hour", {}).get("used_percentage")
session = "-" if session_pct is None else str(round(float(session_pct)))
cwd = d.get("workspace", {}).get("current_dir") or d.get("cwd") or "."
print(model, effort, used, session, cwd, sep="\x1f")
' 2>/dev/null)"

[ -n "$model" ] || exit 0

MAGENTA='\033[35m'; CYAN='\033[36m'; YELLOW='\033[33m'; RED='\033[31m'
GREEN='\033[32m'; DIM='\033[90m'; RESET='\033[0m'

# Segments are appended only when present, so the separator is added per-append
# rather than joined at the end - otherwise an absent segment leaves a stray "|".
line1="${MAGENTA}${model}${RESET}"
append() { line1="${line1} ${DIM}|${RESET} $1"; }
[ -n "$effort" ] && append "${CYAN}${effort}${RESET}"
[ "$used" != "-" ] && append "${YELLOW}${used}% ctx${RESET}"
[ "$session" != "-" ] && append "${RED}${session}% 5h${RESET}"

# Cheap branch lookup: a single lightweight git plumbing call, no status/log.
# Silently empty outside a repo or on detached HEAD - no error is printed.
branch=""
if [ -n "$dir" ]; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
fi

# Branch names in this repo run long (e.g. tharunm/axc-169-add-local-mock-api-...);
# truncate so the second line stays readable.
max_branch_len=60
if [ -n "$branch" ] && [ "${#branch}" -gt "$max_branch_len" ]; then
  branch="${branch:0:$((max_branch_len - 1))}…"
fi

if [ -n "$branch" ]; then
  printf '%b\n%b\n' "$line1" "${GREEN}${branch}${RESET}"
else
  printf '%b\n' "$line1"
fi
