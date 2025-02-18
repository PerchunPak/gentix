{
  description = "Gentoo + NixOS = Gentix";

  inputs = {
    nixpkgs-upstream.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:PerchunPak/nixpkgs/gentix";

    nixpkgs-patch-10 = {
      url = "https://github.com/PerchunPak/nixpkgs/commit/a15d098f96978e46467278d99d86cacc6c4edafa.patch";
      flake = false;
    };
    nixpkgs-patch-20 = {
      url = "https://github.com/PerchunPak/nixpkgs/commit/7db00adaf855f8b004a53db5c446d5fe86a06dc5.patch";
      flake = false;
    };

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nypkgs = {
      url = "github:yunfachi/nypkgs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ylib = inputs.nypkgs.lib.${system};
    in
    {
      nixpkgs = pkgs;
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = import ./pkgs pkgs;
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        perchun-gentix = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs ylib;
          };
          modules = ylib.umport {
            paths = [ ./nixos ];
            recursive = true;
          };
        };

        gentix-iso = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs ylib;
          };

          modules =
            (ylib.umport {
              paths = [ ./nixos ];
              recursive = true;
            })
            ++ [
              (
                { pkgs, modulesPath, ... }:
                {
                  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
                }
              )
            ];
        };
      };
    };
}
