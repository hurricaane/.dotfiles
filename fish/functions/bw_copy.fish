function bw_copy
    set searchterm $argv[1]

    if test -z "$BW_SESSION"
        echo "Erreur : BW_SESSION n'est pas défini. Lance 'bw_unlock' d'abord."
        return 1
    end

    set logins (bw list items --search $searchterm --session $BW_SESSION)

    set id (echo $logins | jq -r '.[] | "\(.name)\t\(.login.username)\t\(.id)"' \
        | fzf --reverse --with-nth=1,2 --delimiter="\t" --select-1 --exit-0 \
        | awk -F"\t" '{print $3}')

    if test -n "$id"
        set login (echo $logins | jq ".[] | select(.id == \"$id\")")

        set name (echo $login | jq -r ".name")
        set username (echo $login | jq -r ".login.username")
        set password (echo $login | jq -r ".login.password")

        echo "Name: $name"

        if test "$username" != null -a -n "$username"
            read -n 1 -P "> Copier le username ? (y/n) " answer
            if test "$answer" = y
                echo "> Copie du Username"
                echo -n $username | xsel --clipboard --input
            end
        end

        read -P "> Appuie sur une touche pour copier le mot de passe..." tmp
        echo -n $password | xsel --clipboard --input
        echo "> Copie du Password"
    end
end
