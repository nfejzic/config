{
  pkgs,
  fonts,
  lib,
  config,
  ...
}:
let
  fonts' = fonts.packages.${pkgs.system};
in
{
  imports = [
    ./alacritty/init.nix
    ./bat/init.nix
    ./fish/init.nix
    ./ghostty/init.nix
    ./nvim/init.nix
    ./starship/init.nix
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
      gh
      tlrc

      opencode

      fonts'.berkeley-mono
      fonts'.comic-code-dotted-zero
    ];
  };

  manual.manpages.enable = false;
  programs.man.generateCaches = false;

  # NOTE: install fonts
  fonts.fontconfig.enable = true;
  # NOTE: macOS doesn't use fontconfig for native apps (Font Book, Terminal, etc.)
  # This activation script copies fonts from the HM profile into ~/Library/Fonts/
  # so macOS Core Text can discover them.

  home.activation.installFonts = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ]
      # sh
      ''
        if [ -d "${config.home.path}/share/fonts" ]; then
          $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/Library/Fonts/HomeManager
          $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/Library/Fonts/HomeManager
          $DRY_RUN_CMD cp -r $VERBOSE_ARG ${config.home.path}/share/fonts/* ~/Library/Fonts/HomeManager/
          # Fix permissions (macOS needs readable fonts)
          $DRY_RUN_CMD find ~/Library/Fonts/HomeManager -type d -exec chmod 755 {} \;
          $DRY_RUN_CMD find ~/Library/Fonts/HomeManager -type f -exec chmod 644 {} \;
        fi
      ''
  );
}
