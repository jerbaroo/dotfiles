{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in {
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;
  # Garbage collect old generations.
  nix.gc.automatic = true;
  nix.gc.dates = "--delete-older-than 7d";
  # Include the results of the hardware scan.
  imports = [ ./hardware-configuration.nix ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Per-interface useDHCP will be mandatory in the future.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;
  # Localisation.
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Fira Code Retina";
  console.keyMap = "uk";
  time.timeZone = "Europe/Dublin";
  # Packages.
  environment.systemPackages = with pkgs; [
    cava compton curl emacs feh haskellPackages.xmobar git kitty lsd neofetch
    neovim rofi spotifyd starship tuir tmux wget xclip

    unstable.firefox-devedition-bin-unwrapped unstable.spotify-tui
  ];
  programs.fish.enable = true;
  fonts.fonts = with pkgs; [ fira-code ];
  # X11 windowing system.
  services.xserver.enable = true;
  # Xmonad window manager.
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  # Skip the login screen.
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = "jeremy";
  # Sound and bluetooth.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # VMware.
  virtualisation.vmware.guest.enable = true;
  # User account.
  users.users.jeremy.isNormalUser = true;
  users.users.jeremy.extraGroups = [ "wheel" ];
  users.users.jeremy.shell = pkgs.fish;
  system.stateVersion = "20.03";
}
