{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.jules) enabled;

  cfg = config.jules.electron-support;
in {
  options.jules.nix-ld = {
    enable = mkEnableOption
      "Enable nix-ld for running binaries that require dynamic linking at runtime.";
    runtimeLibs = mkOpt (types.list types.pkgs)
      "List of runtime libraries to be included in the nix-ld environment.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs;
      # IMPORTANT: this list is merged with the user's list of runtimeLibs passed in as cfg.runtimeLibs
        cfg.runtimeLibs // [
          gtk3
          gtk4
          cairo
          pango
          gdk-pixbuf
          atk
          glibc
          glib
          zlib
          zstd
          stdenv.cc.cc
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd
        ];
    };
  };
}

