{ lib, inputs, pkgs, stdenv, system, ... }:
inputs.flake-utils.lib.eachDefaultSystem (system:
  let

    overlays = [ (import inputs.oxalica-rs) ];
    pkgs = import inputs.nixpkgs { inherit system overlays; };

    nativeBuildInputs = with pkgs; [ rust-bin pkg-config ];

    buildInputs = with pkgs; [
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
  in stdenv.mkDerivation {
    inherit pkgs lib inputs buildInputs nativeBuildInputs libraries;
    name = "rust-devshell";

    LD_LIBRARY_PATH = lib.makeLibraryPath ([ # add some stuffs here
    ] ++ buildInputs ++ nativeBuildInputs);
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    OPENSSL_DIR = "${pkgs.openssl.out}";
    OPENSSL_LIB_DIR = lib.makeLibraryPath [ pkgs.openssl ];

    shellHook = ''
      export LD_LIBRARY_PATH=${
        pkgs.lib.makeLibraryPath libraries
      }:$LD_LIBRARY_PATH
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    '';
  })
