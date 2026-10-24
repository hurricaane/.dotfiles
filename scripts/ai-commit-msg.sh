#!/usr/bin/env bash
set -euo pipefail

# Print a commit message for the staged changes, written by Claude Haiku.
# Usage:
#   git commit -e -m "$(./ai-commit-msg.sh)"

if git diff --cached --quiet; then
  echo "ai-commit-msg: nothing staged" >&2
  exit 1
fi

# Scan for secrets before the diff is sent to Claude: this script runs before
# `git commit`, so the pre-commit hook would only catch them afterwards
if command -v gitleaks >/dev/null &&
  ! gitleaks git --pre-commit --staged --redact --verbose --no-banner --log-level warn >&2; then
  echo "ai-commit-msg: secrets found in the staged changes, nothing sent to Claude" >&2
  exit 1
fi

# Keep lockfiles out of the diff (noise, and expensive in tokens); the stat still lists them
exclude=(':(exclude)*.lock' ':(exclude)*-lock.json' ':(exclude)*-lock.yaml' ':(exclude)nvim-pack-lock.json')
diff_stat=$(git diff --cached --stat)
# Truncated to 100 KB: no pipefail here, or git's SIGPIPE when head stops reading a larger diff kills the script
diff=$(set +o pipefail; git diff --cached -- . "${exclude[@]}" | head -c 100000)
branch=$(git branch --show-current)
recent_commits=$(git log -10 --format='- %s' 2>/dev/null || true)

prompt=$(cat <<EOF
Write a commit message for the staged changes below.

<format>
- Subject line: 72 characters maximum, including the type and scope
- For material changes, add a blank line then a body paragraph explaining the change
- Wrap the body at 72 chars
- Output only the commit message, no quotes or code blocks
</format>

<style>
- Imperative mood: "Add feature" not "Added feature"
- Use conventional commits, lowercase after the colon: "feat(nvim): add x"
- Describe the change, not the intent or benefit
</style>

<priorities>
- Base the message on the diff; it is the only source of truth
- The format and style rules above always apply
- Recent commits are context only: reuse a scope or term from them when it
  fits this change, but never copy their format if it breaks the rules above
</priorities>

<diffstat>
$diff_stat
</diffstat>

<diff>
$diff
</diff>

<context>
Branch: $branch
<recent_commits>
$recent_commits
</recent_commits>
</context>
EOF
)

MAX_THINKING_TOKENS=0 claude -p \
  --model haiku \
  --tools "" \
  --strict-mcp-config \
  --disable-slash-commands \
  --no-session-persistence \
  --setting-sources "" \
  --system-prompt "" \
  <<<"$prompt" |
  # Drop code fences: the model sometimes adds them despite the prompt
  sed '/^[[:space:]]*```/d' |
  # Rewrap the body at 72 chars ourselves: the model doesn't always do it. Join each
  # paragraph or list item into one line first, so rewrapping leaves no orphan words
  {
    IFS= read -r subject
    printf '%s\n' "$subject"
    awk '
      NF == 0 { if (p != "") print p; p = ""; print; next }
      /^[[:space:]]*([-*]|[0-9]+\.)[[:space:]]/ { if (p != "") print p; p = $0; next }
      { sub(/^[[:space:]]+/, ""); p = (p == "" ? $0 : p " " $0) }
      END { if (p != "") print p }' |
      fmt -s -w 72 | sed 's/ *$//'
  }
