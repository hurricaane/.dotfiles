# bat

Themes for [bat](https://github.com/sharkdp/bat), a `cat` clone with syntax highlighting. Linked to `~/.config/bat`.

There is no `config` file: the theme is set by fish (`BAT_THEME="Catppuccin Mocha"`), and the folder only holds the [Catppuccin themes](https://github.com/catppuccin/bat) (Latte, Frappé, Macchiato, Mocha).

## Installation

```sh
ln -s ~/dotfiles/bat ~/.config/bat   # or `just link`
bat cache --build                    # bat only sees custom themes after this
```

Check with `bat --list-themes | grep Catppuccin`.

## Where bat is used

- `cat` is an alias for `bat`, and `diff` for `batdiff` (fish).
- [bat-extras](https://github.com/eth-p/bat-extras): `batman` is the man pager, `batpipe` colors `less`.
- The fish `help <cmd>` function highlights `--help` output with bat.
- Previews in Television (files, dotfiles…).
