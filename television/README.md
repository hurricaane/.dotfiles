# Television

Configuration of [Television](https://github.com/alexpasmantier/television) (`tv`), a fast fuzzy finder built around **channels**: each channel defines what to list, how to preview it and what to do with the selection. Linked to `~/.config/television`.

It is the picker behind [sesh](../sesh/README.md) and is wired into fish for autocompletion.

## Requirements

- `tv`
- Each channel lists its own requirements in its `[metadata]` (`fd`, `bat`, `git`, `docker`, `gh`…). A channel whose tools are missing just won't work.

## Structure

```text
television/
├── config.toml   # UI, key bindings, shell integration
└── cable/        # Channels, one TOML file each
```

## config.toml

- **Default channel**: `files`.
- **UI**: landscape layout, input bar at the top, rounded borders, preview panel at 50 % with a scrollbar. The help panel is hidden (`Ctrl-h`).

### Key bindings

| Keys                    | Action                                  |
| ----------------------- | --------------------------------------- |
| `Ctrl-j` / `Ctrl-k`     | Next / previous entry (also `Ctrl-n/p`) |
| `Tab` / `Shift-Tab`     | Select the entry and move down / up     |
| `Enter`                 | Confirm                                 |
| `Esc`, `Ctrl-c`         | Quit                                    |
| `Ctrl-s`                | Cycle the channel's sources             |
| `Ctrl-f`                | Cycle the previews                      |
| `Ctrl-o`                | Toggle the preview                      |
| `Ctrl-t`                | Remote control (switch channel)         |
| `Ctrl-x`                | Action picker                           |
| `Ctrl-y`                | Copy the entry                          |
| `Ctrl-r`                | Reload the source                       |
| `Ctrl-l`                | Toggle the layout                       |
| `PageUp` / `PageDown`   | Scroll the preview                      |
| `Ctrl-up` / `Ctrl-down` | Previous / next search from history     |

### Shell integration

`tv init fish` (in `config.fish`) adds:

- `Ctrl-t`: **smart autocomplete**. The channel depends on the command already typed:

  | Command typed                               | Channel         |
  | ------------------------------------------- | --------------- |
  | `cd`, `ls`, `z`, `rmdir`                    | `dirs`          |
  | `cat`, `bat`, `cp`, `mv`, `rm`, `tar`…      | `files`         |
  | `git add`, `git restore`                    | `git-diff`      |
  | `git checkout`, `git branch`, `git rebase`… | `git-branch`    |
  | `git log`, `git show`                       | `git-log`       |
  | `nvim`, `code`, `git clone`                 | `git-repos`     |
  | `docker run`                                | `docker-images` |
  | `export`, `unset` / `alias`, `unalias`      | `env` / `alias` |
  | anything else                               | `files`         |

- `Ctrl-r` is bound by Television's integration to `command_history`, but fish rebinds it to atuin in insert mode (see [fish](../fish/README.md#key-bindings)).

## Channels

Most files in `cable/` are the community channels (`tv update-channels`): git (branches, log, diff, stash, worktrees, repos…), docker, GitHub PRs and issues (`gh`), systemd units, processes, ports, man pages, fonts, env, PATH… Run `tv list-channels` to see them all, and `tv <channel>` to open one.

Customized channels:

### sesh

`cable/sesh.toml`: the sesh session picker (`tv sesh`).

- Sources, cycled with `Ctrl-s`: all sessions, tmux sessions only, configs, zoxide directories, and directories under `~` (`fd`, depth 2).
- Preview: `sesh preview`.
- `Enter` runs `sesh connect`; `Ctrl-d` kills the selected tmux session and reloads the list.

### dotfiles

`cable/dotfiles.toml`: every file in `~/.config` with a bat preview; `Enter` opens it in `$EDITOR`. Its commands use fish syntax (`shell = "fish"`), like the other channels migrated to fish.
