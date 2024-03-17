{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;

  cfg = config.jules.apps.rust-cli-utils or [ ];
in {
  options.jules.apps.rust-cli-utils = with types; {
    enable = mkEnableOption
      "Enable handy Rust CLI utilities system-wide (e.g. ripgrep, fd-find, exa, bat, etc.)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hsd
      navi
      cargo-tauri
      rustscan
      rustdesk
      rustywind
      rusty-man
      rustic-rs
      # rustpython
      rust-script
      rustdesk-server
      rqbit
      lz4
      ra-multiplex
      paperoni
      arti
      xq
      jaq
      thc-hydra
      hydra-cli
      tokio-console
      taschenrechner
      process-viewer
      nbtscanner
      jay
      downonspot
      conceal
      catfs
      cargo-dephell
      yex-lang
      xsv
      trust-dns
      bacon
      udict
      tealdeer
      syncstorage-rs
      procs
      surrealdb-migrations
      surrealdb
      hunt
      cargo-profiler
      cargo-make
      cargo-cranky
      boringtun
      bore-cli
      zee
      youtube-tui
      xidlehook
      vaultwarden
      uutils-coreutils
      todo
      termusic
      skim
      rx
      porsmo
      oculante
      lemmy-server
      espanso-wayland
      dotter
      dino
      clipcat
      cargo-inspect
      bonk
      boa
      speedtest-rs
      powerline-rs
      ox
      lscolors
      cargo-geiger
      cargo-asm
      cargo-audit
      loupe
      kibi
      gitui
      dutree
      cargo-machete
      cargo-deps
      cargo-clone
      cargo-bundle
      toastify
      trunk
      trunk-ng
      oxlint
      kdbg
      gdbgui
      pwndbg
      seer
      xxgdb
      gede
      gf
      gef
      flyctl
      termshark
      wireshark
      junkie
      libs3
      s3fs
      s3cmd
      s3rs
      panamax
      orz
      ifwifi
      lychee
      lightningcss
      findex
      proxychains
      gobuster
      feroxbuster
      dirbuster
    ];
  };
}

