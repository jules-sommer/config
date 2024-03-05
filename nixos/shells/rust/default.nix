{ lib, inputs, pkgs, stdenv, ... }:
stdenv.mkDerivation {
  inherit pkgs lib inputs;

  rustToolchain =
    pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

  nativeBuildInputs = with pkgs; [ rustToolchain pkg-config ];

  buildInputs = with inputs.pkgs; [
    curl
    wget
    dbus
    openssl_3
    glib
    gtk3
    libsoup
    webkitgtk
    librsvg
  ];

  libraries = with pkgs; [
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl_3
    librsvg
  ];

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  OPENSSL_ROOT_DIR = "${pkgs.openssl}";

  shellHook = ''
    export LD_LIBRARY_PATH=${
      pkgs.lib.makeLibraryPath libraries
    }:$LD_LIBRARY_PATH
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
  '';
}
