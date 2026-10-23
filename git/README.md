# Git

Global [Git](https://git-scm.com) configuration, global ignore file and **global hooks**. Linked to `~/.config/git` (Git reads `~/.config/git/config` when there is no `~/.gitconfig`).

## Requirements

- `git`
- [`git-delta`](https://github.com/dandavison/delta): pager and interactive diff filter
- [`gitleaks`](https://github.com/gitleaks/gitleaks): secret scan in the pre-commit hook (skipped with a warning when missing)

## Structure

```text
git/
├── config          # Global config
├── ignore          # Global gitignore (core.excludesFile default location)
├── hooks/          # Global hooks (core.hooksPath)
│   ├── _dispatch   # The only real script
│   └── pre-commit, commit-msg, pre-push…  → symlinks to _dispatch
└── config.local    # Machine-specific settings, gitignored (create it yourself)
```

## Configuration

### Behavior

| Setting                                       | Effect                                                             |
| --------------------------------------------- | ------------------------------------------------------------------ |
| `init.defaultBranch = main`                   | New repos start on `main`                                          |
| `pull.rebase = true`                          | `git pull` rebases instead of merging                              |
| `rebase.autoStash = true`                     | Uncommitted changes are stashed and restored around a rebase       |
| `rebase.missingCommitsCheck = warn`           | Warns when a commit line is deleted in an interactive rebase       |
| `push.autoSetupRemote = true`                 | First push of a branch sets its upstream                           |
| `push.followTags = true`                      | Annotated tags are pushed with their commits                       |
| `push.useForceIfIncludes = true`              | Safer `--force-with-lease`                                         |
| `fetch.prune`, `fetch.pruneTags`, `fetch.all` | Fetch every remote and drop deleted branches and tags              |
| `merge.conflictstyle = zdiff3`                | Conflicts also show the common ancestor                            |
| `rerere.enabled`, `rerere.autoupdate`         | Conflict resolutions are remembered and reapplied                  |
| `commit.verbose = true`                       | The diff is shown in the commit message editor                     |
| `diff.algorithm = histogram`                  | Better diffs, with moved lines colored (`colorMoved = plain`)      |
| `branch.sort = -committerdate`                | `git branch` lists the most recent branches first                  |
| `tag.sort = version:refname`                  | Tags sorted as versions                                            |
| `status.showUntrackedFiles = all`             | Untracked files listed one by one, with the branch and stash count |

Most `advice.*` hints are turned off.

### delta

[delta](https://github.com/dandavison/delta) is the pager and the `git add -p` filter: side by side, line numbers, hyperlinks, `n`/`N` to move between files. `interactive.singleKey` answers `git add -p` prompts without `Enter`.

### Machine-specific settings

The last section of `config` includes `config.local`, which is gitignored (as is `allowed_signers`). Put there what differs between machines, such as commit signing:

```ini
[user]
  signingkey = ~/.ssh/id_ed25519.pub
[gpg]
  format = ssh
[gpg "ssh"]
  allowedSignersFile = ~/.config/git/allowed_signers
[commit]
  gpgsign = true
[tag]
  gpgsign = true
```

Being included last, it overrides anything above it. Git ignores it when the file doesn't exist.

## Global hooks

`core.hooksPath = ~/.config/git/hooks` makes Git use this folder for **every repository**. Every hook name is a symlink to `_dispatch`, which:

1. on `pre-commit`, scans the staged changes with **gitleaks** and blocks the commit when it finds a secret (values redacted in the output);
2. then runs the repository's own hook from `.git/hooks/<name>`, if it exists and is executable. Git would otherwise skip it, because `core.hooksPath` replaces `.git/hooks`.

- False positive: add its fingerprint to `.gitleaksignore` in the repo, or commit with `--no-verify`.
- Repositories that set their own `core.hooksPath` (husky…) bypass these hooks entirely.
- Worktrees work: the repository hook is looked up in the common git dir.

To add a check for every repo, add it to `_dispatch` under the hook name. To support a new hook name, create a symlink: `ln -s _dispatch <hook-name>`.

## Global ignore

`ignore` holds patterns ignored in every repository: `**/.claude/settings.local.json` (Claude Code's local permissions).

## Related

- [lazygit](../lazygit/README.md) and the fish [git abbreviations](../fish/README.md#abbreviations).
- `scripts/ai-commit-msg.sh` writes commit messages with Claude Haiku (`gcai` in fish, `Ctrl-k` in lazygit). It runs gitleaks on the staged changes **before** sending the diff to Claude, since the pre-commit hook would only run afterwards.
