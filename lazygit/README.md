# lazygit

Configuration of [lazygit](https://github.com/jesseduffield/lazygit), a terminal UI for Git. Linked to `~/.config/lazygit`.

Open it with `lg` in fish, or `prefix g` in tmux (popup in the current pane's directory).

## Requirements

- `lazygit`, `git`
- `git-delta` (diffs)
- A Nerd Font (v3 icons)
- For the AI commit message: [Claude Code](https://code.claude.com) (`claude` on `PATH`) and, optionally, `gitleaks`

## Configuration

- **Diffs** rendered by delta, side by side (`delta --dark --side-by-side --paging=never`).
- **Branch log**: the same colored one-line graph as the fish `glg` abbreviation.
- `overrideGpg: true`: lazygit commits itself even when commit signing is on, instead of handing over to a terminal. With SSH signing nothing needs to be typed, so it keeps the UI responsive.
- **Icons**: Nerd Fonts v3.
- **Theme**: Tokyo Night Moon colors (orange active border, blue inactive border).

## AI commit message

A custom command in the **Files** panel:

| Keys     | Action                                                     |
| -------- | ---------------------------------------------------------- |
| `Ctrl-k` | Commit the staged changes with a message written by Claude |

It runs `git commit -e -m "$(~/dotfiles/scripts/ai-commit-msg.sh)"` in a terminal:

1. `scripts/ai-commit-msg.sh` scans the staged changes with gitleaks first, and stops without sending anything if it finds a secret.
2. It sends the staged diff (lockfiles excluded, capped at 100 kB), the diff stat, the branch and the last 10 commit subjects to **Claude Haiku** (`claude -p --model haiku`, no tools, no MCP, no session saved).
3. Claude answers with a Conventional Commits message (`type(scope): subject`, 72 characters max, body wrapped at 72).
4. The message opens in the editor: save to commit, or quit without saving to cancel.

The same script backs the `gcai` abbreviation in fish.
