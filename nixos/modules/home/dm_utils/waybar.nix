{ pkgs, config, lib, inputs, ... }:
let colorScheme = lib.jules.get_theme;
in with lib.jules; {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";

      modules-left = [ "hyprland/window" "custom/startmenu" ];
      modules-center = [
        "network"
        "custom/themeselector"
        "pulseaudio"
        "cpu"
        "hyprland/workspaces"
        "memory"
        "disk"
        "clock"
      ];
      modules-right =
        [ "idle_inhibitor" "custom/notification" "battery" "tray" "privacy" ];
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      "clock" = {
        format = "{: %I:%M %p}";
        tooltip = false;
      };
      "hyprland/window" = {
        max-length = 25;
        separate-outputs = false;
      };
      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
      };
      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
        tooltip = true;
      };
      "disk" = {
        format = "  {free} / {total}";
        tooltip = true;
        on-click = "hyprctl dispatch 'exec alacritty -e broot -hipsw'";
      };
      "network" = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-ethernet = ": {bandwidthDownOctets}";
        format-wifi = "{icon} {signalStrength}%";
        format-disconnected = "󰤮";
        tooltip = false;
        on-click = "nm-applet";
      };
      "tray" = { spacing = 12; };
      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
      "custom/themeselector" = {
        tooltip = false;
        format = "";
        # exec = "theme-selector";
        on-click = "theme-selector";
      };
      "custom/startmenu" = {
        tooltip = false;
        format = "";
        # exec = "rofi -show drun";
        on-click = "rofi -show drun";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = "true";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon} {}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t";
        escape = true;
      };
      "privacy" = {
        icon-spacing = 4;
        icon-size = 18;
        transition-duration = 250;
        modules = [
          {
            "type" = "screenshare";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
          {
            "type" = "audio-out";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
          {
            "type" = "audio-in";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
        ];
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        on-click = "";
        tooltip = false;
      };
    }];
    style = ''
      * {
        font-size: 15px;
        font-family: 'JetBrains Mono', Font Awesome, monospace;
            font-weight: 600;
      }
      window#waybar {
            margin: 5px;
            padding: 5px;
            border-radius: 15px;
            border: 2px solid #${color "base0F"};
            border-bottom: 1px solid rgba(26,27,38,0);
            background-color: rgba(26,27,38,0.64);
            color: #${color "base0F"};
      }
      #workspaces {
            background: linear-gradient(180deg, #${color "base00"}, #${
              color "base01"
            });
            margin: 5px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-style: normal;
            color: #${color "base00"};
      }
      #workspaces button {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: #${color "base00"};
            background-color: #${color "base00"};
            opacity: 1.0;
            transition: all 0.3s ease-in-out;
      }
      #workspaces button.active {
            color: #${color "base00"};
            background: #${color "base04"};
            border-radius: 15px;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
            opacity: 1.0;
      }
      #workspaces button:hover {
            color: #${color "base02"};
            background: #${color "base04"};
            border-radius: 15px;
            opacity: 1.0;
      }
      tooltip {
          background: #${color "base00"};
          border: 1px solid #${color "base04"};
          border-radius: 10px;
      }
      tooltip label {
          color: #${color "base07"};
      }
      #window {
            color: #${color "base05"};
            background: #${color "base00"};
            border-radius: 0px 15px 50px 0px;
            margin: 5px 5px 5px 0px;
            padding: 2px 20px;
      }
      #memory {
            color: #${color "base0F"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #clock {
            color: #${color "base0B"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #idle_inhibitor {
            color: #${color "base0A"};
            background: #${color "base00"};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #cpu {
            color: #${color "base07"};
            background: #${color "base00"};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #disk {
            color: #${color "base03"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #battery {
            color: #${color "base08"};
            background: #${color "base00"};
            border-radius: 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #network {
            color: #${color "base09"};
            background: #${color "base00"};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #tray {
            color: #${color "base05"};
            background: #${color "base00"};
            border-radius: 15px 0px 0px 50px;
            margin: 5px 0px 5px 5px;
            padding: 2px 20px;
      }
      #pulseaudio {
            color: #${color "base0D"};
            background: #${color "base00"};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #custom-notification {
            color: #${color "base0C"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
        #custom-themeselector {
            color: #${color "base0D"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
        }
      #custom-startmenu {
            color: #${color "base03"};
            background: #${color "base00"};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #idle_inhibitor {
            color: #${color "base09"};
            background: #${color "base00"};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
    '';
  };
}
