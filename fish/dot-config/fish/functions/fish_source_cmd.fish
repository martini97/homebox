function fish_source_cmd --description "Source command output if it exists"
    set -l cmd $argv[1]
    set -l args $argv[2..]

    if test -z "$cmd"
        echo "Missing command name"
        return 1
    end

    if command --query "$cmd"
        "$cmd" $args | source
    else if test -x "$cmd"
        "$cmd" $args | source
    end
end
