# mise

Global configuration of [mise](https://mise.jdx.dev), the version manager for the tools that aren't installed from the package lists. `global.toml` is linked to `~/.config/mise/config.toml`.

## Requirements

- `mise` (installed and activated by Omarchy, see [fish](../fish/README.md))

## Tools

| Tool        | Version  | Notes                                                      |
| ----------- | -------- | ---------------------------------------------------------- |
| `node`      | `26`     | Replaces nvm.fish. Runtime for the npm-based tools below   |
| `python`    | `3.14`   | Replaces pyenv                                             |
| `pnpm`      | `latest` | Replaces the standalone install in `~/.local/share/pnpm`   |
| `bun`       | `latest` | Replaces the `~/.bun` install                              |
| `uv`        | `latest` | Replaces the standalone installer (`~/.local/bin/uv`)      |
| `go`        | `latest` | Replaces pacman's `go`                                     |
| `rust`      | `stable` | Replaces pacman's `rust`. rustup updates it in place       |
| `terraform` | `latest` | Projects pin their own (`required_version`)                |
| `opentofu`  | `latest` | Terraform fork (`tofu`)                                    |
| `kubectl`   | `latest` | Keep within one minor version of the cluster               |
| `helm`      | `latest` |                                                            |
| `kind`      | `latest` | Local Kubernetes clusters in Docker                        |
| `gitleaks`  | `latest` | Replaces pacman's `gitleaks`. Used by the global git hook  |
| `claude`    | `latest` | Claude Code                                                |
| `codex`     | `latest` |                                                            |
| `gemini`    | `latest` | Native modules (`keytar`, `node-pty`) are built for Node   |
| `gh`        | `latest` | GitHub CLI. Replaces pacman's `github-cli`                 |
| `opencode`  | `latest` |                                                            |

`[settings.upgrade] auto_prune = false`: `mise upgrade` keeps the old versions.

## Upgrading

Virtualenvs and native Node modules are built for one Python or Node install. When `mise upgrade` installs a new one, they keep running on the old one, which `mise prune` would delete. So:

1. `mise upgrade`
2. `just mise-rebuild` (`-n` for a dry run), which rebuilds on the current versions:
   - Python: virtualenvs anywhere in `~` (projects, `~/.local/share/claude-coworker`…), uv tools, Mason's pip packages and mise `pipx:`/`pypi:` tools still on an older mise Python. A virtualenv is recreated with the same packages, on the Python its project's `mise.toml` asks for.
   - Node, only when the major version changed: mise `npm:` tools (gemini, opencode) and Mason packages with native modules (tailwindcss-language-server).
3. `mise prune`, to delete the old versions

Most virtualenvs link to mise's `3.14` alias, which follows patch upgrades, so a patch release usually leaves nothing to rebuild. Projects' own `node_modules` aren't covered: run `pnpm rebuild` there after a Node major upgrade.

Run `mise install` after linking to install everything.

## Notes

- **Global CLI tools from npm or PyPI** go in this file with mise's `npm:` or `pipx:` backends (like the AI CLIs), not `pnpm add -g` or `bun add -g`: `PNPM_HOME` and `BUN_INSTALL` aren't set.

- **Why `global.toml` and not `config.toml`**: mise reads `mise/config.toml` as a project config in the current directory, so inside this repo every mise command would fail until the file was trusted with `mise trust`.
- `mise use -g <tool>` writes through the symlink into `global.toml`, so changes show up as a diff here. Omarchy's own scripts also run `mise use -g` (for example to install Node), so check `git diff` after an Omarchy update.
