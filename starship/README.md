# Starship

Configuration of the [Starship](https://starship.rs) prompt, used by fish (and by yazi's header). Linked to `~/.config/starship`; fish points `STARSHIP_CONFIG` at `~/.config/starship/starship.toml`.

## Requirements

- `starship`
- A Nerd Font (OS, git and language icons)

## Layout

A two-sided prompt, then the input on its own line:

```text
 ~/dotfiles main  1                       ☸ ctx  v1.24  3s
❯
```

- **Left**: OS icon, directory, git branch, commit, state (rebase, merge…), metrics and status.
- **Right** (after a `fill`): Kubernetes context, Docker context, package version, the language versions of the project (C, Go, Lua, Node, Python, Rust, Terraform, Zig…), cloud contexts (AWS, GCloud, Azure, OpenStack), then command duration, background jobs and the exit status of the last command.
- **Second line**: the `❯` character. With fish's **transient prompt**, earlier prompts collapse to this character only.

## Specifics

- `command_timeout = 200` ms, so slow commands (big repos) don't block the prompt.
- **Directory**: never truncated; the repository root is bold cyan, followed by the path inside it.
- **Git branch**: italic purple. **Git status**: compact Nerd Font symbols, with counts for ahead/behind, stashes (blue) and staged files (green).
- **Kubernetes** and the **exit status** (`✖ <code>`) are turned on (they are off by default).
- Some modules use a shorter format: Go and AWS without the "via"/"on" words, command duration as the bare duration.
- **OS icon**: Arch and EndeavourOS, bold bright blue.

## Theme

The Catppuccin Mocha palette is defined in the file (`palette = "catppuccin_mocha"`).

`starship.toml.bak` is an old version, not used.
