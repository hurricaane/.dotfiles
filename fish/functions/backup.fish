function backup
    if test (count $argv) -ne 1
        echo "Usage: backup <filename-or-folder>"
        return 1
    end

    set -l original $argv[1]

    if not test -e $original
        echo "Error: '$original' does not exist."
        return 1
    end

    # Ne pas ajouter plusieurs ".bk"
    if string match -q "*.bk" $original
        echo "Already a backup: '$original'"
        return 1
    end

    set -l backup_name "$original.bk"

    # Évite d’écraser une sauvegarde existante
    if test -e $backup_name
        echo "Backup already exists: '$backup_name'"
        return 1
    end

    mv $original $backup_name
    echo "Backup created: $backup_name"
end
