{ pkgs, lib, config, settings, ... }:

let
  browser = settings.browser;
in {
  config = if (builtins.elem "${browser}" ["brave" "chromium" "ungoogled-chromium"]) then ({
      programs.${browser}= {
        enable = true;
        package = pkgs.${browser};
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
          { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
        ];
      };
    })
    else if (builtins.elem "${browser}" ["librewolf" "firefox"]) then ({
      programs.${browser}= {
        enable = true;
        policies = {
          ExtensionSettings = {
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/78272b6fa58f4a1abaac99321d503a20@proton.me/latest.xpi";
            };
            "addon@darkreader.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi";
            };
          };
          DisableFirefoxScreenshots = true;
          DisplayBookmarksToolbar = "never";
          NoDefaultBookmarks = true;
          PasswordManagerEnabled = false;
          SearchSuggestEnabled = true;
          StartDownloadsInTempDirectory = true;

          Preferences = {
            "browser.profiles.enabled" = true;
            "browser.search.separatePrivateDefault" = false;
            "browser.search.suggest.enabled" = true;
            "browser.uiCustomization.state" = (builtins.readFile ./browserui.json);
            "browser.urlbar.placeholderName" = lib.mkDefault "DuckDuckGo";
            "browser.urlbar.shortcuts.bookmarks" = false;
            "browser.urlbar.shortcuts.history" = false;
            "browser.urlbar.shortcuts.tabs" = false;
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.searches" = true;
            "browser.urlbar.suggest.topsites" = false;
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "intl.accept_languages" = "en-us,en,de-de";
            "intl.locale.requested" = "en-US,de";
          };
        };
        profiles = {
          "user" = {
            id = 0;
            isDefault = true;
            search.default = "ddg";
            search.force = true;

            search.engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://mynixos.com";
                  params = [
                  { name = "search"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@n" ];
              };
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
