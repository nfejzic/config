# Function of the flake `inputs`, applied in home.nix as
# `(import ./nvim/init.nix inputs)`. `inputs` is taken lexically (not as a
# module argument) because it's used inside `imports` below, where module
# arguments aren't available yet (that path infinite-recurses).
inputs:
{
  config,
  lib,
  ...
}:
{
  imports = [
    (inputs.wrappers.lib.getInstallModule {
      name = "neovim";
      value = inputs.wrappers.lib.wrapperModules.neovim;
    })
  ];

  wrappers.neovim =
    { pkgs, ... }:
    let
      # blink.cmp needs its Rust fuzzy matcher, which comes from an overlay.
      # We apply it to a local `pkgs` here so that simply importing this module
      # brings blink with it — no consumer-side overlay wiring required. This
      # works even under home-manager's `useGlobalPkgs` (pkgs.extend is pure).
      pkgs' = pkgs.extend (
        lib.composeManyExtensions [
          inputs.blink-lib.overlays.default
          inputs.blink-cmp.overlays.default
        ]
      );

      # diffview-plus-nvim is only packaged in nixpkgs-unstable, so we
      # instantiate unstable for this system on the side.
      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };

      fromGitHub =
        ref: repo:
        pkgs'.vimUtils.buildVimPluginFrom2Nix {
          pname = "${lib.strings.sanitizeDerivationName repo}";
          version = ref;
          src = fetchGit {
            inherit ref;
            url = "https://github.com/${repo}.git";
          };
        };
      # The vscode-lldb extension buries codelldb under share/vscode/…
      # with no bin/ entry. This derivation creates a bin/codelldb
      # symlink so runtimePkgs puts it on PATH.
      codelldb = pkgs'.runCommand "codelldb" { } ''
        mkdir -p $out/bin
        ln -s ${pkgs'.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
      '';
    in
    {
      enable = true;
      settings.config_directory = ./.;

      runtimePkgs = with pkgs'; [
        rust-analyzer
        typescript-go
        lua-language-server
        nixd
        stylua
        codelldb
        nixfmt
        prettier
        prettierd
      ];

      specs.lze = {
        lazy = false;
        before = [ "INIT_MAIN" ];
        data = [ pkgs'.vimPlugins.lze ];
      };

      specs.all = {
        lazy = false;
        before = [ "INIT_MAIN" ];

        data = with pkgs'.vimPlugins; [
          which-key-nvim
          oil-nvim

          mini-icons
          lze
          snacks-nvim
          FixCursorHold-nvim
          quicker-nvim
          smart-splits-nvim
          lualine-nvim

          blink-cmp
          luasnip

          # colorschemes
          gruvbox-nvim
          catppuccin-nvim
          kanagawa-nvim
          rose-pine
          (fromGitHub "HEAD" "RostislavArts/naysayer.nvim")

          # languages
          rustaceanvim
          go-nvim

          # syntax highlighting and more!
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-treesitter-context

          # formatting
          conform-nvim

          # git
          gitsigns-nvim
          vim-fugitive
          pkgsUnstable.vimPlugins.diffview-plus-nvim
          codediff-nvim
          neogit

          lazydev-nvim

          # LSP
          nvim-lspconfig
          fidget-nvim

          # debuggers
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-dap-go

          # testing
          nvim-nio
          neotest
          neotest-rust
          neotest-go

          # tpope
          vim-repeat
          vim-surround
          vim-sleuth
        ];
      };

      # Colorscheme override, driven by the `nfejzic.neovim.colorscheme` option.
      # Runs after the base config (INIT_MAIN) via a VimEnter autocmd, so it
      # wins over the `vim.cmd("colo ...")` in nvim/lua/plugins/colors.lua
      # regardless of how/when that runs.
      specs.colorscheme = {
        before = [ "INIT_MAIN" ]; # runs before your config, just sets a global
        data = null;
        config =
          # lua
          ''
            vim.g.nfejzic_colorscheme = "${config.nfejzic.neovim.colorscheme}"
          '';
      };

    };

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
}
