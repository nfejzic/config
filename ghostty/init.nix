{
  pkgs,
  config,
  lib,
  # pkgsUnstable,
  # inputs,
  ...
}:
let
  font_options = {
    berkeley-mono = ./fonts/berkeley_mono;
    comic-code = ./fonts/comic_code;
    fira-code = ./fonts/fira_code;
    monolisa = ./fonts/monolisa;
    atkinson-monolegible = ./fonts/atkinson_monolegible;
  };
  font_file = font_options.${config.nfejzic.ghostty.font};

  font_features_file = pkgs.writeText "ghostty-font-features" (
    lib.concatMapStrings (f: "font-feature = ${f}\n") config.nfejzic.ghostty.font-features
  );
in
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings.config-file = [
      "${font_file}"
      "${font_features_file}"
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
