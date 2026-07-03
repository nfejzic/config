alias s := switch

switch: 
    sudo darwin-rebuild switch --flake . --impure
