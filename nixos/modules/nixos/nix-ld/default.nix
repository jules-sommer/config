{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types  mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;

  cfg = config.jules.nix-ld or [];
in {
  options.jules.nix-ld = with types; {
    enable = mkEnableOption
      "Enable nix-ld for running binaries that require dynamic linking at runtime.";
    runtimeLibs = mkOpt (listOf package) [] "List of runtime libraries to include in the nix-ld environment. This list is merged with the default list of runtime libraries.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs;
      # IMPORTANT: this list is merged with the user's list of runtimeLibs passed in as cfg.runtimeLibs
        cfg.runtimeLibs ++ [
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

