{ lib, config, pkgs, ... }:
let
  inherit (lib) mapAttrs types mkEnableOption mkOpt mkIf;
  cfg = config.xeta.home.apps.joshuto;
in {
  options.xeta.home.apps.joshuto = {
    enable = mkEnableOption "Enable Joshuto TUI file manager.";
    isDefaultFileManager =
      mkOpt (types.bool) false "Set Joshuto as the default file manager.";
  };

  config = mkIf cfg.enable {
    programs.joshuto = {
      enable = true;
      settings = {
        class = {
          image_default = [
            {
              command = "qimgv";
              fork = true;
              silent = true;
            }
            {
              command = "krita";
              fork = true;
              silent = true;
            }
          ];
        };

        extension = {
          png = { _inherit = "image_default"; };

          jpg = {
            _inherit = "image_default";
            app_list = [{
              command = "gimp";
              fork = true;
              silent = true;
            }];
          };

          mkv = {
            app_list = [
              {
                command = "mpv";
                args = [ "--" ];
                fork = true;
                silent = true;
              }
              {
                command = "mediainfo";
                confirm_exit = true;
              }
              {
                command = "mpv";
                args = [ "--mute" "on" "--" ];
                fork = true;
                silent = true;
              }
            ];
          };

          rs = {
            app_list = [
              { command = "micro"; }
              {
                command = "gedit";
                fork = true;
                silent = true;
              }
              {
                command = "bat";
                confirm_exit = true;
              }
            ];
          };
        };

        mimetype = {
          text = { _inherit = "text_default"; };
          "application.subtype.octet-stream" = { _inherit = "video_default"; };
        };
      };
    };
  };
}
