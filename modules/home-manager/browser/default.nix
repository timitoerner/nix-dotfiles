{ pkgs, lib, config, settings, ... }:

let
  browser = settings.browser;
in {
  config = if (builtins.elem "${browser}" ["brave" "chromium" "ungoogled-chromium"]) then ({
      programs.chromium = {
        enable = true;
        package = pkgs.${browser};
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
          { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
        ];
      };
    
      home.packages = [ pkgs.${browser} ];
    })
    else if (builtins.elem "${browser}" ["librewolf" "firefox"]) then ({
      programs.firefox = {
        enable = true;
        package = pkgs.${browser};
        #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #  decentraleyes
        #  ublock-origin
        #  clearurls
        #  sponsorblock
        #  darkreader
        #  h264ify
        #  df-youtube
        #];
        #extensions = [
        #  { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        #  { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
        #  { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
        #];
      };
    
      #home.packages = [ pkgs.${browser} ];
    })
    else {};
}
