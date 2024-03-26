{ pkgs, lib, ... }: {
  config = {
    # Enable sound with pipewire.
    sound.enable = false;
    hardware.pulseaudio.enable = false;
    # rtkit is optional but recommended
    security.rtkit.enable = true;
  };
}
