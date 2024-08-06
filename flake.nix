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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nix-index-database,
    ...
  }: {
    nixosConfigurations = let
      userDetails = {
        fullName = "Andre Aragao";
        userName = "aragao";
      };
      desktopDetails = {dpi = 144;};
    in {
      #TODO: AVOID THE REPETITION
      workstation = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs;
          inherit system;
          inherit userDetails;
          inherit desktopDetails;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.${userDetails.userName} = {
                home = {
                  username = "${userDetails.userName}";
                  homeDirectory = "/home/${userDetails.userName}";
                  # do not change this value
                  stateVersion = "23.11";
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
              };
              # make root great again
              users.root = {pkgs, ...}: {
                home.username = "root";
                home.homeDirectory = "/root";
                home.stateVersion = "23.11"; # 23.11
                programs.home-manager.enable = true;
                imports = [./home/nvim.nix ./home/shell.nix];
              };
            };
          }
          ./machines/workstation
          ./system/nixos
          ./home
          nix-index-database.nixosModules.nix-index # https://github.com/nix-community/nix-index-database
        ];
      };

      prl-dev = nixpkgs.lib.nixosSystem rec {
        system = "aarch_64-linux";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs;
          inherit system;
          inherit userDetails;
          inherit desktopDetails;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.${userDetails.userName} = {
                home = {
                  username = "${userDetails.userName}";
                  homeDirectory = "/home/${userDetails.userName}";
                  # do not change this value
                  stateVersion = "23.11"; #23.11
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
              };
              # make root great again
              users.root = {pkgs, ...}: {
                home.username = "root";
                home.homeDirectory = "/root";
                home.stateVersion = "23.11"; # 23.11
                programs.home-manager.enable = true;
                imports = [./home/nvim.nix ./home/shell.nix];
              };
            };
          }
          ./machines/prl-dev
          ./system/nixos
          ./home
          nix-index-database.nixosModules.nix-index # https://github.com/nix-community/nix-index-database
        ];
      };

      utm-dev = nixpkgs.lib.nixosSystem rec {
        system = "aarch_64-linux";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs;
          inherit system;
          inherit userDetails;
          inherit desktopDetails;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              #enableNixpkgsReleaseCheck = false;
              users.${userDetails.userName} = {
                home = {
                  username = "${userDetails.userName}";
                  homeDirectory = "/home/${userDetails.userName}";
                  # do not change this value
                  stateVersion = "23.11";
                  enableNixpkgsReleaseCheck = false;
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
              };
              # make root great again
              users.root = {pkgs, ...}: {
                home.username = "root";
                home.homeDirectory = "/root";
                home.stateVersion = "23.11";
                programs.home-manager.enable = true;
                imports = [./home/nvim.nix ./home/shell.nix];
              };
            };
          }
          ./machines/utm-dev
          ./system/nixos
          ./home
          nix-index-database.nixosModules.nix-index # https://github.com/nix-community/nix-index-database
        ];
      };
    };

    darwinConfigurations = {
      A2130862 = darwin.lib.darwinSystem {
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
                  username = "aragao";
                  homeDirectory = "/Users/aragao";
                  # do not change this value
                  stateVersion = "23.11";
                };
                imports = [./home/nvim.nix ./home/shell.nix ./home/alacritty.nix];
                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
              };
            };
          }
        ];
      };
    };
  };
}
