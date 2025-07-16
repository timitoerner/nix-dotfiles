{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
  options.modules.hyprland.enable = mkEnableOption "hyprland";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    #wayland.windowManager.hyprland.xwayland.enable = true;
    wayland.windowManager.hyprland.extraConfig = "# less warnings from home-manager";
    xdg.configFile."hypr/hyprland.conf".enable = false;

    home.packages = with pkgs; [
      hyprland
      hyprcursor
      rofi-wayland 
      swww 
      waybar
      alacritty
      wl-clipboard
      
      nerd-fonts.jetbrains-mono
    ];

    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
    home.file.".config/waybar/config".source = ./waybar/config;
    home.file.".config/waybar/style.css".source = ./waybar/style.css;


    home.pointerCursor = {
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    qt = {
      enable = true;
      style.name = "adwaita-dark";
    };

    gtk = {
      enable = true;
      theme.name = "adw-gtk3";
      theme.package = pkgs.adw-gtk3;
      cursorTheme.name = "Bibata-Modern-Classic";
      cursorTheme.package = pkgs.bibata-cursors;
    };
  };
}
