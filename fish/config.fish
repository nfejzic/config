starship init fish | source
set fish_greeting

# to update PATH variable in fish run following command in one shell session: 
# set -U fish_user_paths <PATH> $fish_user_paths

# That will permanently prepend the <PATH> to user paths universal variable

abbr -a c 'code .'
abbr -a cc 'clang'
abbr -a l 'exa'
abbr -a ls 'exa'
abbr -a la 'exa -a'
abbr -a ll 'exa -l'
abbr -a lla 'exa -la'
abbr -a nv 'nvim'
abbr -a vim 'nvim'
abbr -a work 'cd ~/Developer/Tomes/idana-local-setup/'
abbr -a ta 'tmux attach -t'
abbr -a tk 'tmux kill-session -t'
abbr -a tn 'tmux new -s'
abbr -a tl 'tmux ls'
abbr -a grep 'rg' # use ripgrep instead of grep, but don't relearn old habits

# Git
abbr -a gs 'git status'
abbr -a gss 'git status -s' # short version
abbr -a gd 'git diff'
abbr -a gdd 'git diff --staged'
abbr -a ga 'git add'
abbr -a gr 'git remove'
abbr -a gc 'git commit'
abbr -a gk 'git checkout'
abbr -a gp 'git pull'
abbr -a gpp 'git push'
abbr -a gw 'git worktree'
abbr -a gwa 'git worktree add' # checkout branch (directory) in worktree
abbr -a gwr 'git worktree remove' # remove branch (directory) in worktree
abbr -a gll 'git log' # show git commits
abbr -a gl 'git log --oneline' # show git commits with less info (only commit message headline)
abbr -a glp 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all' # show git commits with graph and commit message headline
abbr -a glpv 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n"\'          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)\' --all' # show git commits with graph and commit message headline with date

# set cursor to block always
set -g fish_cursor_insert 'block' 'blink'

# set theme of bat (cat alternative with syntax highlighting)
set -gx BAT_THEME "gruvbox-dark"
