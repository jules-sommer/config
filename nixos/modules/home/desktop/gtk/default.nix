{ pkgs, inputs, config, ... }: {
  options.xeta.home.gtk = {
    # nothing to configure yet
  };
  config = {
    # Configure Cursor Theme
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Theme GTK
    gtk = {
      enable = true;
      font = {
        name = "Ubuntu";
        size = 12;
        package = pkgs.ubuntu_font_family;
      };
      theme = pkgs.lib.mkDefault {
        name = "WhiteSur-Dark-solid";
        package = pkgs.whitesur-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.lib.mkDefault pkgs.bibata-cursors;
      };
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };

    # Theme QT -> GTK
    qt = {
      enable = true;
      platformTheme = "qtct";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
