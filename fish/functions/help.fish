function help
    set -l cmd $argv

    # Essaye avec --help
    $cmd --help 2>/dev/null | bat --plain --language=help
    or begin
        # Si --help échoue, tente -h
        $cmd -h 2>&1 | bat --plain --language=help
    end
end
