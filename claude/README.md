# Claude Code

Configuration of [Claude Code](https://code.claude.com): global instructions, settings, hooks, status line, theme and personal skills.

`~/.claude` also holds Claude Code's own state (sessions, caches, plugins), so the files here are **linked one by one**, not as a folder:

| Source             | Target                       |
| ------------------ | ---------------------------- |
| `CLAUDE.md`        | `~/.claude/CLAUDE.md`        |
| `RTK.md`           | `~/.claude/RTK.md`           |
| `settings.json`    | `~/.claude/settings.json`    |
| `keybindings.json` | `~/.claude/keybindings.json` |
| `statusline.sh`    | `~/.claude/statusline.sh`    |
| `ctxline.js`       | `~/.claude/ctxline.js`       |
| `themes/`          | `~/.claude/themes`           |
| `skills/<name>/`   | `~/.claude/skills/<name>`    |

To link a new skill, add a line to `links/cli.txt`.

## Requirements

- Claude Code (`claude`)
- `node` (status line), `jq`
- [rtk](../rtk/README.md) and [atuin](https://atuin.sh) (hooks)
- A Nerd Font (status line icons)

## Global instructions

`CLAUDE.md` is loaded in every project. It only imports `RTK.md` (`@RTK.md`), which explains to Claude that command output is condensed by RTK, and when to use `rtk bypass <cmd>` to see the raw output.

## settings.json

### General

- `permissions.defaultMode = "auto"`.
- `tui = "fullscreen"`.
- **Vim mode** in the prompt (`editorMode = "vim"`), with `jk` to leave insert mode, like in Neovim and fish.

### Hooks

| Event                                                    | Command                  | Purpose                                               |
| -------------------------------------------------------- | ------------------------ | ----------------------------------------------------- |
| `PreToolUse` (Bash)                                      | `rtk hook claude`        | Rewrites commands so their output is condensed by RTK |
| `PreToolUse`, `PostToolUse`, `PostToolUseFailure` (Bash) | `atuin hook claude-code` | Records Claude's shell commands in the atuin history  |

The atuin hook calls `$HOME/.atuin/bin/atuin` (atuin's installer location), so it works whatever the user name.

### Plugins

Enabled: [superpowers](https://github.com/obra/superpowers), context7, typescript-lsp, and workmux-status (shows each agent's state in the [workmux](../workmux/README.md) dashboard and tmux window names). The `workmux` and `worktrunk` marketplaces are declared in `extraKnownMarketplaces`.

`skillOverrides` turns off skills I keep installed but don't want Claude to trigger by itself (`humanizer`, `graphify`, `craft`…). They can still be called by name.

## Keybindings

`keybindings.json` adds keyboard scrolling of the conversation in the fullscreen view, without opening the transcript (`Ctrl+O`):

| Key      | Action                  |
| -------- | ----------------------- |
| `Ctrl+B` | Scroll half a page up   |
| `Ctrl+F` | Scroll half a page down |

They replace the prompt's move-one-character-back/forward (arrows and vim `h`/`l` still do that). All other `Ctrl` keys already do something in the prompt.

## Status line

`statusline.sh` draws a **vim mode badge** (NORMAL in blue, INSERT in green, VISUAL in mauve, Catppuccin Mocha like lualine in Neovim), then hands the session JSON to `ctxline.js`.

[ctxline](https://github.com/MithunWijayasiri/ctxline-claude) shows the directory, git branch, model, context usage bar, usage limits, cost and current task. The script also:

- shrinks `COLUMNS` by the badge width, so ctxline wraps correctly;
- replaces ctxline's plain Unicode symbols with Nerd Font icons (the fallback font draws them tiny).

`ctxline.js` is a vendored copy. Update it with:

```sh
curl -fsSL -o ~/dotfiles/claude/ctxline.js https://raw.githubusercontent.com/MithunWijayasiri/ctxline-claude/main/statusline.js
```

Don't use `npx ctxline-claude@latest`: it rewrites `settings.json`.

Subagents get a status line too (`ctxline.js subagent`). Claude Code's own vim mode indicator is hidden, since the badge replaces it.

## Theme

`themes/omarchy.json`: a custom dark theme named **Omarchy**, with Catppuccin Mocha colors (blue accent) to match the terminal. Pick it with `/theme`.

## Skills

| Skill           | Description                                                                    |
| --------------- | ------------------------------------------------------------------------------ |
| `craft`         | Brief-then-build flow for a new feature: shape discovery, visual checks, build |
| `graphify`      | Turns code, docs or media into a knowledge graph and answers questions with it |
| `humanizer`     | Removes signs of AI-generated writing from a text                              |
| `ui-ux-pro-max` | UI/UX design database (styles, palettes, fonts, stacks) with search scripts    |

`craft`, `graphify` and `humanizer` are turned off for automatic use (see `skillOverrides`): call them explicitly, e.g. `/humanizer`.
