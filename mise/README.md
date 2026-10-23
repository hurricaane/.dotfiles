# mise

Global configuration of [mise](https://mise.jdx.dev), the version manager for the tools that aren't installed from the package lists. `global.toml` is linked to `~/.config/mise/config.toml`.

## Requirements

- `mise` (installed and activated by Omarchy, see [fish](../fish/README.md))

## Tools

| Tool       | Version  | Notes                                                    |
| ---------- | -------- | -------------------------------------------------------- |
| `node`     | pinned   | Runtime for the npm-based tools below                    |
| `claude`   | `latest` | Claude Code                                              |
| `codex`    | `latest` |                                                          |
| `gemini`   | `latest` | Native modules (`keytar`, `node-pty`) are built for Node |
| `gh`       | `latest` | GitHub CLI                                               |
| `opencode` | `latest` |                                                          |

`[settings.upgrade] auto_prune = false`: `mise upgrade` keeps the old versions.

Run `mise install` after linking to install everything.

## Notes

- **Why `global.toml` and not `config.toml`**: mise reads `mise/config.toml` as a project config in the current directory, so inside this repo every mise command would fail until the file was trusted with `mise trust`.
- `mise use -g <tool>` writes through the symlink into `global.toml`, so changes show up as a diff here. Omarchy's own scripts also run `mise use -g` (for example to install Node), so check `git diff` after an Omarchy update.
- After changing the Node major version, reinstall `gemini` (`mise install -f gemini`): its native modules are compiled for a specific Node ABI.
