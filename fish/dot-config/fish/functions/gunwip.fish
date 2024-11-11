function gunwip --description="git uncommit the work-in-progress branch"
  git log -n 1 | grep -q -c "\--wip--";
  and git reset HEAD~1
end
