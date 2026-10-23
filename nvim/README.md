# Neovim configuration

A personal Neovim configuration built on the **built-in plugin manager (`vim.pack`)**: no lazy.nvim and no distribution. Its structure comes from [MiniMax](https://github.com/nvim-mini/MiniMax), and many defaults and keymaps come from [LazyVim](https://github.com/LazyVim/LazyVim).

It aims to be:

- **Plain and readable**: four numbered files in `plugin/` hold almost everything, grouped by topic.
- **Fail-safe**: every block is wrapped in `MiniMisc.safely()`, so one broken plugin doesn't take the rest of the config down with it.
- **Fast to start**: only what has to be visible right away loads during startup. Everything else loads just after the first screen is drawn.
- **Portable**: `:RemoteStart` copies this config to any SSH host and attaches a local UI to it.

<!-- toc -->

- [Requirements](#requirements)
  - [Neovim version](#neovim-version)
  - [External tools](#external-tools)
- [Installation](#installation)
- [Structure](#structure)
  - [Startup order](#startup-order)
- [Core concepts](#core-concepts)
  - [The `Config` global](#the-config-global)
  - [Loading stages](#loading-stages)
  - [Package management](#package-management)
  - [Remote development over SSH](#remote-development-over-ssh)
  - [Claude Code](#claude-code)
- [Options and autocommands](#options-and-autocommands)
- [Plugins](#plugins)
  - [mini.nvim modules](#mininvim-modules)
  - [Other plugins](#other-plugins)
- [Language support](#language-support)
  - [Tree-sitter](#tree-sitter)
  - [LSP servers](#lsp-servers)
  - [Linters and formatters](#linters-and-formatters)
  - [Custom filetypes](#custom-filetypes)
  - [Kubernetes and Helm](#kubernetes-and-helm)
- [Keymaps](#keymaps)
  - [General](#general)
  - [Leader groups](#leader-groups)
    - [AI (Claude Code) (Leader a)](#ai-claude-code-leader-a)
    - [Buffers (Leader b)](#buffers-leader-b)
    - [Explore / Edit (Leader e)](#explore--edit-leader-e)
    - [Find (Snacks picker) (Leader f)](#find-snacks-picker-leader-f)
    - [Git (Leader g)](#git-leader-g)
    - [Language (LSP) (Leader l)](#language-lsp-leader-l)
    - [Packages (Leader p)](#packages-leader-p)
    - [Session (persistence) (Leader s)](#session-persistence-leader-s)
    - [Utilities (Leader u)](#utilities-leader-u)
    - [Windows (Leader w)](#windows-leader-w)
  - [Text editing (mini.nvim)](#text-editing-mininvim)
  - [mini.files](#minifiles)
  - [Completion (blink.cmp)](#completion-blinkcmp)
  - [Picker (Snacks)](#picker-snacks)
- [User commands](#user-commands)
- [Possible upgrades](#possible-upgrades)
  - [Replace Mason with mise](#replace-mason-with-mise)
    - [How mise works here](#how-mise-works-here)
    - [Why it would help](#why-it-would-help)
    - [What the migration involves](#what-the-migration-involves)
    - [Trade-offs](#trade-offs)
- [Tips](#tips)

<!-- tocstop -->

## Requirements

### Neovim version

**Minimum: Neovim 0.12.0. Recommended: 0.13-dev (nightly).**

I checked this against the APIs the config uses, and by starting it with 0.12.1 and with a 0.13-dev nightly. Both load without errors.

- **0.12** (minimum):
  - `vim.pack` (built-in plugin manager), the `PackChanged` event and `nvim-pack-lock.json`: everywhere, and `lua/config/pack.lua`.
  - The `'pumborder'`, `'pummaxwidth'` and `'completetimeout'` options: `plugin/10_options.lua`.
  - The `main` branch of nvim-treesitter: `plugin/40_plugins.lua`.
- **0.11**: `vim.lsp.config()`, `after/lsp/<server>.lua`, `vim.lsp.foldexpr()` and `'winborder'`.
- **0.13-dev**:
  - `vim.pack.get()` returning `rev_to` (the revision of a pending update): the lualine update counter and `:PackCheck`.
  - `vim.hl.hl_op()` for yank highlighting. On 0.12 it falls back to `vim.hl.on_yank()`.

On 0.12 everything works except the **package update counter**. Without `rev_to`, the lualine indicator and `:PackCheck` always report zero pending updates. `:PackUpdate` still works, because it calls `vim.pack.update()` directly.

`:RemoteStart` always installs a **nightly** build on the remote host, whatever version runs locally.

> I manage versions with [bob](https://github.com/MordechaiHadad/bob): `bob use nightly`.

### External tools

- `git`: `vim.pack` clones and updates plugins with it
- `curl`, `tar`, a C compiler: nvim-treesitter builds parsers; `:RemoteStart` needs `tar`
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter) ≥ 0.26.1: required by nvim-treesitter `main` (install it with your package manager, not npm)
- `ripgrep`, `fd`: Snacks picker (files and grep)
- A [Nerd Font](https://www.nerdfonts.com/): icons (`mini.icons`, lualine, diagnostics)
- `node`/`npm`, `go`, `python3`, `cargo`: Mason uses them to install most LSP servers and tools
- `tofu`, `fish`, `just`: not installed by Mason. They provide `tofu fmt`, `fish_indent` and the `fish` linter, and `just --fmt`, which just-lsp runs to format justfiles
- ImageMagick (optional): `Snacks.image` conversions
- `tmux` or `xdg-terminal-exec`: `:RemoteStart` opens the remote UI in one of them
- SSH key authentication: `:RemoteStart` runs SSH with `BatchMode=yes`, so it can't prompt for a password

## Installation

The config lives in the dotfiles repo and is symlinked into place:

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim   # or `just link` from the dotfiles root
nvim
```

On first start, `vim.pack.add()` asks before installing the plugins. The revisions it installs are the ones pinned in `nvim-pack-lock.json`. Then:

- missing tree-sitter parsers are compiled,
- `mason-tool-installer` installs every LSP server, linter and formatter in its list. This runs in the background; `:Mason` shows the progress.

To try the config without touching an existing setup, run it under another app name:

```sh
git clone <this repo> ~/.config/nvim-test
NVIM_APPNAME=nvim-test nvim
```

## Structure

```text
nvim/
├── init.lua                 # Entry point: `Config` global, loading helpers, colorscheme, icons
├── nvim-pack-lock.json      # vim.pack lockfile (exact plugin revisions), committed
├── lua/config/
│   ├── pack.lua             # Package helpers: async update check, delete, clean
│   └── remote.lua           # `:RemoteStart` – run this config on an SSH host
├── plugin/                  # Sourced automatically, in alphabetical order
│   ├── 10_options.lua       # Options, autocommands, user commands
│   ├── 20_keymaps.lua       # Global keymaps and leader groups
│   ├── 30_mini.lua          # mini.nvim modules
│   └── 40_plugins.lua       # Every other plugin (UI, LSP, completion, git…)
├── snippets/
│   └── global.json          # Snippets available in every buffer (mini.snippets)
├── after/
│   ├── ftplugin/
│   │   ├── ghosttext.lua    # GhostText buffers: wrap, spell check
│   │   ├── just.lua         # Justfile: 4-space indent, like `just --fmt`
│   │   └── markdown.lua     # Markdown: tree-sitter folds, link surround, wrap
│   ├── lsp/                 # Per-server overrides merged into nvim-lspconfig defaults
│   │   ├── ansiblels.lua  eslint.lua  gopls.lua  helm_ls.lua  jsonls.lua  just.lua
│   │   └── lua_ls.lua  pyright.lua  ruff.lua  tailwindcss.lua  vtsls.lua  yamlls.lua
│   └── snippets/
│       └── lua.json         # Overrides friendly-snippets' Lua snippets (loaded last)
└── queries/markdown/
    └── folds.scm            # Fold markdown by heading section only
```

### Startup order

1. **`init.lua`** creates `_G.Config`, adds `mini.nvim` (the loading helpers depend on `mini.misc`), sets the colorscheme and defines the icons.
2. **`plugin/*.lua`** files are sourced in numeric order: options → keymaps → mini → plugins. The numeric prefix keeps the order explicit.
3. **`after/`** loads last. It holds filetype tweaks and LSP overrides that take precedence over plugin defaults.

## Core concepts

### The `Config` global

`init.lua` defines a global `Config` table that every file shares:

- `Config.now(f)`: run `f` immediately (colorscheme, statusline, completion…)
- `Config.later(f)`: run `f` right after startup, once the first screen is drawn
- `Config.now_if_args(f)`: `now` when Neovim was opened with a file (`nvim foo.lua`), otherwise `later`
- `Config.on_event(ev, f)`: run `f` once, on the first matching event
- `Config.on_filetype(ft, f)`: run `f` once, on the first buffer of that filetype
- `Config.on_command(cmd, f)`: define a single-use command that runs `f`, then the real command
- `Config.new_autocmd(ev, pat, f, desc)`: create an autocommand in the shared `custom-config` group
- `Config.on_packchanged(name, kinds, f)`: run a hook when a plugin is installed or updated (e.g. `:TSUpdate`)
- `Config.autoformat_enabled(buf)`, `Config.autoformat_set(on, buffer_only)`: read or change format on save (buffer value first, then global), used by conform, ESLint and the `<Leader>uf`/`<Leader>uF` toggles
- `Config.is_ssh`: `true` inside an SSH session; skips things that only work locally
- `Config.icons`: shared icons: diagnostics, git, LSP kinds, DAP, filetypes
- `Config.leader_groups`: leader group definitions, reused by which-key

All the helpers are thin wrappers around [`MiniMisc.safely()`](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-misc.md), which catches and reports errors without stopping the rest of the config.

### Loading stages

Each plugin block runs in the stage that fits it:

- **`now`**: what has to be visible on the first screen: colorscheme, `mini.icons`, Snacks, Noice, Mason, blink.cmp, lualine, helpview, GhostText. Also SchemaStore and schema-companion (the `yamlls`/`helm_ls` configs require them), and cloak, so a secrets file opened at startup is hidden right away.
- **`now_if_args`**: what matters only when opening a file directly: `mini.files`, tree-sitter, nvim-ansible (filetype detection), lspconfig, diagnostics and LSP features.
- **`later`**: everything else: editing modules, git, formatting, linting, which-key, flash, smear-cursor, markview…
- **`on_filetype("lua")`**: `lazydev.nvim`.

### Package management

Plugins are declared where they are configured, with `vim.pack.add({ "https://github.com/owner/repo" })`. Installed plugins live in `stdpath("data")/site/pack/core/opt`, which `mini.files` bookmarks as `p`.

`nvim-pack-lock.json` records the exact revision of every plugin. It is committed, so a fresh machine installs the same versions. `blink.cmp` is pinned to `^1` so its prebuilt fuzzy matcher binary is used.

On top of `vim.pack`, `lua/config/pack.lua` adds:

- **An async update check on startup**: it runs `git fetch` in each plugin directory without blocking, then counts pending updates. The count shows in lualine (package icon followed by the count); clicking it runs `:PackUpdate`. This needs 0.13-dev, see [Neovim version](#neovim-version).
- **`:PackUpdate[!]`**: update all plugins (`!` skips the confirmation buffer).
- **`:PackCheck`**: fetch and report how many plugins can be updated.
- **`:PackDelete [names…]`**: delete plugins, picking one from a list when no name is given.
- **`:PackClean`**: delete plugins whose URL no longer appears in any `.lua` file of the config.

### Remote development over SSH

`:RemoteStart [host] [path]` works like [remote-nvim.nvim](https://github.com/amitds1997/remote-nvim.nvim), in about 150 lines (`lua/config/remote.lua`):

1. It archives this config (without `.git`) and streams it over SSH to `~/.config/nvim-remote` on the host (`NVIM_APPNAME=nvim-remote`), so the host's own Neovim setup is left alone.
2. It installs a Neovim **nightly** into `~/.local/share/nvim-remote-nightly` if it isn't there yet. `:RemoteStart!` downloads it again. Only Linux x86_64 and arm64 hosts are supported.
3. It starts `nvim --headless --listen <socket>` in `path` (default `~`) and forwards the socket to a free local port.
4. It opens `nvim --remote-ui` in a new **tmux window** named after the host, or in a new terminal (`xdg-terminal-exec`) outside tmux.

With no argument, it offers the hosts found in `~/.ssh/config` and `~/.ssh/known_hosts`. On the host, the server quits once its last UI detaches, unless there are unsaved changes. In SSH sessions, the clipboard goes through **OSC 52** and GhostText is not loaded.

### Claude Code

[claudecode.nvim](https://github.com/coder/claudecode.nvim) makes Neovim the IDE of [Claude Code](https://code.claude.com), with the same protocol as the official VS Code extension. Claude Code runs in a **tmux pane next to Neovim**, not inside it (`terminal.provider = "none"`), so it survives Neovim restarts and diffs stay visible while Claude works.

- **Connecting**: on startup, the plugin starts a WebSocket server on `127.0.0.1` and writes a lock file (port, working directory, auth token) to `~/.claude/ide/`. Run `/ide` in Claude Code, started in the **same directory** as Neovim, and pick Neovim. The lock file is removed when Neovim quits; Claude Code then keeps working as a plain CLI.
- **Neovim → Claude**: Claude follows the current file and selection. `<Leader>af` / `<Leader>as` explicitly add a file or the selected lines as an `@file#Lx-y` reference, then focus the Claude pane: the pane of the current tmux window whose program is `claude`, whatever the layout. Nothing happens outside tmux or without such a pane.
- **Claude → Neovim**: Claude reads LSP diagnostics and open buffers, and proposes its edits as a **diff** in Neovim, then waits. Accept with `<Leader>aa` (or `:w` the proposed version), reject with `<Leader>ad`. Diffs left open (Claude interrupted, or answered elsewhere) are closed with `<Leader>aD`; accepted ones are kept.

`<Leader>aS` shows the connection status. Keymaps: [AI](#ai-claude-code-leader-a).

## Options and autocommands

All in `plugin/10_options.lua`. The highlights:

- **Leader**: `<Space>`. `timeoutlen=300` so which-key appears quickly.
- **UI**: one global statusline (`laststatus=3`), `cmdheight=0` (Noice draws the cmdline), relative numbers, rounded borders everywhere (`winborder`, `pumborder`), no wrapping by default except in markdown (`<Leader>uw` toggles it).
- **Editing**: two spaces, `expandtab`, system clipboard (`unnamedplus`), persistent undo, smart case search, `-` counts as part of a word, spell check in English and French (`en,fr`) with camelCase awareness.
- **Folds**: indent-based by default, with nothing folded on open. They switch to LSP folding when the server supports it, and markdown uses tree-sitter folds by section.
- **Built-in plugins turned off**: `gzip`, `matchit`, `matchparen`, `netrw` (`mini.files` replaces it), `tar`, `tohtml`, `zip`.

Autocommands:

- `FileType` (all): remove the `c`/`o` format options (no auto comment leader on `o`)
- `BufReadPost`: restore the cursor to its last position (not in `gitcommit`)
- `FocusGained` / `TermClose` / `TermLeave`: `:checktime`, to reload files changed outside Neovim
- `TextYankPost`: highlight the yanked text
- `BufWritePre`: create missing parent directories when saving
- `FileType` json / jsonc / json5: `conceallevel=0`
- `FileType` gitcommit / markdown / text…: turn on spell check
- `FileType` help / qf / checkhealth…: close with `q`, unlisted buffer
- `VimEnter` / `PackChanged`: check or refresh the package update count
- `UILeave` (remote only): quit the headless server once no UI is attached

## Plugins

39 plugins in total. The exact revisions are in `nvim-pack-lock.json`.

### mini.nvim modules

Configured in `plugin/30_mini.lua`, except `mini.misc`, which `init.lua` uses.

- [mini.misc](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-misc.md): `safely()`, which backs the loading helpers
- [mini.icons](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-icons.md): Icons; stands in for `nvim-web-devicons` and also provides LSP kind icons. Custom icons for YAML, Ansible, `.env*`, devcontainer, JS tooling files
- [mini.files](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-files.md): File explorer (column view with preview), replaces netrw
- [mini.extra](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-extra.md): Extra text object specs (`B` = whole buffer)
- [mini.ai](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-ai.md): Better `a`/`i` text objects, including tree-sitter ones
- [mini.comment](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-comment.md): `gc` comment operator
- [mini.operators](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-operators.md): Evaluate / exchange / multiply / replace / sort operators
- [mini.pairs](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pairs.md): Auto pairs that skip inside strings and before word characters
- [mini.splitjoin](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-splitjoin.md): Toggle arguments between one line and several (`gJ`)
- [mini.surround](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md): Surround actions under `gs*` (LazyVim style)
- [mini.snippets](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-snippets.md): Snippet engine, shown in the blink.cmp menu. Loads `snippets/global.json` everywhere, then each language's files from the runtimepath in order: `snippets/`, plugins (friendly-snippets), `after/snippets/`. A later snippet with the same prefix replaces an earlier one, and a prefix without a body removes it

### Other plugins

Configured in `plugin/40_plugins.lua` (the colorscheme is in `init.lua`).

- **Colorscheme**
  - [catppuccin/nvim](https://github.com/catppuccin/nvim): Mocha, transparent background and floats, a few subtle highlights brightened
- **UI**
  - [folke/snacks.nvim](https://github.com/folke/snacks.nvim): Picker, notifier, indent guides, scope, words, statuscolumn, input, image, bigfile, quickfile, bufdelete, rename, zen
  - [folke/noice.nvim](https://github.com/folke/noice.nvim) + [nui.nvim](https://github.com/MunifTanjim/nui.nvim): Cmdline popup, LSP markdown rendering; write messages routed to the mini view
  - [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): Rounded "bubble" statusline: mode, branch, diagnostics, file, Noice status, package updates, git diff, clock
  - [folke/which-key.nvim](https://github.com/folke/which-key.nvim): Helix preset, leader group labels from `Config.leader_groups`
  - [HiPhish/rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim): Colors nested brackets
  - [NStefan002/screenkey.nvim](https://github.com/NStefan002/screenkey.nvim): `:Screenkey` shows pressed keys, for demos
  - [eero-lehtinen/oklch-color-picker.nvim](https://github.com/eero-lehtinen/oklch-color-picker.nvim): Highlights color codes; `:ColorPickOklch` picks one
  - [sphamba/smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim): Animates the cursor as a smear when it jumps; `:SmearCursorToggle`. Uses legacy computing symbols (drawn by Ghostty) and a Mocha fallback color for the transparent background
- **Syntax**
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main`): Installs parsers; highlighting starts from the filetype's language, so compound filetypes (`yaml.ansible`, `yaml.ghaction`) use the `yaml` parser
  - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects): `]f`/`[f`, `]c`/`[c`, `]a`/`[a` moves
  - [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag): Closes and renames HTML/JSX/Vue tags automatically
- **LSP**
  - [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Default server configs only; overrides go in `after/lsp/`
  - [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim): Installs servers and enables the installed ones automatically
  - [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim): Keeps the list of servers, linters and formatters installed
  - [b0o/SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim): JSON and YAML schemas for `jsonls` / `yamlls` (GitHub workflows, docker-compose, GitLab CI…)
  - [cenk1cenk2/schema-companion.nvim](https://github.com/cenk1cenk2/schema-companion.nvim) + [plenary.nvim](https://github.com/nvim-lua/plenary.nvim): Picks the schema of each YAML buffer for `yamlls` and `helm_ls`: Kubernetes manifests and CRDs from their `apiVersion`/`kind`, the rest from SchemaStore. See [Kubernetes and Helm](#kubernetes-and-helm)
  - [mfussenegger/nvim-ansible](https://github.com/mfussenegger/nvim-ansible): Detects playbooks, roles and group/host vars as `yaml.ansible`; `keywordprg` is `ansible-doc`
  - [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim): Lua LSP setup for Neovim config development (`vim.uv`, `Snacks` types)
  - [smjonas/inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim): Rename with a live preview
- **Completion**
  - [saghen/blink.cmp](https://github.com/saghen/blink.cmp) (`^1`): LSP, path, snippets, buffer, lazydev sources; cmdline completion; signature help
  - [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets): Snippet collection
- **Formatting**
  - [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim): Formats on save (LSP as fallback)
- **Linting**
  - [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint): Runs on read, write and leaving insert mode, debounced by 100 ms
- **Git**
  - [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Signs, hunk navigation, stage/reset, blame
  - [esmuellert/codediff.nvim](https://github.com/esmuellert/codediff.nvim): VSCode-style diff view (`:CodeDiff`)
- **Editing**
  - [folke/flash.nvim](https://github.com/folke/flash.nvim): Jump with labels (`s`), select tree-sitter nodes (`S`)
  - [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim): Highlights `TODO`/`FIX`/`NOTE`…, with jumps and a picker
  - [max397574/better-escape.nvim](https://github.com/max397574/better-escape.nvim): `jk` leaves insert, cmdline, terminal, visual and select modes
- **Sessions**
  - [folke/persistence.nvim](https://github.com/folke/persistence.nvim): Saves a session per directory
- **Security**
  - [laytan/cloak.nvim](https://github.com/laytan/cloak.nvim): Hides the values in `.env*` / `*.env` files (`KEY=********`, fixed length), for screen sharing. `:CloakToggle`, `:CloakPreviewLine` reveals the line under the cursor. blink.cmp is off in those files while cloak is on, so buffer completion can't show the values. Snacks picker previews are not cloaked
- **AI**
  - [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim): Neovim as the IDE of Claude Code (context, diagnostics, diffs). See [Claude Code](#claude-code)
- **Markdown / help**
  - [OXY2DEV/markview.nvim](https://github.com/OXY2DEV/markview.nvim): Renders markdown inside the buffer
  - [OXY2DEV/helpview.nvim](https://github.com/OXY2DEV/helpview.nvim): Renders `:help` pages the same way
- **Browser**
  - [subnut/nvim-ghost.nvim](https://github.com/subnut/nvim-ghost.nvim): Edits browser text areas with GhostText (markdown on github.com and reddit.com). Not loaded over SSH

Behaviors worth knowing:

- **Inlay hints** turn on automatically when the server supports them.
- **Folding** switches to `vim.lsp.foldexpr()` when the server supports it.
- **ESLint** runs `:EslintFixAll` before each save, unless auto format is off (`<Leader>uf` / `<Leader>uF`).
- **File renames** (`<Leader>lR`, mini.files) tell the LSP servers, which update imports (`willRename` / `didRename`).

## Language support

### Tree-sitter

Parsers that are missing get installed on startup:

> bash, c, cmake, cpp, css, desktop, diff, dockerfile, fish, git_config, git_rebase, gitattributes, gitcommit, gitignore, go, gomod, gosum, gotmpl, gowork, hcl, helm, html, hyprlang, javascript, jsdoc, json, json5, just, lua, luadoc, luap, markdown, markdown_inline, ninja, printf, python, query, rasi, regex, ron, rst, rust, sql, terraform, toml, tsx, typescript, vim, vimdoc, vue, xml, yaml

When `nvim-treesitter` updates, `:TSUpdate` runs automatically (a `PackChanged` hook).

### LSP servers

Mason installs them and `mason-lspconfig` enables them.

These use the nvim-lspconfig defaults: `bashls` (Bash / sh), `clangd` (C / C++), `docker_compose_language_service` and `dockerls` (Docker), `emmet_language_server` (HTML / CSS / JSX), `fish_lsp` (Fish), `marksman` (Markdown), `neocmake` (CMake), `taplo` (TOML), `terraformls`, `tofu_ls` and `tflint` (Terraform / OpenTofu), `vimls` (Vimscript).

These have overrides in `after/lsp/<server>.lua`:

- `ansiblels` (Ansible, `yaml.ansible`): `ansible`, `python` and `ansible-lint` come from the project's virtualenv (`$VIRTUAL_ENV`, set by mise), else from the ansible-core bundled with Mason's `ansible-lint`, else from `PATH`.
- `eslint` (JS / TS / Vue): `workingDirectories = auto`, fix all on save.
- `gopls` (Go): gofumpt, staticcheck, codelenses (incl. govulncheck), every inlay hint, extra analyses, semantic tokens workaround.
- `helm_ls` (Helm, `helm` and `yaml.helm-values`): schema-companion with Kubernetes matching for templates.
- `jsonls` (JSON): SchemaStore schemas, formatting, validation.
- `just` (just-lsp, Justfile): formatting with `just --fmt` at 4 spaces (needs `just` on `PATH`), on save through conform's LSP fallback.
- `lua_ls` (Lua): codelens, call snippets, selected inlay hints.
- `pyright` and `ruff` (Python): pyright only does hover, completion and navigation (its diagnostics and organize imports are off, Ruff does them); Ruff has no hover.
- `tailwindcss` (CSS / HTML / JS / Vue…): filetype list, Vue treated as HTML.
- `vtsls` and `vue_ls` (JS / TS / Vue): Vue TypeScript plugin, move-to-file refactor, inlay hints, update imports on file move.
- `yamlls` (YAML, docker-compose, GitLab CI, Helm values, GitHub workflows): schema-companion (Kubernetes matcher, manual Kubernetes schema), SchemaStore schemas, `yaml.ghaction` added to the filetypes, GitLab CI `!reference` tags, telemetry off.

### Linters and formatters

| Filetype        | Linter                     | Formatter              |
| --------------- | -------------------------- | ---------------------- |
| Ansible         | `ansible-lint` (ansiblels) | –                      |
| CMake           | `cmakelint`                | –                      |
| Dockerfile      | `hadolint`                 | LSP                    |
| Fish            | `fish`                     | `fish_indent`          |
| GitHub Actions  | `actionlint`               | LSP (`yamlls`)         |
| Go              | `golangci-lint` + `gosec`  | `goimports`, `gofumpt` |
| Justfile        | (just-lsp)                 | LSP (`just --fmt`)     |
| Lua             | (lua_ls)                   | `stylua`               |
| Markdown / MDX  | `markdownlint-cli2`        | see below              |
| Python          | `ruff` (LSP)               | `ruff` (LSP)           |
| Shell           | `shellcheck` (bashls)      | `shfmt`                |
| SQL             | `sqlfluff`                 | –                      |
| Terraform / HCL | `tflint`                   | `tofu fmt`             |
| Everything else | –                          | LSP, when available    |

- **Markdown**: `markdownlint-cli2` uses `~/.markdownlint.yaml`. Formatting runs `prettier`, then `markdownlint-cli2` (only if there are diagnostics), then `markdown-toc` (only if the file has a `toc` marker comment).
- **Go**: golangci-lint always runs with `--enable=gosec`, on top of the project's `.golangci.yml`.
- **GitHub Actions** (`yaml.ghaction`): `yamlls` also validates workflows against their schema.
- **Ansible** (`yaml.ansible`): `ansiblels` runs `ansible-lint` itself.

Formatting runs on save (3 s timeout). `<Leader>uf` turns it off everywhere and `<Leader>uF` only for the current buffer, like LazyVim (`vim.g.autoformat` / `vim.b.autoformat`). `<Leader>lF` formats injected languages, such as code blocks inside markdown.

### Custom filetypes

| Pattern                       | Filetype              |
| ----------------------------- | --------------------- |
| `*.rasi`, `*.rofi`, `*.wofi`  | `rasi`                |
| `vifmrc`                      | `vim`                 |
| `*/waybar/config`             | `jsonc`               |
| `*/mako/config`               | `dosini`              |
| `*/kitty/*.conf`              | `kitty` (bash parser) |
| `*/hypr/*.conf`               | `hyprlang`            |
| `.env.*`                      | `sh`                  |
| `.github/workflows/*.y{a,}ml` | `yaml.ghaction`       |
| Helm templates                | `helm`                |
| Helm values                   | `yaml.helm-values`    |
| Ansible files                 | `yaml.ansible`        |

- **Helm**: `templates/*.yaml`, `templates/*.yml` and `templates/*.tpl` are templates, and `values*.yaml` / `values*.yml` are values files, when a parent directory has a `Chart.yaml`.
- **Ansible** (nvim-ansible): playbooks, `roles/*/tasks`, `handlers`, `defaults`, `group_vars`, `host_vars` and `molecule` files.

### Kubernetes and Helm

Kubernetes manifests have no fixed filename, so the SchemaStore catalog can't match them. schema-companion reads each `apiVersion`/`kind` in the buffer instead, and gives `yamlls` the matching schema:

- built-in resources (`apps/v1` `Deployment`, `v1` `Service`…) use [yannh/kubernetes-json-schema](https://github.com/yannh/kubernetes-json-schema), `master` version;
- CRDs (cert-manager, Argo CD, Traefik…) use [datreeio/CRDs-catalog](https://github.com/datreeio/CRDs-catalog);
- other YAML files keep the schema `yamlls` finds in SchemaStore (GitHub workflows, docker-compose, GitLab CI…).

Helm templates get the same Kubernetes matching through `helm_ls`. When the match is wrong or missing, `<Leader>ly` picks any schema (including "Kubernetes (all resources)"), and `<Leader>lY` picks among the matches. Matching checks that the schema URL exists, so it needs network access.

## Keymaps

Leader is `<Space>`. which-key shows every group, so press `<Space>` and wait to browse them. `<Leader>fk` searches every keymap.

### General

| Keys                | Mode          | Action                             |
| ------------------- | ------------- | ---------------------------------- |
| `j` / `k`           | n, x          | Move by display line               |
| `<C-d>` / `<C-u>`   | n             | Half page down / up, centered      |
| `<M-H/J/K/L>`       | i             | Move the cursor in insert mode     |
| `<A-;>` / `<A-,>`   | n, i, v       | Move line / selection down / up    |
| `K`                 | n             | LSP hover                          |
| `]]` / `[[`         | n             | Next / previous LSP reference      |
| `s` / `S`           | n, x, o       | Flash jump / tree-sitter selection |
| `r`                 | o             | Flash remote operation             |
| `R`                 | o, x          | Flash tree-sitter search           |
| `]t` / `[t`         | n             | Next / previous TODO comment       |
| `]h` `[h` `]H` `[H` | n             | Next / prev / last / first hunk    |
| `]f` `]c` `]a`      | n, x, o       | Next function / class / parameter  |
| `ih`                | o, x          | Git hunk text object               |
| `<Esc>`             | n             | Clear search highlight             |
| `jk`                | i, c, t, v, s | Escape                             |
| `q`                 | n             | Close help, quickfix and similar   |

- `j`, `k` with a count add the jump to the jumplist (`<C-o>` / `<C-i>`). `<C-d>` / `<C-u>` don't, to keep it for real jumps: press `m'` before scrolling to come back with `<C-o>`.
- `[f`, `[c`, `[a` go to the previous one. Upper case (`]F`, `[C`…) goes to the end instead of the start. In diff windows, `]c` / `[c` keep their built-in meaning (next / previous change).
- **Flash**: `s` jumps to any visible spot (type a few characters, then the label). `S` selects a syntax node around the cursor by label. After an operator, `r` acts somewhere else and brings the cursor back: `yr` + spot + `iw` copies a word from elsewhere on screen, `dr` + spot + `ap` deletes a paragraph there. `R` labels the syntax nodes around every match of a search (`yR` + `pairs` + label copies the loop containing it).
- `q` closes help, quickfix, checkhealth and similar windows.

### Leader groups

#### AI (Claude Code) (Leader a)

| Keys | Mode | Action                                                           |
| ---- | ---- | ---------------------------------------------------------------- |
| `aa` | n    | Accept the proposed diff                                         |
| `ad` | n    | Reject the proposed diff                                         |
| `aD` | n    | Close all pending diffs                                          |
| `af` | n    | Add the current file (in mini.files: the entry under the cursor) |
| `as` | x    | Send the selected lines                                          |
| `aS` | n    | Connection status                                                |

See [Claude Code](#claude-code) for how it works.

#### Buffers (Leader b)

| Keys | Action                      |
| ---- | --------------------------- |
| `ba` | Alternate buffer            |
| `bb` | Buffer picker (ivy layout)  |
| `bd` | Delete buffer (keep window) |
| `bD` | Delete buffer and window    |
| `bo` | Delete other buffers        |

#### Explore / Edit (Leader e)

| Keys | Action                                        |
| ---- | --------------------------------------------- |
| `e=` | Pad a section header with `=` up to column 79 |
| `ed` | mini.files in the working directory           |
| `ef` | mini.files at the current file                |
| `ei` | Edit `init.lua`                               |
| `eo` | Edit `plugin/10_options.lua`                  |
| `ek` | Edit `plugin/20_keymaps.lua`                  |
| `em` | Edit `plugin/30_mini.lua`                     |
| `ep` | Edit `plugin/40_plugins.lua`                  |
| `en` | Notification history                          |
| `eq` | Toggle the quickfix list                      |
| `eQ` | Toggle the location list                      |

#### Find (Snacks picker) (Leader f)

| Keys | Action                  | Keys | Action              |
| ---- | ----------------------- | ---- | ------------------- |
| `ff` | Files (hidden included) | `fg` | Live grep           |
| `fw` | Grep word under cursor  | `fb` | Lines of the buffer |
| `fB` | Grep open buffers       | `fd` | Diagnostics         |
| `fD` | Buffer diagnostics      | `fh` | Help                |
| `fH` | Highlights              | `fi` | Icons               |
| `fk` | Keymaps                 | `fp` | All pickers         |
| `fr` | Resume last picker      | `ft` | TODOs               |
| `fu` | Undo history            | `f:` | Command history     |
| `f/` | Search history          |      |                     |

#### Git (Leader g)

| Keys  | Action                      |
| ----- | --------------------------- |
| `gd`  | Diff view (CodeDiff)        |
| `gf`  | Git log of the current file |
| `gl`  | Git log of the repository   |
| `ghs` | Stage hunk (n, x)           |
| `ghr` | Reset hunk (n, x)           |
| `ghS` | Stage buffer                |
| `ghu` | Undo stage hunk             |
| `ghR` | Reset buffer                |
| `ghp` | Preview hunk inline         |
| `ghb` | Blame line (full commit)    |
| `ghB` | Blame buffer                |

#### Language (LSP) (Leader l)

| Keys | Action                                 |
| ---- | -------------------------------------- |
| `la` | Code actions                           |
| `ld` | Line diagnostics (float)               |
| `lD` | Project diagnostics (picker)           |
| `lf` | Format buffer or selection             |
| `lF` | Format injected languages              |
| `li` | LSP info (attached servers and config) |
| `lI` | Implementations                        |
| `lr` | Rename symbol (inc-rename preview)     |
| `lR` | Rename file (updates imports)          |
| `ls` | Go to definition                       |
| `lS` | References                             |
| `lt` | Type definition                        |
| `ly` | Select YAML schema (schema-companion)  |
| `lY` | Select among the matching YAML schemas |

#### Packages (Leader p)

| Keys | Action                      |
| ---- | --------------------------- |
| `pc` | `:PackCheck`                |
| `pC` | `:PackClean`                |
| `pd` | `:PackDelete`               |
| `pu` | `:PackUpdate`               |
| `pU` | `:PackUpdate!` (no confirm) |

#### Session (persistence) (Leader s)

| Keys | Action                             |
| ---- | ---------------------------------- |
| `ss` | Restore session for this directory |
| `sS` | Select a session                   |
| `sl` | Restore last session               |
| `sd` | Stop saving the session            |

#### Utilities (Leader u)

Toggles and UI helpers taken from LazyVim. which-key shows whether each toggle is on or off.

| Keys | Action                                       |
| ---- | -------------------------------------------- |
| `uf` | Toggle auto format (global)                  |
| `uF` | Toggle auto format (buffer)                  |
| `uw` | Toggle wrap                                  |
| `us` | Toggle spelling                              |
| `ul` | Toggle line numbers                          |
| `uL` | Toggle relative numbers                      |
| `uc` | Toggle conceal level                         |
| `ud` | Toggle diagnostics                           |
| `uh` | Toggle inlay hints                           |
| `uT` | Toggle tree-sitter highlighting              |
| `ug` | Toggle indent guides                         |
| `uD` | Toggle dimming of inactive code (Snacks dim) |
| `up` | Toggle auto pairs (mini.pairs)               |
| `uG` | Toggle git signs                             |
| `um` | Toggle markview rendering (buffer)           |
| `uk` | Toggle cloak (secret hiding, all buffers)    |
| `uK` | Reveal the secret on the current line        |
| `uz` | Toggle zen mode                              |
| `uC` | Colorscheme picker                           |
| `ui` | Inspect highlights under the cursor          |
| `uI` | Inspect the tree-sitter tree                 |
| `un` | Dismiss notifications                        |
| `ur` | Redraw, clear search highlight, update diff  |

#### Windows (Leader w)

`<Leader>w` works like `<C-w>` (`<Leader>wv`, `<Leader>wh`, `<Leader>wq`…), so window commands sit with the other leader groups. Moving between tmux panes is `<M-h/j/k/l>` (`tmux/tmux.conf`), which Neovim doesn't map in normal mode.

| Keys | Action               |
| ---- | -------------------- |
| `wm` | Toggle zoom (Snacks) |

### Text editing (mini.nvim)

| Keys                    | Action                                          |
| ----------------------- | ----------------------------------------------- |
| `gsa` / `gsd` / `gsr`   | Add / delete / replace surrounding              |
| `gsf` `gsF` `gsh` `gsn` | Find right / left, highlight, update `n_lines`  |
| `gsaiwL` (markdown)     | Wrap in a markdown link (asks for the URL)      |
| `gc` / `gcc`            | Comment operator / line                         |
| `g=`                    | Evaluate (replace the text with its Lua result) |
| `gx`                    | Exchange (use twice)                            |
| `gm`                    | Multiply (duplicate)                            |
| `gr`                    | Replace with a register                         |
| `go`                    | Sort                                            |
| `(` / `)`               | Swap the argument under the cursor left / right |
| `gJ`                    | Split / join arguments                          |

`mini.ai` text objects (`va?`, `ci?`, …): `f` function, `c` class, `o` block/conditional/loop (tree-sitter), `t` tag, `d` digits, `e` camelCase word part, `B` whole buffer. The default `mini.ai` objects (`(`, `"`, `a` argument, `q` quote, `b` bracket…) also work. Search uses the `cover` method.

### mini.files

| Keys               | Action                                            |
| ------------------ | ------------------------------------------------- |
| `l` / `h`          | Go in (opens files) / go out                      |
| `g.`               | Toggle hidden files                               |
| `<M-_>` / `<M-\|>` | Open in a horizontal / vertical split, then close |
| `'c` / `'p` / `'w` | Bookmarks: config / plugins dir / working dir     |
| `=`                | Apply the file system changes you made            |

Deleted files go to the trash (`permanent_delete = false`).

### Completion (blink.cmp)

| Keys              | Action                                                    |
| ----------------- | --------------------------------------------------------- |
| `<C-j>` / `<C-k>` | Next / previous item                                      |
| `<C-y>`           | Accept                                                    |
| `<C-space>`       | Open the menu / documentation                             |
| `<C-e>` / `<C-c>` | Cancel                                                    |
| `<C-l>` / `<C-h>` | Next / previous snippet placeholder                       |
| `<C-s>`           | Expand the snippet before the cursor, without the menu    |

`<C-n>` / `<C-p>` are left to Neovim. Cmdline completion only opens automatically for `:` commands, with ghost text.

### Picker (Snacks)

| Keys            | Action                    |
| --------------- | ------------------------- |
| `<Esc>`         | Close (normal and insert) |
| `<C-M-j/k/h/l>` | Scroll the preview        |
| `<M-S-h>`       | Toggle hidden files       |

## User commands

- `:PackUpdate[!]`: update plugins (`!` skips the confirmation)
- `:PackCheck`: fetch and count available updates
- `:PackDelete [names…]`: delete plugins (picker if no name is given)
- `:PackClean`: delete plugins that are no longer in the config
- `:RemoteStart[!] [host] [path]`: run this config on an SSH host (`!` re-downloads the Neovim nightly)
- `:CodeDiff`: VSCode-style git diff view
- `:Screenkey`: toggle the key display
- `:ColorPickOklch`: pick a color
- `:CloakToggle`, `:CloakPreviewLine`: toggle secret hiding, or reveal the current line
- `:SmearCursorToggle`: toggle the cursor smear animation
- `:ClaudeCodeStatus`, `:ClaudeCodeAdd <file> [start] [end]`, `:ClaudeCodeStart` / `:ClaudeCodeStop`: Claude Code connection, references and server
- `:Markview`, `:Helpview`: toggle or configure rendering
- `:Mason`: manage LSP servers and tools

## Possible upgrades

### Replace Mason with mise

Not done yet: an idea to weigh later.

[mise](https://mise.jdx.dev/) already manages some global tools on this machine (set up by Omarchy in `~/.config/mise/config.toml`). It could also install the language servers, linters and formatters that Mason installs today.

#### How mise works here

- **Tool list**: `~/.config/mise/config.toml` (global), plus a `mise.toml` in any project, which wins inside that project.
- **Installs**: `~/.local/share/mise/installs/<tool>/<version>/`, several versions side by side.
- **Finding the tools**: fish runs `mise activate fish` in every shell (from `/usr/share/fish/vendor_conf.d/mise-activate.fish`), which puts the right versions first on `PATH` and recomputes them on each `cd`. Everything else (Hyprland launchers, SSH, login shells) uses the shims in `~/.local/share/mise/shims/`, added to `PATH` by Omarchy's `env-bootstrap`.
- **Neovim** just uses `PATH`. Started from fish, it inherits the activated versions. Started any other way, it goes through the shims. The language servers it starts inherit the same `PATH`.

#### Why it would help

- One copy of each tool, shared by Neovim, the terminal, pre-commit and scripts. Mason keeps its own copies, visible only inside Neovim.
- Per-project versions: a client repo whose `mise.toml` pins `tflint = "0.50.3"` gets that version in Neovim too, matching its CI. Mason has one global version of each tool.
- Fewer version mismatches. Mason's golangci-lint was once built with an older Go than the system Go, which broke every Go lint. mise's `go:` backend builds with your own Go.
- Covers tools Mason doesn't package, such as `just`, which just-lsp needs to format.

#### What the migration involves

1. Add `~/.config/mise/conf.d/nvim.toml`, symlinked from the dotfiles, with the tools from `ensure_installed`. mise reads every file in `conf.d/` on top of `config.toml`, so Omarchy's file stays untouched:

   ```toml
   [tools]
   lua-language-server = "latest"
   "go:golang.org/x/tools/gopls" = "latest"
   "go:github.com/golangci/golangci-lint/v2/cmd/golangci-lint" = "latest"
   "npm:yaml-language-server" = "latest"
   "npm:@vtsls/language-server" = "latest"
   "npm:@vue/language-server" = "latest"
   "pipx:ansible-lint" = "latest"
   just = "latest"
   "github:terror/just-lsp" = "latest"
   tflint = "latest"
   # …
   ```

   Then run `mise install`, and later `mise upgrade` (or Omarchy's `mup`).

2. Remove mason.nvim, mason-lspconfig and mason-tool-installer. Without mason-lspconfig's automatic enabling, list the servers yourself with `vim.lsp.enable({ "ansiblels", "bashls", "gopls", … })`. nvim-lspconfig and the `after/lsp/` overrides keep working as they are.
3. Update the paths that point into Mason's folders:
   - `after/lsp/vtsls.lua`: the Vue TypeScript plugin location, which would come from `mise where npm:@vue/language-server`.
   - `after/lsp/ansiblels.lua`: the ansible-core bundled with Mason's `ansible-lint`. Install `ansible` separately (e.g. `pipx:ansible-core`), because pipx only exposes `ansible-lint`'s own commands.
   - Cosmetic: the catppuccin `mason` integration and the lualine `mason` extension.
4. Teach `:RemoteStart` to install mise on the host, copy `nvim.toml` and run `mise install`. Today Mason installs the tools there on first launch.

#### Trade-offs

- `:RemoteStart` gets slower the first time, and hosts without internet access lose their tools.
- No `:Mason` screen: installing and updating happen in a terminal. Pin exact versions with `mise.lock`, like `nvim-pack-lock.json` does for plugins.
- `PATH` is computed when Neovim starts. After `:cd` into another project inside the same Neovim, newly started servers keep the first project's versions. Opening one Neovim per project (tmux and sesh already do this) avoids it.
- Avoid a hybrid (mise locally, Mason on remote hosts): it means two tool lists drifting apart.

## Tips

- **Add a plugin**: put a `vim.pack.add()` block in `plugin/40_plugins.lua`, inside `Config.later()` unless it has to be visible at startup. Restart, and `nvim-pack-lock.json` gets the new entry. Commit it.
- **Remove a plugin**: delete its block, then run `:PackClean`.
- **Override an LSP server**: create `after/lsp/<server>.lua` and return a table. It is merged on top of nvim-lspconfig's defaults.
- **Restart Neovim**: `:restart` (0.12+). On 0.13-dev it also keeps the session (windows and buffers).
- **Health check**: `:checkhealth vim.pack`, `:checkhealth vim.lsp`, `:checkhealth snacks`.
