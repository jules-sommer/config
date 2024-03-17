{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.jules) mkOpt enabled;

  cfg = config.jules.styles;
in {
  options.jules = {
    styles = {
      enable = mkEnableOption "Enable QT-GTK Styles";
      font = mkOpt types.package "Font" pkgs.ubuntu_font_family;
      cursor = mkOpt types.package "Cursor" pkgs.bibata-cursors;
      qt = { theme = mkOpt types.package "QT Theme" pkgs.adwaita-qt; };
      gtk = {
        theme = mkOpt types.package "Theme" pkgs.orchis-theme;
        iconTheme = mkOpt types.package "Icon Theme" pkgs.papirus-icon-theme;
        cursorTheme = mkOpt types.package "Cursor Theme" pkgs.bibata-cursors;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ ubuntu_font_family papirus-icon-theme bibata-cursors ]
      ++ (cfg.styles.qt.theme or [ ]) ++ (cfg.styles.gtk.theme or [ ])
      ++ (cfg.styles.gtk.iconTheme or [ ])
      ++ (cfg.styles.gtk.cursorTheme or [ ]);
    # Configure Cursor Theme
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = cfg.gtk.cursorTheme;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Theme GTK
    gtk = with cfg; {
      enable = true;
      font = {
        name = "Ubuntu";
        size = 12;
        package = font;
      };
      theme = {
        name = "orchis-theme";
        package = gtk.theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = gtk.iconTheme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = gtk.cursorTheme;
      };
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };

    # Theme QT -> GTK
    qt = {
      enable = true;
      platformTheme = "qtct";
      style = with cfg.qt; {
        name = "adwaita-dark";
        package = theme;
      };
    };
  };
}
