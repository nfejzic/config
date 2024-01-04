set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'

if type -q "/home/$USER/.local/share/bob/nvim-bin/nvim"
    # use neovim installed by bob - nvim version manager
    set -gx SUDO_EDITOR "/home/$USER/.local/share/bob/nvim-bin/nvim"
else if type -q nvim
    set -qx SUDO_EDITOR 'nvim'
else if type -q vim
    set -qx SUDO_EDITOR 'vim'
else 
    set -qx SUDO_EDITOR 'vi'
end
