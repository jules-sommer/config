{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;
  cfg = config.jules.utils.proxychains;
in {
  options.jules.utils.proxychains = {
    enable = mkEnableOption
      "Enable proxychains, you can pass proxies to enable but Tor on localhost:9050 is enabled by default.";
    proxies = mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.str;
            default = "socks5";
            description = "Type of the proxy.";
          };
          host = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Host of the proxy.";
          };
          port = lib.mkOption {
            type = lib.types.int;
            default = 9050;
            description = "Port of the proxy.";
          };
        };
      });
      default = { };
      description = "Proxies to use with proxychains.";
    };
    proxyDNS = mkOption {
      type = lib.types.bool;
      default = false;
      description =
        "Proxy DNS requests, i.e. resolve DNS names through the proxy which prevents DNS leaks.";
    };
  };

  config = mkIf cfg.enable {
    programs.proxychains = {
      enable = true;
      package = pkgs.proxychains;
      proxyDNS = cfg.proxyDNS;
      proxies = {
        tor = {
          type = "socks5";
          host = "127.0.0.1";
          port = 9050;
        };
      } // cfg.proxies;
    };
  };
}
