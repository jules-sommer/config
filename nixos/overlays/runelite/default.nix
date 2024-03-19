{ channels, ... }:

final: prev: {
  inherit (channels.stable) runelite;
}
