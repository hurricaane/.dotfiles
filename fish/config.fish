# ─── Universal / non-interactive settings ─────────────────────────────────────
set -U fish_greeting
set -Ux EDITOR nvim
set -Ux SUDO_EDITOR nvim
set -Ux ZK_NOTEBOOK_DIR "$HOME/Documents/Notes"
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -Ux PYENV_ROOT $HOME/.pyenv

# ─── Interactive session ───────────────────────────────────────────────────────
if status is-interactive

    # ── PATH setup (do this first so everything below finds its binaries) ──────
    fish_add_path $PYENV_ROOT/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path /usr/local/go/bin
    fish_add_path "$HOME/go/bin"
    fish_add_path /nix/var/nix/profiles/default/bin
    fish_add_path "$HOME/.nix-profile/bin"
    fish_add_path "$HOME/.cargo/bin"
    fish_add_path "$HOME/.bun/bin"
    fish_add_path "$HOME/.local/share/pnpm"

    # ── Homebrew ───────────────────────────────────────────────────────────────
    if test -d /home/linuxbrew/.linuxbrew
        set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    else if test -d /opt/homebrew
        set -gx HOMEBREW_PREFIX /opt/homebrew
    end
    if set -q HOMEBREW_PREFIX
        set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
        set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
        fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
        set -q MANPATH; or set MANPATH ''
        set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH
        set -q INFOPATH; or set INFOPATH ''
        set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
    end

    # ── pnpm / bun env vars (export, not just PATH) ───────────────────────────
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    set -gx BUN_INSTALL "$HOME/.bun"

    # ── Tool initialisations ───────────────────────────────────────────────────
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    fzf --fish | source # fzf keybindings (used by atuin, etc.)
    zoxide init fish --cmd cd | source
    direnv hook fish | source
    set -g direnv_fish_mode eval_on_arrow

    batman --export-env | source
    eval (batpipe)

    pyenv init - fish | source
    pyenv virtualenv-init - | source

    tv init fish | source # Television shell integration

    # ── Starship prompt ────────────────────────────────────────────────────────
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience

    # ── Vi mode & cursor shapes ────────────────────────────────────────────────
    set -U fish_key_bindings fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block

    # ── Theme ──────────────────────────────────────────────────────────────────
    fish_config theme choose catppuccin-mocha --color-theme=dark

    # ── Auto-start: attach to existing tmux session or launch sesh via tv ──────
    if type -q tmux
        if not set -q TMUX; and not set -q SSH_TTY
            set existing_sessions (tmux list-sessions 2>/dev/null)
            if test -n "$existing_sessions"
                set first_session (echo $existing_sessions | head -n 1 | awk -F: '{print $1}')
                echo (set_color cyan)"🔗 Attaching to existing tmux session: $first_session"(set_color normal)
                sleep 0.3
                tmux attach -t $first_session
            else
                echo (set_color yellow)"⚡ No tmux sessions found — launching sesh..."(set_color normal)
                echo ""
                # Use Television instead of fzf
                set session (tv sesh)
                if test -z "$session"
                    set session home
                    echo (set_color yellow)"⚠️  No session selected — connecting to 'home'"(set_color normal)
                else
                    echo (set_color cyan)"🔗 Connecting to session: $session"(set_color normal)
                end
                sleep 0.2
                sesh connect "$session"
            end
            exit
        end
    end

end

# ─── Functions ────────────────────────────────────────────────────────────────

# yazi: change directory on exit
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# sesh session picker — now using Television
function sesh-sessions
    set session (tv sesh)
    if test -z "$session"
        return
    end
    sesh connect "$session"
end
