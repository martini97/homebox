function bw_unlock --description 'Unlocks bw-cli vault'
    argparse --stop-nonopt --ignore-unknown --name=bw_unlock f/force -- $argv
    if test -n "$_flag_force"; or test -z "$BW_SESSION"
        set --universal --export BW_SESSION (bw unlock --raw)
    end
end
