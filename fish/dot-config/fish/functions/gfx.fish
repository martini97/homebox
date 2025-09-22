function gfx --description 'git fixup'
    set -l target $argv[1]
    set -l fixup (git rev-parse $target)
    set -l args $argv[2..]

    git commit --fixup="$fixup" $args
    EDITOR=true git rebase --interactive --autostash --autosquash "$fixup^"
end
