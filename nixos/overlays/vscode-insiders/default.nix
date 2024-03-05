# Snowfall Lib provides access to your current Nix channels and inputs.
#
# Channels are named after NixPkgs instances in your flake inputs. For example,
# with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
# These channels are system-specific instances of NixPkgs that can be used to quickly
# pull packages into your overlay.
#
# All other arguments for this function are your flake inputs.
{ channels, ... }:

(final: prev: {
  # Override for using Vscode Insiders edition, basically nightly/unstable release instead
  vscode-with-extensions =
    (prev.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "0z3gir3zkswcyxg9l12j5ldhdyb0gvhssvwgal286af63pwj9c66";
      });
      version = "latest";
    });
})