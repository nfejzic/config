# The home-manager configuration. This is the substantive config: it imports
# every per-program module and sets the packages/identity. It is a function of
# the flake `inputs` (applied in flake.nix as `import ./home.nix inputs`) so it
# stays self-contained when reused from another flake — consumers don't have to
# reconstruct `extraSpecialArgs`. Sub-modules that need `inputs` (neovim) are
# imported with it applied; the rest are plain modules.
inputs:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  fonts' = inputs.fonts.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./options.nix
    ./alacritty/init.nix
    ./bat/init.nix
    ./fish/init.nix
    ./ghostty/init.nix
    (import ./nvim/init.nix inputs)
    ./starship/init.nix
    ./tmux/init.nix
  ];

  home = {
    # Identity comes from the `nfejzic.*` options (see options.nix), so a
    # consumer sets `nfejzic.username = "..."` and everything follows.
    username = config.nfejzic.username;
    homeDirectory = lib.mkDefault "/Users/${config.nfejzic.username}";
    stateVersion = lib.mkDefault "26.05";

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
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
