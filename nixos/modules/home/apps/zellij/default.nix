{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.jules) mkOpt enabled;

  cfg = config.jules.apps.zellij;
in {
  options.jules = {
    apps.zellij = {
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
          unbind = "Ctrl g";
          "Ctrl+m" = {
            "LaunchPlugin file:~/.config/zellij/plugins/monocle.wasm" = {
              "in_place" = true;
              "kiosk" = true;
            };
            SwitchToMode = "Normal";
          };
          "Ctrl+y" = {
            "LaunchOrFocusPlugin file:~/.config/zellij/plugins/harpoon.wasm" = {
              "floating" = true;
              "move_to_focused_tab" = true;
            };
          };
        };
      };
    };
  };
}
