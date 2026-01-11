if status is-interactive
    # Commands to run in interactive sessions can go here
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    set -gx ATUIN_NOBIND true
    atuin init fish | source
    # Homebrew
    if test -d /home/linuxbrew/.linuxbrew # Linux
        set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
        set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
        set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
    else if test -d /opt/homebrew # MacOS
        set -gx HOMEBREW_PREFIX /opt/homebrew
        set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
        set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
    end
    fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

    ! set -q MANPATH; and set MANPATH ''
    set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

    ! set -q INFOPATH; and set INFOPATH ''
    set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

    fish_add_path ~/.local/bin
    fish_add_path ~/.local/share/bob/nvim-bin

    # Auto-start tmux or attach to existing session using sesh
    if type -q tmux
        # Avoid starting tmux inside tmux or via SSH
        if not set -q TMUX; and not set -q SSH_TTY
            # Check if any tmux sessions exist
            set existing_sessions (tmux list-sessions 2>/dev/null)

            if test -n "$existing_sessions"
                # At least one tmux session exists → attach to the first one
                set first_session (echo $existing_sessions | head -n 1 | awk -F: '{print $1}')
                echo (set_color cyan)"🔗 Attaching to existing tmux session: $first_session"(set_color normal)
                sleep 0.3
                tmux attach -t $first_session
            else
                # No tmux session exists → start sesh selection
                echo (set_color yellow)"⚡ No tmux sessions found — launching sesh..."(set_color normal)
                echo ""
                set session (sesh list -t -c -z | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
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

# Disable fish greeting
set -U fish_greeting

# Environment variables
set -Ux EDITOR nvim
set -Ux ZK_NOTEBOOK_DIR "$HOME/Documents/Notes"

# Starship
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

# Fzf
fzf --fish | source

# Zoxide
zoxide init fish --cmd cd | source

# Direnv
direnv hook fish | source
set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change (default)

# Batman
batman --export-env | source

# Batpipe
eval (batpipe)

# yazi shorcut
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function sesh-sessions
    set session (sesh list -t -c -z | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    if [ -z "$session" ]
        return
    end
    sesh connect "$session"
end

# Pyenv
pyenv init - fish | source
status --is-interactive; and pyenv virtualenv-init - | source

# Theme
fish_config theme choose tokyonight_moon

# Vi mode
set -U fish_key_bindings fish_vi_key_bindings
# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

# Sudo editor
set -gx SUDO_EDITOR nvim

# Go path
fish_add_path /usr/local/go/bin
fish_add_path "$HOME/go/bin"

# Nix path
fish_add_path /nix/var/nix/profiles/default/bin
fish_add_path "$HOME/.nix-profile/bin"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Cargo
fish_add_path "$HOME/.cargo/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
