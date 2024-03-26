{ pkgs, config, lib, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.nvidia;
  blacklistedKernelModules = if (cfg.enable && cfg.driver == "nouveau") then
    [ "nvidia" ]
  else
    [ "nouveau" ];
in {
  options.xeta.system.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia GPU support";
    driver = mkOpt (types.enum [ "nvidia" "nouveau" ]) "nouveau"
      "Nvidia driver to use if Nvidia GPU support is enabled";
  };
  config = {
    services.xserver.videoDrivers = [ "nouveau" ]; # "nvidia" or "nouveau"
    boot.blacklistedKernelModules = blacklistedKernelModules;

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
