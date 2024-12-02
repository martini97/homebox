function envsource --description "Source env var files"
    argparse --stop-nonopt --ignore-unknown v/verbose -- $argv; or return

    for line in (grep --no-filename --extended-regexp --invert-match '(^#)|(^[[:space:]]*$)' $argv)
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
        if set -q _flag_verbose
            echo "[envsource] sourced variable $item[1]" >&2
        end
    end
end
