function vimrmplug --desc "Remove neovim plugins"
  set -l pack_dir "$HOME/.config/nvim/pack/"
  set -l plugins (find $pack_dir -mindepth 3 -maxdepth 3 -type d | fzf --multi)
  set -l gitroot (pushd $pack_dir ; git rev-parse --show-toplevel ; popd)
  for plugin in $plugins
    set -l plugin (realpath $plugin)
    set -l module (realpath "$gitroot/.git/modules/$(string replace $gitroot "" $plugin)")
    __vimrmplug $gitroot $plugin $module
  end
end

function __vimrmplug -a gitroot -a plugin -a module
  git -C $gitroot submodule deinit -f $plugin
  rm -rf $module
  git -C $gitroot rm -rf $plugin
end
