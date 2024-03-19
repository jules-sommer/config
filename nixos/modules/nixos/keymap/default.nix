{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }: {
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
