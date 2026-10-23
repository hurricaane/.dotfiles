# workmux

Configuration of [workmux](https://github.com/raine/workmux), which pairs **git worktrees** with **tmux**: each task gets its own worktree, branch and tmux session, with Neovim and a Claude Code agent side by side. Linked to `~/.config/workmux`.

Open the dashboard with `prefix w` in tmux (popup), or run `wm` (fish abbreviation for `workmux`).

## Requirements

- `workmux`, `tmux`, `git`
- Claude Code (`claude`), the agent
- The `workmux-status` Claude Code plugin (enabled in [claude](../claude/README.md#plugins)), which reports each agent's state
- A Nerd Font

## Configuration

### Worktrees

| Setting                                 | Effect                                                                               |
| --------------------------------------- | ------------------------------------------------------------------------------------ |
| `mode: session`                         | Each worktree gets its own tmux session (instead of a window in the current session) |
| `worktree_dir: ../.worktrees/{project}` | Worktrees are created next to the repository, in `.worktrees/<project>/`             |
| `base_branch: auto`                     | New branches start from the main branch, not from the branch checked out             |
| `worktree_naming: full`                 | Worktree folders use the full branch name                                            |
| `merge_strategy: rebase`                | `workmux merge` rebases instead of creating a merge commit                           |
| `merge_keep: false`                     | The worktree and branch are removed after a merge                                    |
| `window_prefix: "{project}/"`           | tmux sessions are named `<project>/<branch>`, scoped by repository                   |

### Windows

Every new worktree session opens with two windows:

1. **editor**: Neovim on the left, the agent (`claude`) on the right at 35 % width, focused;
2. **shell**: an empty shell.

Since Neovim and Claude Code run in the same tmux window, Claude can connect to Neovim with `/ide` (see [nvim](../nvim/README.md#claude-code)).

### Agent status

`agent: claude`. The agent state shows as an icon in the tmux window name and in the dashboard (`prefix w`):

| State   | Icon color      |
| ------- | --------------- |
| working | mauve           |
| waiting | red (needs you) |
| done    | teal            |

### Dashboard theme

Catppuccin Mocha colors, matched to the tmux theme: blue for the current worktree, mauve headers and accents, lavender key hints.
