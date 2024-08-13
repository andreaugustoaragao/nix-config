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
  }: let
    userDetails = {
      fullName = "Andre Aragao";
      userName = "aragao";
    };
    desktopDetails = {dpi = 144;};
    homeManagerStateVersion = "24.05";

    rootUserHomeManagerConfig = {
      home.username = "root";
      home.homeDirectory = "/root";
      home.stateVersion = homeManagerStateVersion;
      programs.home-manager.enable = true;
      imports = [./home/nvim.nix ./home/shell.nix];
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
        then [./home/nvim.nix ./home/shell.nix ./home/alacritty.nix]
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
          ./machines/workstation
          ./system/nixos
          nix-index-database.nixosModules.nix-index
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
/*
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
      homeManagerStateVersion = "23.11";
      rootUserHomeManagerConfig = {
        home.username = "root";
        home.homeDirectory = "/root";
        home.stateVersion = homeManagerStateVersion;
        programs.home-manager.enable = true;
        imports = [./home/nvim.nix ./home/shell.nix];
      };
      commonUserHomeManagerConfig = {
        userDetails,
        system,
      }: let
        homeDirectory =
          if builtins.match ".*darwin.*" system != null
          then "/Users/${userDetails.userName}"
          else "/home/${userDetails.userName}";
      in {
        home = {
          username = userDetails.userName;
          homeDirectory = homeDirectory;
          stateVersion = homeManagerStateVersion;
        };
        imports = [./home];
        programs.home-manager.enable = true;
      };
    in {
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
              users.${userDetails.userName} = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
              };
              users.root = rootUserHomeManagerConfig;
            };
          }
          ./machines/workstation
          ./system/nixos
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
              users.${userDetails.userName} = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
              };

              users.root = rootUserHomeManagerConfig;
            };
          }
          ./machines/utm-dev
          ./system/nixos
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
              users.aragao = commonUserHomeManagerConfig {
                userDetails = userDetails;
                system = system;
                extraImports = [./home/alacritty.nix]; # Extra imports specific to Darwin
              };
            };
          }
        ];
      };
    };
  };
}
*/

