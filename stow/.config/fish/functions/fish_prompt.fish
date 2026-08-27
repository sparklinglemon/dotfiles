function fish_prompt
    set -l last_status $status

    # Current directory (shortened if needed)
    set_color cyan
    printf '%s ' (prompt_pwd)

    # Git branch (if inside git repo)
    set_color purple
    printf '%s' (fish_git_prompt)

    # Final symbol (green ➜ for success, red ✖ for error)
    if test $last_status -eq 0
        set_color green
        printf ' ➜ '
    else
        set_color red
        printf ' ✖ '
    end

    set_color normal
end

