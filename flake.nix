{
  description = "My NixOS configuration";

  inputs = {
    ########################################
    # pkgs
    ########################################
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # current release
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-static.url = "github:NixOS/nixpkgs/e07580dae39738e46609eaab8b154de2488133ce"; # some packages take too long to copy from cache; I want to update them sparingly

    ########################################
    # hosts
    ########################################
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################################
    # home
    ########################################
    home-pkgs.follows = "nixpkgs"; # alias for all home-related inputs

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; # stable channel
      # url = "github:nix-community/home-manager"; # unstable channel
      inputs.nixpkgs.follows = "home-pkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "home-pkgs";
      inputs.home-manager.follows = "home-manager";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "home-pkgs";
    };
    scientific-fhs = { # for fhs-wrapped julia
      url = "github:olynch/scientific-fhs";
      inputs.nixpkgs.follows = "home-pkgs";
    };

    ########################################
    # shells
    ########################################
    myShells = { # this allows me to follow nixpkgs in all my shells
      url = "path:./shells";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-static, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";

    setupExtraPkgs = extraPkgs : import extraPkgs {
      inherit system;
      config.allowUnfree = true;
    };

    stable = setupExtraPkgs nixpkgs;
    unstable = setupExtraPkgs nixpkgs-unstable;
    static = setupExtraPkgs nixpkgs-static;
  in {
    ########################################
    # hosts
    ########################################
    nixosConfigurations = {
      bjork = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable static; };
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          ./hosts/bjork
        ];
      };

      myIso = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/myIso
        ];
      };
    };

    ########################################
    # home
    ########################################
    homeConfigurations = {
      "david@bjork" = home-manager.lib.homeManagerConfiguration {
        pkgs = stable;
        # pkgs = unstable;
        extraSpecialArgs = { inherit inputs static; };
        modules = [ ./home/david ];
      };
    };

    ########################################
    # shells
    ########################################
    inherit (inputs.myShells) devShells;
  };
}
