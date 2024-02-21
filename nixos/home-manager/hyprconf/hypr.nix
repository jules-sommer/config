{ pkgs, config, lib, inputs, ... }:

let
  theme = config.colorScheme.colors;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};

in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "ALT";
      "$terminal" = "alacritty";
      "$file_manager" = "alacritty -e yazi";
      "$menu" = "wofi --show drun";
      "$notifycmd" =
        "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low";
      monitor = [ "WL-1,2560x1080@80,0x0,1" ",preferred,auto,1" ];
      env = [
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland"
        "CLUTTER_BACKEND, wayland"
        "SDL_VIDEODRIVER, wayland"
        "XCURSOR_SIZE, 24"
        "XCURSOR_THEME, Bibata-Modern-Ice"
        "QT_QPA_PLATFORM, wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "MOZ_ENABLE_WAYLAND, 1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

      windowrulev2 = [
        "float,class:^(kitty)$,title:^(kitty)$"
        "nomaximizerequest, class:.*"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit fullscreen, class:^(firefox)$"
      ];
      windowrule = [
        "float, ^(steam)$"
        "center, ^(steam)$"
        "size 1200 900, ^(steam)$"
        "float,^(alacritty)$"
        "move 0 0,title:^(Firefox)(.*)$"
      ];

      # ▄▀█ █░█ ▀█▀ █▀█    █▀▀ ▀▄▀ █▀▀ █▀▀
      # █▀█ █▄█ ░█░ █▄█    ██▄ █░█ ██▄ █▄▄

      exec-once = [
        "hyprpaper"
        "$POLKIT_BIN"
        # "dbus-update-activation-environment --systemd --all"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swww init"
        "waybar"
        "swaync"
        "swayidle -w timeout 720 'swaylock -f' timeout 800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'"
      ];
      # ╔═══════════════════════════════════╗
      # ║ █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀ ║
      # ║ ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█ ║
      # ╚═══════════════════════════════════╝

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
      bind = [
        "$mod, F, exec, firefox"
        "$mod, C, killactive, "
        "$mod, M, exit, "
        "$mod, W, exec, $menu"
        "$mod, D, exec,swaync-client -rs"
        # Terminal and Alacritty for $mod + {T, A}
        "$mod, T, exec, $terminal"
        "$mod, A, exec, $terminal"
        # File manager $mod + {F}
        "$mod, E, exec, $file_manager"
        "$mod, V, togglefloating, "
        "$mod, R, exec, rofi -show drun"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, S, movetoworkspace, special"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod SHIFT, mouse_up, workspace, e+1"
        "$mod SHIFT, mouse_down, workspace, e-1"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5"
        # clipboard manager with wofi
        "$mod SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 10));

      # ╔════════════════════════════════════════╗
      # ║ ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█ █▀ ║
      # ║ █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█ ▄█ ║
      # ║                                        ║ 
      # ║ ▄▀█ █▄░█ █▀▄    █▀▄ █▀▀ █▀▀ █▀█ █▀█ █▀ ║
      # ║ █▀█ █░▀█ █▄▀    █▄▀ ██▄ █▄▄ █▄█ █▀▄ ▄█ ║
      # ╚════════════════════════════════════════╝

      animations = {
        "enabled" = "yes";
        "bezier" = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        "animation" = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      decoration = {
        "rounding" = "15";
        "drop_shadow" = "true";
        "blur" = {
          "enabled" = "true";
          "size" = "5";
          "passes" = "3";
          "new_optimizations" = "on";
          "ignore_opacity" = "on";
        };
      };

      # █▀▄▀█ █ █▀ █▀▀ ░
      # █░▀░█ █ ▄█ █▄▄ ▄

      general = {
        "gaps_in" = 6;
        "gaps_out" = 8;
        "border_size" = 2;
        # Assuming `theme` is defined and accessible here
        "col.active_border" =
          "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg";
        "col.inactive_border" =
          "rgba(${theme.base0C}40) rgba(${theme.base0D}40) rgba(${theme.base0B}40) rgba(${theme.base0E}40) 45deg";
        "layout" = "dwindle";
        "resize_on_border" = "true";
      };

      misc = {
        vrr = 2;
        disable_hyprland_logo = 1;
      };
    };
  };
}
