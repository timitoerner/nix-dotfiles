{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @inputs: 
  let
    settings = {
        username = "tim";
        email = "public.email.basis107@aleeas.com";
        dotfilesDir = "~/nix-dotfiles";
        wm = "hyprland";
        browser = "ungoogled-chromium";
        terminal = "alacritty";
        editor = "nvim";
        timezone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        localeextra = "de_DE.UTF-8";
        keyboard = "de";
    };

    hostnames = {
      desktop = "nixos-desktop";
    };
    
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      ${hostnames.desktop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          inherit settings;
          inherit hostnames;
        };
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "${settings.username}@${hostnames.desktop}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit settings;
          inherit hostnames;
        };
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
