function homebox
  set -l name $TOOLBOX_NAME
  test -z "$name"; and set name "homebox"
  # TODO(2024-11-11): @martini97: check if already in a toolbox first
  toolbox enter "$name"
end
