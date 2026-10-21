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
        rev: repo:
        pkgs'.vimUtils.buildVimPlugin {
          pname = "${lib.strings.sanitizeDerivationName repo}";
          version = rev;
          src = fetchGit {
            inherit rev;
            url = "https://github.com/${repo}.git";
          };
        };
      # Debug adapter for C, C++ and Rust: LLVM's `lldb-dap` (codelldb is
      # not allowed at work). nvim-dap, rustaceanvim and neotest-rust all
      # find it on PATH under this name.
      #
      # On macOS we use Apple's lldb-dap from the active Xcode / Command Line
      # Tools rather than nixpkgs' lldb: Apple's build is codesigned and comes
      # with the matching `debugserver`, so it can attach to processes without
      # any extra entitlement setup. We clear DEVELOPER_DIR/SDKROOT and call
      # /usr/bin/xcrun by absolute path because Nix devshells point both at a
      # store SDK (and may shadow xcrun), where no lldb-dap exists.
      #
      # We only use xcrun to *find* lldb-dap and then exec it by absolute path.
      # `xcrun lldb-dap` would start it with a bare `lldb-dap` as argv[0], and
      # lldb-dap builds its runInTerminal launcher command from argv[0], so
      # nvim-dap would try to run `<cwd>/lldb-dap`.
      lldb-dap =
        if pkgs'.stdenv.isDarwin then
          pkgs'.writeShellScriptBin "lldb-dap" ''
            dap=$(env -u DEVELOPER_DIR -u SDKROOT /usr/bin/xcrun --find lldb-dap) || exit 1
            exec env -u DEVELOPER_DIR -u SDKROOT "$dap" "$@"
          ''
        else
          pkgs'.lldb;
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
        lldb-dap
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
          phha-zenburn
          # zenbones builds its themes with lush at load time (unless
          # `g:bones_compat` is set), so loading one fails without it
          zenbones-nvim
          lush-nvim
          (fromGitHub "6c641ea0cfc5fbbc0777996320b2304c3811f246" "RostislavArts/naysayer.nvim")

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
