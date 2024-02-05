{ pkgs, config, gtkThemeFromScheme, ... }:

{
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
      name = "JetBrains Mono";
      size = 12;
      package =
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; });
    };
    theme = pkgs.lib.mkDefault {
      name = "WhiteSur-Dark-solid";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = pkgs.lib.mkDefault {
      name = "WhiteSur-purple";
      package = pkgs.whitesur-icon-theme;
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
    platformTheme = "gtk";
    style = {
      name = "WhiteSur-Dark-solid";
      package = pkgs.whitesur-gtk-theme;
    };
  };
}
