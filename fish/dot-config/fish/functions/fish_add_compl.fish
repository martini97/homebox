function fish_add_compl --description "Add paths to the fish complete path"
    argparse p/prepend v/verbose n/dry-run -- $argv
    or return

    for path in $argv
        set -l p (builtin realpath -s -- $path 2>/dev/null)
        if not test -d "$p"
            if set -q _flag_verbose
                printf (_ "Skipping non-existent path: %s\n") "$p"
            end
            continue
        end
        if contains -- $p $fish_complete_path
            if set -q _flag_verbose
                printf (_ "Skipping path already in completion: %s\n") "$p"
            end
            continue
        end

        if set -q _flag_prepend
            set -p fish_complete_path "$p"
        else
            set -a fish_complete_path "$p"
        end
    end
end
