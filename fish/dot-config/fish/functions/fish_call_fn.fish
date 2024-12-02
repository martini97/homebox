function fish_call_fn --description "Call function with args if it exists"
    argparse --stop-nonopt --ignore-unknown 'f/file=' -- $argv

    set -l fn $argv[1]
    set -l args $argv[2..]

    if not __fish_call_fn__source_file "$_flag_file"
        __fish_call_fn__echoerr "could not source function file"
        return 1
    else if test -z "$fn"
        __fish_call_fn__echoerr "missing function name"
        return 1
    else if not functions -q "$fn"
        __fish_call_fn__echoerr "skipping non-existent function: $fn"
        return
    end

    "$fn" $args
end

function __fish_call_fn__source_file
    set -l path (builtin realpath -s -- $argv[1] 2>/dev/null)
    if test -z "$path"
        return
    else if not test -f "$path"
        __fish_call_fn__echoerr "file $path does not exist"
        return 1
    end
    source "$path"
end

function __fish_call_fn__echoerr
    echo "[fish_call_fn] $argv" >&2
end
