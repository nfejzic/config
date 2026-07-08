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
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};

      configuration = { pkgs, ... }: {
        # prevent nix-darwin from managing nix, so determinate nix can do it instead
        nix.enable = false;

        users.knownUsers = [ "nfejzic" ];
        users.users.nfejzic.uid = 501;
        users.users.nfejzic.home = "/Users/nfejzic";

        environment.systemPackages = with pkgs; [
          vim
        ];

        nix.settings.experimental-features = "nix-command flakes";

        programs.fish.enable = true;
        users.users.nfejzic.shell = pkgs.fish;

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 6;
        nixpkgs.hostPlatform = "aarch64-darwin";

        security.pam.services.sudo_local.touchIdAuth = true;

        # NOTE: make sure that blink has the rust fuzzy library
        nixpkgs.overlays = [
          inputs.blink-lib.overlays.default
          inputs.blink-cmp.overlays.default
        ];
      };
    in
    {
      darwinConfigurations."aeration" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs pkgsUnstable; };
            home-manager.users.nfejzic = import ./home.nix;
          }
        ];
      };
    };
}
