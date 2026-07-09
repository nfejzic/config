{
  # pkgs,
  # pkgsUnstable,
  # inputs,
  # config,
  # lib,
  ...
}:
{
  programs.tmux = {
    enable = true;

    extraConfig = ''
      ${builtins.readFile ./tmux.conf}
    '';
  };

  xdg.configFile."tmux/plux.toml".source = ./plux.toml;
  xdg.configFile."tmux/bin/".source = ./bin;
  xdg.configFile."tmux/themes/".source = ./themes;
}
