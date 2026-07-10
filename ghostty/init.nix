{
  pkgs,
  config,
  # pkgsUnstable,
  # inputs,
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
      # Theme override, driven by the `nfejzic.ghostty.theme` option. Listed
      # last so it wins: Ghostty applies a file's config-file includes in order
      # and the last-set `theme` takes effect (the theme inside tmux/config
      # above can't be beaten by a top-level `theme` key, only by a later
      # include).
      "${pkgs.writeText "ghostty-theme" ''
        theme = ${config.nfejzic.ghostty.theme}
      ''}"
    ];
  };

  xdg.configFile."ghostty/themes/".source = ./themes;
  xdg.configFile."ghostty/fonts/".source = ./fonts;
}
