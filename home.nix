{ pkgs, ... }: {
  imports = [
    ./nvim/init.nix
    ./fish/init.nix
    ./alacritty/init.nix
    ./bat/init.nix
    # ./ghostty/init.nix
  ];

  home.username = "nfejzic";
  home.homeDirectory = "/Users/nfejzic";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fzf
    just
    nixfmt
    ripgrep
    zoxide
  ];

  manual.manpages.enable = false;
  programs.man.generateCaches = false;
}
