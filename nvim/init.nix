{
  pkgs,
  pkgsUnstable,
  inputs,
  config,
  lib,
  ...
}:
let
  fromGitHub =
    {
      repo,
      ref ? null,
      rev ? null,
    }:
    let
      gitArgs = lib.filterAttrs (name: value: value != null) {
        url = "https://github.com/${repo}.git";
        inherit ref;
        inherit rev;
      };
      src = fetchGit gitArgs;
    in
    pkgs.vimUtils.buildVimPlugin {
      inherit src;
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = if rev != null then rev else ref;
    };

in
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

# {
#   programs.neovim = {
#     enable = true;
#     package = pkgs.neovim-unwrapped;
#     defaultEditor = true;
#     viAlias = true;
#     vimAlias = true;
#     plugins = with pkgs.vimPlugins; [
#       { plugin = blink-cmp, config = builtins.readFile ./lua/plugins/blink.lua }
#       { plugin = oil-nvim config = builtins.readFile ./lua/plugins/oil.lua }
#       which-key-nvim
#
#       # (nvim-treesitter.withPlugins (p: [
#       #   p.rust
#       #   p.lua
#       #   p.fish
#       #   p.c
#       #   p.cpp
#       #   p.typescript
#       #   p.javascript
#       #   p.tsx
#       #   # p.jsx
#       #   p.markdown
#       #   p.go
#       #   p.json
#       #
#       #   p.toml
#       #   p.yaml
#       #   p.json
#       #   p.nix
#       #   p.css
#       #   p.scss
#       #   p.html
#       #
#       #   # git
#       #   p.gitcommit
#       #   p.gitignore
#       #   p.gitattributes
#       #   p.git_rebase
#       #   p.git_config
#       #   # neovim query langauges
#       #   p.scheme
#       #   p.query
#       #
#       #   # misc
#       #   p.comment
#       # ]))
#     ];
#
#     initLua = builtins.readFile ./init.lua;
#   };
#
#   xdg.configFile."nvim/lua".source = ./lua;
#   xdg.configFile."nvim/after".source = ./after;
# }
