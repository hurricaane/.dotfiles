# RTK

Configuration of [RTK](https://github.com/rtk-ai/rtk), a proxy that **condenses command output** before it reaches an AI agent: it keeps errors and useful lines and drops the noise (progress bars, long listings, repeated lines), to save tokens. Linked to `~/.config/rtk`.

## How it's used

Claude Code runs every Bash command through RTK, with a `PreToolUse` hook in [claude/settings.json](../claude/README.md#hooks) (`rtk hook claude`). `claude/RTK.md`, loaded in every session, tells Claude that the output is condensed and to re-run a command with `rtk bypass <cmd>` when the result is unusable.

Useful commands:

- `rtk gain`: tokens saved so far (needs tracking, which is on).
- `rtk bypass <cmd>`: run a command without filtering.

## Requirements

- `rtk` (installed in `~/.local/bin`, not from the package lists)

## config.toml

| Section     | Setting                                                                                                  |
| ----------- | -------------------------------------------------------------------------------------------------------- |
| `tracking`  | On, 90 days of history (for `rtk gain`)                                                                  |
| `display`   | Colors and emoji, 120 columns max                                                                        |
| `filters`   | Ignores `.git`, `node_modules`, `target`, `__pycache__`, `.venv`, `vendor`, lockfiles and minified files |
| `telemetry` | Off                                                                                                      |
| `limits`    | grep: 200 results, 25 per file; git status: 15 files, 10 untracked; passthrough: 2000 characters         |
| `retriever` | Full outputs kept in SQLite (up to 20 files of 1 MB), so a truncated result can be recovered             |

## filters.toml

Global custom filters, applied in every project (a project's `.rtk/filters.toml` takes precedence). Empty for now: it only holds the commented example from RTK.
