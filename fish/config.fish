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
abbr -a sites 'cd ~/Documents/Sites/'
abbr -a ta 'tmux attach -t'
abbr -a tk 'tmux kill-session -t'
abbr -a tn 'tmux new -s'
abbr -a tl 'tmux ls'
abbr -a grep 'rg' # use ripgrep instead of grep, but don't relearn old habits

# set cursor to block always
set -g fish_cursor_insert 'block' 'blink'
