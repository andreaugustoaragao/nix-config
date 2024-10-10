{
  description = "Nixos setup for development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurpkgs.url = "github:nix-community/NUR";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nix-index-database,
    nixvim,
    ...
  }: let
    userDetails = {
      fullName = "Andre Aragao";
      userName = "aragao";
    };
    desktopDetails = {dpi = 96;};
    homeManagerStateVersion = "24.05";
  in {
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit userDetails;
        };
        modules = [
          ./machines/workstation
          ./system/nixos/default.nix
          {
            machine = {
              role = "pc";
              x11 = {
                enable = true;
                dpi = 144;
              };
              wayland = {
                enable = true;
                scale = 1.0;
              };
            };
          }
          home-manager.nixosModules.home-manager
          ./home
          nix-index-database.nixosModules.nix-index
        ];
      };

      hp-mgmt = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit userDetails;
        };
        modules = [
          ./machines/hp-mgmt
          ./system/nixos/default.nix
          {
            machine.role = "pc";
            machine.x11.enable = true;
            machine.x11.dpi = 96;
            machine.wayland.enable = true;
          }
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          ./home
        ];
      };

      maui = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./machines/maui
        ];
      };

      utm-dev = nixpkgs.lib.nixosSystem rec {
        system = "aarch_64-linux"; # Corrected architecture
        specialArgs = {
          inherit inputs;
          inherit userDetails;
          inherit desktopDetails;
        };
        modules = [
          ./machines/utm-dev
          ./system/nixos/default.nix
          {
            machine.role = "pc";
            machine.x11.enable = true;
            machine.x11.dpi = 96;
            machine.wayland.enable = true;
          }
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          ./home
        ];
      };
    };

    darwinConfigurations = {
      A2130862 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs;
        };
        modules = [
          ./system/macos
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.aragao = {
                home = {
                  username = userDetails.userName;
                  homeDirectory = "/Users/${userDetails.userName}";
                  stateVersion = homeManagerStateVersion;
                };
                programs.home-manager.enable = true;
                imports = [
                  ./home/macos/neovim.nix
                  ./home/alacritty.nix
                  ./home/shell.nix
                ];
              };
            };
          }
        ];
      };
    };
  };
}
