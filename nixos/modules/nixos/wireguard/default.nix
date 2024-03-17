{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;
  cfg = config.jules.systemd.wireguard;
in {
  options.jules.systemd.wireguard = {
    enable = mkEnableOption "Enable Wireguard";
    interfaces = mkOption {
      type = with types;
        listOf (submodule ({
          options = {
            autostart = mkOption {
              type = nullOr types.bool;
              default = true;
              description =
                "Whether to start the VPN interface automatically at boot.";
            };
            name = mkOption {
              type = types.str;
              description =
                "The name of the Wireguard network interface to create.";
            };
            address = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = "The IP address of the interface.";
            };
            port = mkOption {
              type = types.port;
              default = 51820;
              description = "The port number of the interface.";
            };
            privateKey = mkOption {
              type = nullOr types.str;
              default = null;
              description = "The private key for this interface/peer.";
            };
            privateKeyFile = mkOption {
              type = nullOr types.path;
              default = null;
              description =
                "The path to a file containing the private key for this interface/peer.";
            };
            dns = mkOption {
              type = with types; listOf str;
              default = [ ];
              description =
                "The IP addresses of the DNS servers provided by the VPN.";
            };
            endpoint = {
              ip = mkOption {
                type = types.str;
                description = "The IP address of the VPN server.";
              };
              port = mkOption {
                type = types.port;
                default = 51820;
                description = "The port number of the VPN server.";
              };
              publicKey = mkOption {
                type = types.str;
                description = "The public key of the VPN server.";
              };
            };
          };
        }));
      description = "List of Wireguard interfaces for ProtonVPN.";
    };
  };

  config = mkIf cfg.enable {

    networking.useNetworkd = true;
    services.wg-netmanager.enable = true;

    environment.systemPackages = with pkgs; [ wireguard-tools wg-netmanager ];

    systemd.network = {
      enable = true;
      networks.wg0 = {
        matchConfig.Name = "wg0";
        address = [ "10.100.0.1/24" ];
        networkConfig = {
          IPMasquerade = "ipv4";
          IPForward = true;
        };
      };
    };

    networking.wg-quick.interfaces = builtins.listToAttrs (map (interface: {
      name = interface.name;
      value = {
        autostart = mkIf (interface.autostart != null) interface.autostart;
        privateKey = mkIf (interface.privateKey != null) interface.privateKey;
        privateKeyFile =
          mkIf (interface.privateKeyFile != null) interface.privateKeyFile;
        address = [ interface.address ];
        listenPort = interface.port;
        dns = interface.dns;
        peers = [{
          publicKey = interface.endpoint.publicKey;
          endpoint =
            "${interface.endpoint.ip}:${toString interface.endpoint.port}";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
        }];
      };
    }) cfg.interfaces);

    # Assuming autostart means ensuring the interface is up after boot,
    # systemd services for each WireGuard interface could be defined as follows:
    # systemd.services = builtins.listToAttrs (map (interface: {
    #   name = "wg-quick@${interface.name}.service";
    #   value = {
    #     wantedBy = [ "multi-user.target" ];
    #     after = [ "network.target" ];
    #     requires = [ "network.target" ];
    #     # This ensures the service (and thus, the interface) starts automatically if enabled
    #     enable = interface.autostart;
    #   };
    # }) cfg.interfaces);
  };

  # config = mkIf cfg.enable {
  #   networking.wg-quick.interfaces."${cfg.interface.name}" = {
  #     autostart = cfg.autostart;
  #     dns = if cfg.interface.dns.enable then [ cfg.interface.dns.ip ] else [ ];
  #     privateKeyFile = cfg.interface.privateKeyFile;
  #     address = [ cfg.interface.ip ];
  #     listenPort = cfg.interface.port;

  #     peers = [{
  #       publicKey = cfg.endpoint.publicKey;
  #       allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #       endpoint = "${cfg.endpoint.ip}:${builtins.toString cfg.endpoint.port}";
  #     }];
  #   };
  # };
}
