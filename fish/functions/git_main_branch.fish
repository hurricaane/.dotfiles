function git_main_branch
    command git rev-parse --git-dir &>/dev/null; or return

    set -l ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}
        if command git show-ref -q --verify $ref
            echo (string match -r '[^/]+$' $ref)
            return 0
        end
    end
end
