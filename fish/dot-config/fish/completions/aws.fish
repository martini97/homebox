# see https://stackoverflow.com/questions/26981542/aws-cli-command-completion-with-fish-shell
function __fish_aws_completer
    env COMP_LINE=(commandline -pc) aws_completer | tr -d ' '
end

complete -c aws -f -a "(__fish_aws_completer)"
