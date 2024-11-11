function gwip --description="git commit a work-in-progress branch"
  git add -A
  git rm (git ls-files --deleted) 2>/dev/null
  git commit --no-gpg-sign --no-verify --message "--wip-- [skip ci]"
end
