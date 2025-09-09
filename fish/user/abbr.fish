abbr -a e nvim

abbr -a l eza
abbr -a ls eza
abbr -a la 'eza -a'
abbr -a ll 'eza -l'
abbr -a lla 'eza -la'

# tmux
abbr -a ta 'tmux attach -t'
abbr -a tk 'tmux kill-session -t'
abbr -a tn 'tmux new -s'
abbr -a tl 'tmux ls'
abbr -a ts '~/.config/tmux/bin/tmux-fuzzy-choose-session'
abbr -a tf '~/.config/tmux/bin/tmux-sessionizer'

# Git
abbr -a gs 'git status'
abbr -a gss 'git status -s' # short version

abbr -a gd 'git diff'
abbr -a gdd 'git diff --staged'
abbr -a gds 'git diff --stat'
abbr -a gso 'git show'
abbr -a sgd 'GIT_PAGER="delta --side-by-side" git diff'
abbr -a sgdd 'GIT_PAGER="delta --side-by-side" git diff --staged'
abbr -a sgds 'GIT_PAGER="delta --side-by-side" git diff --stat'
abbr -a sgso 'GIT_PAGER="delta --side-by-side" git show'

abbr -a ga 'git add'
abbr -a gr 'git remove'
abbr -a gc 'git commit'
abbr -a gam 'git commit --amend'
abbr -a gk 'git checkout'
abbr -a gp 'git pull'
abbr -a gpr 'git pull --prune'
abbr -a gpp 'git push'
abbr -a gb 'git branch'
abbr -a gbd 'git branch -vv | rg ": gone]" | awk \'{print $1}\' | xargs -p -I _ git branch -D _'
abbr -a gw 'git worktree'
abbr -a gwa 'git worktree add' # checkout branch (directory) in worktree
abbr -a gwr 'git worktree remove' # remove branch (directory) in worktree
abbr -a gll 'git log' # show git commits
abbr -a gl 'git log --oneline' # show git commits with less info (only commit message headline)
abbr -a glp 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all' # show git commits with graph and commit message headline
abbr -a glpv 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n"\'          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)\' --all' # show git commits with graph and commit message headline with date

abbr -a gsh 'git stash' # G-it S-tash H-ide
abbr -a gsp 'git stash pop' # G-it S-tash P-op

abbr -a cn 'cargo nextest'

# init zoxide
zoxide init fish | source
abbr -a cd z
abbr -a cdi zi

# makes sure zoxide is used instead of cd in scripts and commands from history
# found by fzf, so it can cache the paths
function cd
    z $argv
end

abbr ff "z (fd -H -td . '$HOME/Developer' | fzf)"

# add copy abbreviation for first available clipboard provider
for clipboard in gpaste-client wl-copy xclip pbcopy
    if type -q $clipboard
        abbr -a copy $clipboard
        break
    end
end

abbr -a curl3 /opt/homebrew/opt/curl/bin/curl

bind -M insert \cf zi
bind -M normal \cf zi
