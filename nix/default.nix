{ config ? import ./config.nix, pkgs ? import <nixpkgs> { config = config; } }:
pkgs.myPackages
