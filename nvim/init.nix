{
  pkgsUnstable,
  inputs,
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

  wrappers.neovim = { pkgs, ... }: {
    enable = true;
    settings.config_directory = ./.;

    runtimePkgs = with pkgs; [
      rust-analyzer
      lua-language-server
      nixd
      stylua
      pkgs.vscode-extensions.vadimcn.vscode-lldb
      nixfmt
    ];

    specs.lze = {
      lazy = false;
      before = [ "INIT_MAIN" ];
      data = [ pkgs.vimPlugins.lze ];
    };

    specs.general = with pkgs.vimPlugins; [
      which-key-nvim
      oil-nvim
    ];

    specs.all = {
      lazy = false;
      before = [ "INIT_MAIN" ];

      data = with pkgs.vimPlugins; [
        mini-icons
        lze
        snacks-nvim
        FixCursorHold-nvim
        quicker-nvim
        smart-splits-nvim

        blink-cmp
        luasnip
        lualine-nvim

        # colorschemes
        gruvbox-nvim
        catppuccin-nvim
        kanagawa-nvim
        rose-pine

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

        lazydev-nvim

        # LSP
        nvim-lspconfig
        fidget-nvim

        # debuggers
        # TODO: figure out how to get codelldb
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-go

        # testing
        nvim-nio
        neotest
        neotest-rust
        neotest-go
      ];
    };
  };

  home.sessionVariables =
    let
      nvimpath = lib.getExe config.wrappers.neovim.wrapper;
    in
    {
      EDITOR = nvimpath;
      MANPAGER = "${nvimpath} +Man!";
    };
}
