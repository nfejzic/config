function git_worktree_prune_gone --description "Remove worktrees and branches that are gone upstream"
    # Get list of "gone" branches
    set gone_branches (git branch -vv | grep ": gone]" | sed 's/^[\*\+]//g' | awk '{print $1}')

    for branch in $gone_branches
        # Check if this branch has a worktree
        set wt_path (git worktree list --porcelain | rg -B2 "branch refs/heads/$branch\$" | rg "^worktree " | awk '{print $2}')

        if test -n "$wt_path"
            echo "Removing worktree at: $wt_path (branch: $branch)"
            read -P "Proceed? [y/N] " -n 1 confirm
            if test "$confirm" = y -o "$confirm" = Y
                git worktree remove "$wt_path"
                git branch -D "$branch"
            end
        else
            # No worktree, just delete the branch
            echo "Deleting branch: $branch"
            read -P "Proceed? [y/N] " -n 1 confirm
            if test "$confirm" = y -o "$confirm" = Y
                git branch -D "$branch"
            end
        end
    end

    # Clean up any stale worktree references
    git worktree prune
end
