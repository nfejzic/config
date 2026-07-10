{
  description = "Nadir's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    blink-cmp.url = "github:saghen/blink.cmp";
    blink-lib.url = "github:saghen/blink.lib";

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";

    fonts.url = "git+https://github.com/nfejzic/fonts";
    fonts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # The reusable home-manager configuration. `home.nix` keeps all the
      # program imports and packages; it's a function of `inputs` so other
      # flakes can `imports = [ dotfiles.homeModules.default ]` and get a
      # self-contained module (blink, fonts, unstable plugins all baked in) —
      # no extraSpecialArgs, no overlays to wire on their end. Per-machine
      # differences (username, colorschemes) are set via the `nfejzic.*`
      # options defined in options.nix.
      homeModules.default = import ./home.nix inputs;

      user = "nfejzic";

      configuration =
        { pkgs, ... }:
        {
          # prevent nix-darwin from managing nix, so determinate nix can do it instead
          nix.enable = false;

          users.knownUsers = [ user ];
          users.users.nfejzic.uid = 501;
          users.users.nfejzic.home = "/Users/${user}";

          environment.systemPackages = with pkgs; [
            vim
          ];

          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.git-credential-helper = "!/run/current-system/sw/bin/gh auth git-credential";

          programs.fish.enable = true;
          users.users.${user}.shell = pkgs.fish;

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Several packages this config uses are unfree (the private fonts,
          # codelldb). The neovim module applies the blink.cmp overlay itself,
          # so there's no need to set nixpkgs.overlays here.
          nixpkgs.config.allowUnfree = true;

          security.pam.services.sudo_local.touchIdAuth = true;
        };
    in
    {
      inherit homeModules;

      darwinConfigurations."aeration" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeModules.default;
          }
        ];
      };
    };
}
