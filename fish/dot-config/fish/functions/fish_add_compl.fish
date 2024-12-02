function fish_add_compl --description "Add paths to the fish complete path"
    argparse p/prepend v/verbose -- $argv
    or return

    for path in $argv
        set -l p (builtin realpath -s -- $path 2>/dev/null)

        if not test -d "$p"
            if set -q _flag_verbose
                __fish_add_compl_echoerr "skipping non-existent path: $p"
            end
            continue
        else if contains -- $p $fish_complete_path
            if set -q _flag_verbose
                __fish_add_compl_echoerr "skipping path already in completion: $p"
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

function __fish_add_compl_echoerr
    echo "[fish_add_compl] $argv" >&2
end
