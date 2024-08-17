if type -q nvim
    abbr -a e 'nvim'
end

if type -q clang
    abbr -a cc 'clang'
else
    __print -e "fish: could not setup abbr for clang, clang not found"
end

if type -q eza
    abbr -a l 'eza'
    abbr -a ls 'eza'
    abbr -a la 'eza -a'
    abbr -a ll 'eza -l'
    abbr -a lla 'eza -la'
else
    __print -e "fish: could not setup abbr for eza, eza not found"
end

abbr -a work 'cd ~/Developer/Tomes/idana-local-setup/'

# tmux
if type -q tmux
    abbr -a ta 'tmux attach -t'
    abbr -a tk 'tmux kill-session -t'
    abbr -a tn 'tmux new -s'
    abbr -a tl 'tmux ls'
else
    __print -e "fish: could not setup abbr for tmux, tmux not found"
end

# zellij
if type -q zellij
    abbr -a ja 'zellij attach --create'
    abbr -a jk 'zellij kill-session'
    abbr -a jka 'zellij kill-all-sessions'
    abbr -a jn 'zellij --session'
    abbr -a jtn 'zellij --layout tomes --session'
    abbr -a jen 'zellij --layout tomes_edit --session'
    abbr -a jl 'zellij list-sessions'
else
    __print -e "fish: could not setup abbr for zellij, zellij not found"
end

# Git
if type -q git
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
else
    __print -e "fish: could not setup abbr for git, git not found"
end

# Devilbox (http://devilbox.org/)
if type -q docker-compose
    abbr -a dbox-lamp-up 'docker-compose up -d httpd php mysql bind' # launch lamp stack + bind
    abbr -a dbox-lamp-down 'docker-compose down' # stop the lamp stack
else if type -q podman-compose
    abbr -a dbox-lamp-up 'podman-compose up -d httpd php mysql bind' # launch lamp stack + bind
    abbr -a dbox-lamp-down 'podman-compose down' # stop the lamp stack
else
    __print -e "fish: could not setup abbr for docker-compose, docker-compose not found"
end

if type -q cargo
    abbr -a cn 'cargo nextest'
else
    __print -e "fish: could not setup abbr for cargo, cargo not found"
end

if type -q zoxide
    # init zoxide
    zoxide init fish | source
    abbr -a cd "z"
    abbr -a cdi "zi"

    # makes sure zoxide is used instead of cd in scripts and commands from history
    # found by fzf, so it can cache the paths
    alias cd "z" 
else
    __print -e "fish: could not setup abbr for zoxide, zoxide not found"
end

# add copy abbreviation for first available clipboard provider
set clipboard_providers 'gpaste-client' 'wl-copy' 'xclip' 'pbcopy'
for clipboard in $clipboard_providers 
    if type -q $clipboard
        if test "$clipboard" = "gpaste-client" && test "$DESKTOP_SESSION" = "hyprland"
            # hyprland uses wl-copy and wl-paste
            continue
        end

        abbr -a copy $clipboard
        break
    end
end

if type -q /opt/homebrew/opt/curl/bin/curl
    abbr -a curl3 "/opt/homebrew/opt/curl/bin/curl"
end
