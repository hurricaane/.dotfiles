if status is-interactive
    # Commands to run in interactive sessions can go here
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    set -gx ATUIN_NOBIND true
    atuin init fish | source

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
        set session (sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
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
end
