{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.jules) mkOpt enabled;

  cfg = config.jules.apps.torrents;
in {
  options.jules = {
    apps.torrents = {
      enable = mkEnableOption
        "Whether or not to enable torrenting utils in home-manager.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent
      torrential
      torrent7z
      transmission
      torrenttools
      deluge
    ];
  };
}

# { pkgs, lib, inputs, config, ... }:
# with lib;
# with lib.jules;
# let cfg = config.jules.packages;
# in {
#   options = {
#     jules = {
#       apps = {
#         torrents = mkOpt {
#           type = types.bool;
#           description =
#             "Whether or not to enable torrenting utils in home-manager.";
#         };
#       };
#     };

#   config = { jules = { torrents = cfg.torrents or false; }; };

#   home = if cfg.torrents then {
#     packages = with pkgs; [
#       qbittorrent
#       torrential
#       torrent7z
#       transmission
#       torrenttools
#       deluge
#     ];
#   } else {
#     packages = [ ];
#   };
# }
