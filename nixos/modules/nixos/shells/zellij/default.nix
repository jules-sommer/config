{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt enabled;

  cfg = config.xeta.shells.zellij;
in {
  options.xeta = {
    shells.zellij = {
      enable = mkEnableOption "Enable Zellij";
      theme = mkOpt types.str "catppuccin-mocha"
        "The theme to use for the starship prompt";
    };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = cfg.theme;
        keybinds = {

        };

        layout = {
          panes = [
            {
              # First top-level vertical split pane
              split_direction = "vertical";
              children = [
                {
                  # Simple pane without further splits
                }
                {
                  # Second pane with a horizontal split
                  split_direction = "horizontal";
                  children = [
                    {
                      # First child pane of the horizontal split
                    }
                    {
                      # Second child pane of the horizontal split
                    }
                  ];
                }
              ];
            }
            {
              # Second top-level pane for the plugin
              size = 1;
              borderless = true;
              plugin = { location = "zellij:compact-bar"; };
            }
          ];
        };

      };
    };
  };
}
