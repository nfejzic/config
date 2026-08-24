# Configuration knobs exposed by this config, with sensible defaults for the
# standalone `aeration` machine. Any flake that reuses `homeModules.default`
# (e.g. the work config) overrides these at normal priority — no mkForce needed.
{ lib, ... }:
{
  options.nfejzic = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "nfejzic";
      description = "Primary user; drives home.username and the default homeDirectory.";
    };

    neovim.colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "rose-pine";
      description = ''
        Neovim colorscheme. Applied after the base config (INIT_MAIN) so it
        overrides whatever `nvim/lua/plugins/colors.lua` sets. The matching
        plugin must be present in the neovim module's plugin list.
      '';
    };

    ghostty.theme = lib.mkOption {
      type = lib.types.str;
      default = "dark:Rose Pine Moon,light:Rose Pine Dawn";
      description = ''
        Ghostty theme. Appended as the last config-file so it wins over the
        theme set inside the bundled ghostty/tmux/config.
      '';
    };

    ghostty.font = lib.mkOption {
      type = lib.types.enum [
        "berkeley-mono"
        "comic-code"
        "monolisa"
      ];
      default = "berkeley-mono";
      description = "Font family for Ghostty.";
    };
  };
}
