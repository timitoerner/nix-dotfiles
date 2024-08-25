{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.steam;

in {
  options.modules.steam.enable = mkEnableOption "steam";
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

    programs.steam.enable = true;
  };
}
