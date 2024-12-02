function fish_source_cmd --description "Source command output if it exists"
    set -l cmd $argv[1]
    set -l args $argv[2..]

    if test -z "$cmd"
        __fish_source_cmd_echoerr "missing command name"
        return 1
    end

    if command --query "$cmd"
        "$cmd" $args | source
    else if test -x "$cmd"
        "$cmd" $args | source
    end
end

function __fish_source_cmd_echoerr
    echo "[fish_source_cmd] $argv" >&2
end
