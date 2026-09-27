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
  onePassPath =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  imports = [
    (import ./nvim/init.nix inputs)
    ./alacritty/init.nix
    ./bat/init.nix
    ./fish/init.nix
    ./ghostty/init.nix
    ./options.nix
    ./starship/init.nix
    ./task/init.nix
    ./tmux/init.nix
  ];

  home = {
    username = config.nfejzic.username;
    homeDirectory = lib.mkDefault "/Users/${config.nfejzic.username}";
    stateVersion = lib.mkDefault "26.05";

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
    ];

    packages = with pkgs; [
      bat
      cargo-insta
      cargo-machete
      cargo-nextest
      delta
      eza
      fd
      ffmpeg
      fzf
      gh
      graphviz
      jq
      just
      nixfmt
      rectangle
      ripgrep
      rustup
      tlrc
      tokei
      yq
      zellij
      zoxide

      opencode
    ];

    sessionVariables = {
      SSH_AUTH_SOCK = onePassPath;
    };
  };

  manual.manpages.enable = false;
  programs.man.generateCaches = false;

  programs.git = {
    enable = true;
    settings = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "...";
      };
    };
  };

  # NOTE: install fonts
  fonts.fontconfig.enable = true;
}
