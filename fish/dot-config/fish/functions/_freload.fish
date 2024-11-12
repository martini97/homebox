function _freload --description "Reload fish config"
  set -l config_dir $__fish_config_dir
  set -l config_files (find $config_dir -follow -type f -name '*.fish')
  for file in $config_files
    source $file
  end
end
