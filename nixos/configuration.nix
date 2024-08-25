# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  settings,
  hostnames,
  ... }: { # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    
    ../modules/nixos/virt-manager
    ../modules/nixos/steam
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      #allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.efiSupport = true;
    grub.device = "nodev";
  };
  # Without this makemkv does not work
  boot.kernelModules = [ "sg" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = settings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = settings.localeextra;
    LC_IDENTIFICATION = settings.localeextra;
    LC_MEASUREMENT = settings.localeextra;
    LC_MONETARY = settings.localeextra;
    LC_NAME = settings.localeextra;
    LC_NUMERIC = settings.localeextra;
    LC_PAPER = settings.localeextra;
    LC_TELEPHONE = settings.localeextra;
    LC_TIME = settings.localeextra;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = settings.keyboard;
  # Configure console keymap
  console.keyMap = settings.keyboard;

  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  networking.hostName = hostnames.desktop;

  users.users = {
    ${settings.username} = {
      isNormalUser = true;
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [];
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "cdrom"
        "disk"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    tree
    dust
    btop
    htop
    wget
    tlrc
    neofetch
    fastfetch
    zip
    mpv
    libqalculate
    fzf
    cmatrix
    feh
    lolcat
    cowsay
    trash-cli
    busybox
    python3
  ];

  modules = {
    virt-manager.enable = true;
    steam.enable = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
