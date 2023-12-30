starship init fish | source
set fish_greeting

# to update PATH variable in fish run following command in one shell session: 
# set -U fish_user_paths <PATH> $fish_user_paths

# linuxbrew
# set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
# set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
# set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
# set -q PATH; or set PATH ''; set -gx PATH "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $PATH;
# set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH;
# set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH;

# That will permanently prepend the <PATH> to user paths universal variable

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

# set cursor to block always
# set -g fish_cursor_insert 'block' 'blink'

# set theme of bat (cat alternative with syntax highlighting)
# set -gx BAT_THEME "base16"
# set -gx BAT_THEME "gruvbox-dark"
set -gx BAT_THEME "Catppuccin-macchiato"
# set -gx BAT_THEME "rose-pine"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /home/nfejzic/.local/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# set default editor
# set -gx EDITOR 'hx'
# set -gx VISUAL 'hx'
set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'

# set -gx SUDO_EDITOR 'hx'

if type -q "/home/$USER/.local/share/bob/nvim-bin/nvim"
    set -gx SUDO_EDITOR "/home/$USER/.local/share/bob/nvim-bin/nvim"
else if type -q nvim
    set -qx SUDO_EDITOR 'nvim'
else if type -q vim
    set -qx SUDO_EDITOR 'vim'
else 
    set -qx SUDO_EDITOR 'vi'
end

# add copy abbreviation only if one of the providers is available
set clipboard_providers 'gpaste-client' 'wl-copy' 'xclip' 'pbcopy'
for clipboard in $clipboard_providers 
    if type -q $clipboard
        abbr -a copy $clipboard
        # abbr -a cpy "$(abbr | rg copy | awk '{print $5}')" 
        break
    end
end

# theme_gruvbox dark hard
# fish_config theme save "Catppuccin Mocha"

# WORK RELATED

# add gcloud stuff to path
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"

# jpeg binary and library
# For compilers to find jpeg you may need to set:
set -gx LDFLAGS "-L/opt/homebrew/opt/jpeg/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/jpeg/include"
# For pkg-config to find jpeg you may need to set:
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/jpeg/lib/pkgconfig"

set -gx GPG_TTY (tty)

function set_fzf_scheme -a scheme
    switch $scheme
        case gruvbox
            set --export FZF_DEFAULT_OPTS "--height 75% --border --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
              --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54"

        case catppuccin_latte
            set -Ux FZF_DEFAULT_OPTS "\
            --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
            --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
            --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
        
        case catppuccin_frappe
            set -Ux FZF_DEFAULT_OPTS "\
            --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
            --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
            --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
        
        case catppuccin_macchiato
            set -Ux FZF_DEFAULT_OPTS "\
            --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
            --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
            --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
        
        case catppuccin_mocha
            set -Ux FZF_DEFAULT_OPTS "\
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    end
end

set_fzf_scheme catppuccin_macchiato
