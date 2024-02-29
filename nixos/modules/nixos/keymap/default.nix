{
# Snowfall Lib provides a customized `lib` instance with access to your flake's library
# as well as the libraries available from your flake's inputs.
lib,
# An instance of `pkgs` with your overlays and packages applied is also available.
pkgs,
# You also have access to your flake's inputs.
inputs,

# Additional metadata is provided by Snowfall Lib.
system, # The system architecture for this host (eg. `x86_64-linux`).
target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
format, # A normalized name for the system target (eg. `iso`).
virtual
, # A boolean to determine whether this system is a virtual target using nixos-generators.
systems, # An attribute map of your defined hosts.

# All other arguments come from the module system.
config, ... }: {
  services.xremap.withWlroots = true;
  services.xremap.config = {
    # Modmap for single key rebinds
    modmap = [{
      name = "Global";
      remap = {
        "CapsLock" = {
          held = "KEY_LEFTALT";
          alone = "CapsLock";
          alone_timeout_millis = 150;
        };
      };
    }];

    # Keymap for key combo rebinds
    keymap = [
      {
        name = "Example ctrl-u > pageup rebind";
        remap = { "C-Esc" = "PAGEUP"; };
      }
      {
        # Rebind shift+escape to tilda
        name = "Shift+Esc > Tilda";
        remap = { "SHIFT_L-Esc" = "KEY_GRAVE"; };
      }
      {
        # Rebind shift+escape to tilda
        name = "Shift+Esc > Tilda";
        remap = { "C_L-SHIFT_L-Esc" = "C-SHIFT-KEY_GRAVE"; };
      }
    ];
  };
}
