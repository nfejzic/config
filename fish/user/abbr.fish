abbr -a c 'nvim'
abbr -a cc 'clang'
abbr -a l 'eza'
abbr -a ls 'eza'
abbr -a la 'eza -a'
abbr -a ll 'eza -l'
abbr -a lla 'eza -la'
abbr -a nv 'nvim'
abbr -a wstorm 'webstorm'
abbr -a worm 'webstorm'
abbr -a wm 'webstorm'
abbr -a work 'cd ~/Developer/Tomes/idana-local-setup/'
abbr -a grep 'rg' # use ripgrep instead of grep, but don't relearn old habits

# tmux
abbr -a ta 'tmux attach -t'
abbr -a tk 'tmux kill-session -t'
abbr -a tn 'tmux new -s'
abbr -a tl 'tmux ls'

# zellij
abbr -a ja 'zellij attach --create'
abbr -a jk 'zellij kill-session'
abbr -a jka 'zellij kill-all-sessions'
abbr -a jn 'zellij --session'
abbr -a jtn 'zellij --layout tomes --session'
abbr -a jen 'zellij --layout tomes_edit --session'
abbr -a jl 'zellij list-sessions'

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
abbr -a gk 'git checkout'
abbr -a gp 'git pull'
abbr -a gpp 'git push'
abbr -a gbd 'git branch -vv | rg gone | awk \'{print $1}\' | xargs -p -I _ git branch -D _'
abbr -a gw 'git worktree'
abbr -a gwa 'git worktree add' # checkout branch (directory) in worktree
abbr -a gwr 'git worktree remove' # remove branch (directory) in worktree
abbr -a gll 'git log' # show git commits
abbr -a gl 'git log --oneline' # show git commits with less info (only commit message headline)
abbr -a glp 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all' # show git commits with graph and commit message headline
abbr -a glpv 'git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n"\'          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)\' --all' # show git commits with graph and commit message headline with date

# Devilbox (http://devilbox.org/)
abbr -a dbox-lamp-up 'docker-compose up -d httpd php mysql bind' # launch lamp stack + bind
abbr -a dbox-lamp-down 'docker-compose down' # stop the lamp stack
abbr -a em 'emacsclient -c -n -a ""'

abbr -a cn 'cargo nextest'

# Wezterm
abbr -a wtt 'wezterm cli set-tab-title'

# add copy abbreviation for first available clipboard provider
set clipboard_providers 'gpaste-client' 'wl-copy' 'xclip' 'pbcopy'
for clipboard in $clipboard_providers 
    if type -q $clipboard
        abbr -a copy $clipboard
        break
    end
end
