{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
  options.modules.hyprland.enable = mkEnableOption "hyprland";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.xwayland.enable = true;
    wayland.windowManager.hyprland.extraConfig = "# less warnings from home-manager";
    xdg.configFile."hypr/hyprland.conf".enable = false;

    home.packages = with pkgs; [
      hyprland
      rofi-wayland 
      swww 
      waybar
      alacritty
      wl-clipboard
      
      jetbrains-mono
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
    home.file.".config/waybar/config".source = ./waybar/config;
    home.file.".config/waybar/style.css".source = ./waybar/style.css;
  };
}
