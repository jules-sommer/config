{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;
  cfg = config.jules.virtualisation;
in {
  options.jules.virtualisation = {
    enable = mkOpt types.bool "Enable virtualisation support" false;
    extraPackages =
      mkListOf (types.nullOr types.package) [ ] "Extra packages to install";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;
      [ virtualbox linuxKernel.packages.linux_zen.virtualbox qemu libvirt ]
      ++ cfg.extraPackages;

    virtualisation = {
      docker.enable = true;
      libvirtd.enable = true;
      virtualbox.host.enable = true;
      # virtualbox.guest.enable = true;
      # virtualbox.host.enableExtensionPack = true;
      # spiceUSBRedirection.enable = true;
      vmware.host.enable = true;
      vmware.host.extraConfig = ''
        # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
        mks.gl.allowUnsupportedDrivers = "TRUE"
        mks.vk.allowUnsupportedDevices = "TRUE"
      '';
      vmware.host.extraPackages = with pkgs; [ ntfs3g ];
      vmware.guest.enable = true;
    };
  };
}
