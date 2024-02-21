# nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'

{ stdenv, lib, pkgs, fetchFromGitHub, bash, subversion, makeWrapper }:
stdenv.mkDerivation {
  pname = "hypr-portal-reset";
  version = "08049f6";
  src = fetchFromGitHub {
    # https://github.com/jules-sommer/hypr-portal-reset
    owner = "Decad";
    repo = "hypr-portal-reset";
    rev = "08049f6183e559a9a97b1d144c070a36118cca97";
    sha256 = "073jkky5svrb7hmbx3ycgzpb37hdap7nd9i0id5b5yxlcnf7930r";
  };
  buildInputs = [ bash subversion ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp hypr-portal-reset.sh $out/bin/hypr-portal-reset.sh
    wrapProgram $out/bin/hypr-portal-reset.sh \
      --prefix PATH : ${lib.makeBinPath [ bash subversion ]}
  '';
}
