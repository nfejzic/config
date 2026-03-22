function git_worktree_add --description "Git worktree add with prefix"
    set -l branch $argv[1]
    echo "executing: git worktree add ../$branch -b nfejzic/$branch"
    git worktree add ../$branch -b nfejzic/$branch
end
