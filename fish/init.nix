{
  pkgs,
  # pkgsUnstable,
  # inputs,
  # config,
  # lib,
  ...
}:
{
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
    shellInit = "${builtins.readFile ./config.fish}";
  };

  xdg.configFile."fish/user".source = ./user;
  xdg.configFile."fish/themes".source = ./themes;
}
