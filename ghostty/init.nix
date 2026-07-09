{
  pkgs,
  # pkgsUnstable,
  # inputs,
  # config,
  # lib,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings.config-file = [
      "${./fonts/berkeley_mono}"
      "${./tmux/config}"
    ];
  };

  xdg.configFile."ghostty/themes/".source = ./themes;
  xdg.configFile."ghostty/fonts/".source = ./fonts;
}
