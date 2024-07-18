{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
  options.modules.hyprland = { enable = mkEnableOption "hyprland"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland
      rofi-wayland 
      swww 
      waybar
      alacritty
      
      jetbrains-mono
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  };
}
