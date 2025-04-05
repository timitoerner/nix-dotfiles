{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.alacritty;

in {
  options.modules.alacritty.enable = mkEnableOption "alacritty";
  config = mkIf cfg.enable {
    programs.alacritty.enable = true;
    xdg.configFile."alacritty/alacritty.toml".enable = false;

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      #(pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

  };
}
