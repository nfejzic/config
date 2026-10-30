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

  op-ssh-sign =
    if pkgs.stdenv.isDarwin then
      "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
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

  nfejzic.ghostty.font = "comic-code";
  nfejzic.ghostty.font-features = [
    "zero"
    "liga"
    "calt"
    "dlig"
  ];

  home = {
    username = config.nfejzic.username;
    homeDirectory = lib.mkDefault "/Users/${config.nfejzic.username}";
    stateVersion = lib.mkDefault "26.05";

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
    ];

    packages =
      let
        allPackages = with pkgs; [
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

          crush

          # very useful git tools
          mergiraf
          difftastic
          diffsitter
        ];
      in
      builtins.filter (p: !(builtins.elem (lib.getName p) config.nfejzic.excludePackages)) allPackages;

    sessionVariables = {
      SSH_AUTH_SOCK = onePassPath;
    };
  };

  manual.manpages.enable = false;
  programs.man.generateCaches = false;

  programs.git = {
    enable = true;
    # NOTE: everything here merges with the git config of any flake reusing this
    # module, so consumers only add what differs (identity, extra ignores, ...).

    # The global ignore list is fed through `ignores` (a list option, so
    # consumers can append to it) rather than `core.excludesFile`. Setting
    # `core.excludesFile` would make git skip `~/.config/git/ignore`, silently
    # dropping every consumer's `programs.git.ignores` entries.
    ignores = lib.filter (line: line != "" && !lib.hasPrefix "#" line) (
      lib.splitString "\n" (builtins.readFile ./git/ignore)
    );

    settings = {
      # Signing goes through 1Password's SSH agent.
      gpg = {
        format = "ssh";
        # Nested (not a quoted `"gpg \"ssh\""` key) so it merges with, and can be
        # overridden by, a consumer's `gpg.ssh.program`.
        ssh.program = op-ssh-sign;
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "~/.ssh/id_ed25519.pub";
      };

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;

      # NOTE: see https://mergiraf.org/usage.html#usage
      merge = {
        conflictStyle = "diff3";
        mergiraf = {
          name = "mergiraf";
          driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
        };
      };

      push.default = "current";

      push.autoSetupRemote = true;
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };

    attributes = [ "* merge=mergiraf" ];
  };

  # NOTE: install fonts
  fonts.fontconfig.enable = true;
}
