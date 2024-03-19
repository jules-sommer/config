{ pkgs, lib, inputs, config, ... }:
with lib;
with lib.jules;
let cfg = config.jules.packages;
in {
  home.packages = with pkgs; [
    # Web Browsers and Internet Tools
    firefox
    qutebrowser
    floorp
    chromedriver
    chromium
    httpie
    curlie
    tor-browser
    torsocks
    tor
    runelite
    # Media and Entertainment
    vlc
    lmms
    steam
    obs-do
    obs-cli
    youtube-tui

    # Productivity and Development Tools
    oh-my-posh
    pueue
    swayimg
    udisks
    udiskie
    woeusb
    ventoy-full
    unetbootin
    vmware-workstation
    appimage-run
    appimagekit
    localsend
    helvum
    gitui
    grim
    protonvpn-gui
    protonvpn-cli
    slurp
    sox
    jetbrains-mono
    fira-code
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })

    # Development Tools
    jetbrains.rust-rover
    jetbrains.pycharm-community
    jetbrains.pycharm-professional
    jetbrains.goland
    jetbrains.clion
    qt5.full
    cargo
    clippy
    rustc
    rustfmt
    rust-analyzer
    github-desktop
    rye
    flyctl

    # Nix and System Tools
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        input-overlay
        waveform
        obs-websocket
      ];
    })

    cachix
    nil
    nix-info
    nixpkgs-fmt
    nixci
    ollama

    # Messaging
    signal-export
    signal-desktop
    signalbackup-tools
    vesktop
    discord-canary

    # Themes and Customization
    adementary-theme
    catppuccin-cursors
    catppuccin
    bibata-cursors
    whitesur-icon-theme
    whitesur-gtk-theme

    # messaging
    signal-export
    signal-desktop
    signalbackup-tools
    vesktop
    discord-canary

    # Window Managers and Desktop Environments
    sway
    apt
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-media-tags-plugin
    xfce.thunar-archive-plugin
    wofi
    waybar
    swww
    swaynotificationcenter
    rofi-wayland
    swaylock
    element-desktop
    yazi
    swayidle
    screenkey
    grim
    slurp
    swaybg
  ];
}
