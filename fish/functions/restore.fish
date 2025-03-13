function restore
    if test (count $argv) -ne 1
        echo "Usage: restore <filename-or-folder>.bk"
        return 1
    end

    set -l backup $argv[1]

    # Vérifie que le fichier est un .bk
    if not string match -q "*.bk" $backup
        echo "Error: '$backup' is not a .bk file"
        return 1
    end

    if not test -e $backup
        echo "Error: Backup file '$backup' does not exist."
        return 1
    end

    # Nom d’origine sans .bk
    set -l original (string replace -r '\.bk$' '' $backup)

    if test -e $original
        echo "Error: Original file '$original' already exists. Restore aborted."
        return 1
    end

    mv $backup $original
    echo "Restored: $original"
end
