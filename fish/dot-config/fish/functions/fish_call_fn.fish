function fish_call_fn --description "Call function with args if it exists"
    set -l fn $argv[1]
    set -l args $argv[2..]

    if test -z "$fn"
        echo "Missing function name"
        return 1
    else if not functions -q "$fn"
        echo "Skipping non-existent function: $fn"
        return
    end

    "$fn" $args
end
