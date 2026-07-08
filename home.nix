{ pkgs, ... }: {
  imports = [
    ./nvim/init.nix
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

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "gruvbox";
        src = pkgs.fishPlugins.gruvbox.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellInit = "${builtins.readFile ./fish/config.fish}";
  };

  xdg.configFile."fish/user".source = ./fish/user;
  xdg.configFile."fish/themes".source = ./fish/themes;

}
