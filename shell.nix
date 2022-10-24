# change the pkgs import to a tag when there is a 22.XX version
# at the moment we need a specific SHA to be able to use m1 chromedriver
{
  lib ? import <lib> {},
  pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/77e90cd16d2cfeba7cbf474f6f21e63149bbf307.zip) {}
}:

let

  # define packages to install with special handling for OSX
  basePackages = [
    pkgs.gnumake
    pkgs.gcc
    pkgs.readline
    pkgs.zlib
    pkgs.libxml2
    pkgs.libiconv
    pkgs.openssl
    pkgs.curl
    pkgs.git

    pkgs.postgresql

    pkgs.erlangR25
    pkgs.beam.packages.erlangR25.elixir_1_14
    pkgs.nodejs-16_x
    pkgs.yarn
  ];

  inputs = basePackages
    ++ [ pkgs.bashInteractive ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.inotify-tools pkgs.libcap ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);

in pkgs.mkShell {
  buildInputs = inputs;
}
