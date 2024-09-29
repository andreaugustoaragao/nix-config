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

    rootUserHomeManagerConfig = {
      home.username = "root";
      home.homeDirectory = "/root";
      home.stateVersion = homeManagerStateVersion;
      programs.home-manager.enable = true;
      imports = [./home/shell.nix];
    };

    commonUserHomeManagerConfig = {
      userDetails,
      system,
    }: {
      home = {
        username = userDetails.userName;
        homeDirectory =
          if builtins.match ".*darwin.*" system != null
          then "/Users/${userDetails.userName}"
          else "/home/${userDetails.userName}";
        stateVersion = homeManagerStateVersion;
      };
      imports =
        if builtins.match ".*darwin.*" system != null
        then [./home/shell.nix ./home/alacritty.nix]
        else [./home];
      programs.home-manager.enable = true;
    };
  in {
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit userDetails;
          desktopDetails = {dpi = 120;};
        };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit desktopDetails;};
              users.${userDetails.userName} = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
              };
              users.root = rootUserHomeManagerConfig;
            };
          }
          ./machines/workstation
          ./system/nixos
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
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userDetails.userName} = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
              };
              users.root = rootUserHomeManagerConfig;
            };
          }
          ./machines/utm-dev
          ./system/nixos
          nix-index-database.nixosModules.nix-index
        ];
      };
    };

    darwinConfigurations = {
      A2130862 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          ./system/macos
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.aragao = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
              };
            };
          }
        ];
      };
    };
  };
}
