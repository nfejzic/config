alias s := switch

switch:
    darwin-rebuild build --flake . --impure
    sudo nix-env -p /nix/var/nix/profiles/system --set ./result
    sudo ./result/activate
    rm -r ./result
