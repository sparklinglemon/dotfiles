if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_key_bindings fish_vi_key_bindings
    function fish_mode_prompt
        #Do Nothing(overrides default behavior)
    end

    echo (prompt_pwd) (fish_git_prompt)

    #alias
    alias work="cd /mnt/d/work/"
    alias rebuild="sudo nixos-rebuild switch --flake ~/dotfiles"

end
