{
  # pkgs,
  # pkgsUnstable,
  # inputs,
  # config,
  # lib,
  ...
}:
{
  programs.alacritty = {
    enable = true;

    theme = "gruvbox_dark";
    settings.general.import = [ ./alacritty.toml ];
  };

  xdg.configFile."alacritty/colors/".source = ./colors;
}
