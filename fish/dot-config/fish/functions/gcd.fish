function gcd --description 'cd into current repo root'
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "gcd: not in a git repo" 1>&2
    end
    cd -- (git rev-parse --show-toplevel)
end
