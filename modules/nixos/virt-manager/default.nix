{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.virt-manager;

in {
  options.modules.virt-manager = { enable = mkEnableOption "virt-manager"; };
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
