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
        policies = {
          ExtensionSettings = {
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/78272b6fa58f4a1abaac99321d503a20@proton.me/latest.xpi";
            };
            "addon@darkreader.org" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi";
            };
          };
        };
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
