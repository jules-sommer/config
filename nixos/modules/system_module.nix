{ inputs, lib, pkgs, homeDir, ... }: {
  environment = { systemPackages = with pkgs; [ snowfallorg.thaw ]; };
}
