# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  ylib,
  lib,
  outputs,
  ...
}:
{
  # imports = lib.lists.remove ./home.nix (
  #   ylib.umport {
  #     paths = [ ./. ];
  #     recursive = true;
  #   }
  # );

  home = {
    username = "perchun";
    homeDirectory = "/home/perchun";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
