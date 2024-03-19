WireGuard VPN services can be configured in the `jules` namespace with the following format.

```nix
services = {
  protonvpn = {
    enable = false;
    interfaces = [ ];
  };
};
```

```nix
{
  autostart = true;
  name = "pvpn-tun0";
  ip = "10.2.0.2/32";
  privateKeyFile = "/run/keys/PVPN-336-CAN";
  port = 51820;
  dns = [ "10.2.0.1" ];
  endpoint = {
    publicKey = "Y46WhKEXcCGgPn+LXHDrlD93hgVzrA2mju7XQBbyyXU=";
    ip = "149.88.97.97";
    port = 51820;
  };
}
```
