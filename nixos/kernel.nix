{ pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ZFS is broken on new kernel
  boot.supportedFilesystems.zfs = lib.mkForce false;
}
