function fish_source_file --description "Source file if it exists"
    set -l path (builtin realpath -s -- $argv[1] 2>/dev/null)

    if test -z "$path"
        echo "Missing path"
        return 1
    else if not test -f "$path"
        echo "Skipping non-existent path: $path"
        return
    end

    source "$path"
end
