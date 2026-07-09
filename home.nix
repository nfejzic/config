{ pkgs, ... }: {
  imports = [
    ./nvim/init.nix
    ./fish/init.nix
    ./alacritty/init.nix
    ./bat/init.nix
    ./ghostty/init.nix
    ./tmux/init.nix
  ];

  home = rec {
    username = "nfejzic";
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";

    sessionPath = [
      "${homeDirectory}/.local/bin"
      "${homeDirectory}/.cargo/bin"
    ];

    packages = with pkgs; [
      eza
      fzf
      just
      nixfmt
      ripgrep
      zoxide
    ];
  };

  manual.manpages.enable = false;
  programs.man.generateCaches = false;

  # NOTE: some packages require font config to be available, for example 'ghostty-bin'
  fonts.fontconfig.enable = true;
}
