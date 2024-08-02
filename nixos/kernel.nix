{ pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ZFS is broken on new kernel
  boot.supportedFilesystems.zfs = lib.mkForce false;
}
