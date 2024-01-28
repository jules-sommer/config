# My Custom NixOS Configuration

This repository contains my custom NixOS configuration files. This is mostly for my own version control purposes but I figured I would make it public since this is the product of many days of research and effort coming from zero NixOS knowledge, some key features of the config are below:

## Key Features

- **NuShell by default**: The default shell is set to [NuShell](https://www.nushell.sh/), which is unsurprisingly written in Rust and is very modern and pretty and fun and POSIX non-compliant ( yah girl lives on the edge ).
- **Rust Development**: The environment is set up for Rust development, with tools like `rustup` and `cargo` pre-installed.
- **Qt and GTK Themes**: The Qt and GTK themes are configured to my *exact* liking, it runs Wayland and has the beginnings of my switch to Hyprland for tiling window'd goodness - but I am not there yet, had some trouble originally so I stuck back with GNOME/GDM Wayland ( PRs welcome hehe ).
- **Home Manager**: User-specific configurations and packages are managed by the Home Manager, making it easy to version control and replicate your user environment, or I guess more accurately *my user environment* across multiple machines :)

It is structured as follows:

- [`flake.nix`](command:_github.copilot.openRelativePath?%5B%22flake.nix%22%5D "flake.nix"): This is the main entry point for the project. It defines the project's dependencies, inputs, and outputs.
- [`home-manager/home.nix`](command:_github.copilot.openRelativePath?%5B%22home-manager%2Fhome.nix%22%5D "home-manager/home.nix"): This file contains the configuration for the Home Manager, which manages user-specific configurations and packages - basically anything in your home directory onwards.
- [`home-manager/qt-gtk.nix`](command:_github.copilot.openRelativePath?%5B%22home-manager%2Fqt-gtk.nix%22%5D "home-manager/qt-gtk.nix"): This file contains the configuration for the Qt and GTK themes, separated because it gets messy.
- [`system/configuration.nix`](command:_github.copilot.openRelativePath?%5B%22system%2Fconfiguration.nix%22%5D "system/configuration.nix"): This file contains the system-wide configuration for NixOS.

## Getting Started

To use this configuration, clone the repository and `cd` into the directory, you can then use these two commands in this order to build the system and then home-manager, respectively.

Where `.#ishot` refers to `.#{hostname}` if you made changes, otherwise your system is `jules@ishot (user@hostname)` hehe <3

Also `switch` can be swapped for `build` or `test` which unlike `switch` will not change your default boot profile and `test` is probably best if you're unsure about using my config as a reboot will put everything back to normal - more details can be found in the nixos manual for how these commands work.

##### Pre-build setup for hardware config

DO NOT forget to run the command `nixos-generate-config --dir ./` while in the `./system` directory of this repo to overwrite my hardware config with the automatically detected settings for your hardware before building or switching to this config!!!

#### System build command

```bash
sudo nixos-rebuild switch --flake .#ishot
```

#### Home-manager build command

```bash
home-manager switch --flake .#jules@ishot
```

optionally include the following args to backup your `.config` dir in /home/user

```bash
-b /home/.config_backup
```

Then, run `nixos-rebuild switch` to apply the configuration.

Please note that you may need to adjust some settings to fit your specific hardware and preferences.

## Contributing

If for whatever reason you derive some value from contributing to my configuration, I am not going to protest - feel free to open issues if you actually use this config, and feel free to use it as a basis for your own NixOS system.

## License

This project is licensed under the MIT License. See the LICENSE file for details, *oh there isn't one? shit I am shocked...* ( do whatever you please with this lol, I am surprised if it helps anyone - if you somehow make money off it do share how pls )
