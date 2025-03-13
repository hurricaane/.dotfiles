function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
    # Custom key bindings
    set -l on_escape '
        if commandline -P
            commandline -f cancel
        else
            set fish_bind_mode default
            if test (count (commandline --cut-at-cursor | tail -c2)) != 2
                commandline -f backward-char
            end
            commandline -f repaint-mode
        end
    '
    bind --erase --preset --mode insert escape
    bind --mode insert --sets-mode default jk $on_escape
    bind --mode insert ctrl-s forward-word
    bind --mode insert ctrl-r _atuin_search
    bind --mode default / _atuin_search
end
