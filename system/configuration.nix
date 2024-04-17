# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllFirmware = true;
 
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  system.autoUpgrade.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;

  networking.hostId = "5f63b4a9";
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  # };

#   environment.etc.WireGuard-mconnection = let
#     privateKey = builtins.readFile ./wireguard/privatekey;
#   in {
#     target = "NetworkManager/system-connections/WireGuard.nmconnection";    
#     text = "
# [connection]
# id=wg0
# uuid=0a604682-eaac-41c9-a6da-caee9b8f2762
# type=wireguard
# interface-name=wg0

# [wireguard]
# private-key=${privateKey}

# [wireguard-peer.MhaYKOT9bs157g0qHin7nFg33zzpIzCk7O7Y0DbKJTo=]
# endpoint=136.144.250.141:51820
# allowed-ips=10.24.0.0/16;

# [ipv4]
# address1=10.24.0.10/16
# method=manual

# [ipv6]
# addr-gen-mode=default
# method=disabled

# [proxy]
#     ";
#   };

  programs.udevil.enable = true;
  programs.wireshark.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  services.udisks2.enable = true;
  services.sanoid = {
    enable = true;
    datasets."ROOT/home" = {
      autoprune = true;
      autosnap = true;
      recursive = true;
      hourly = 168; # one week
      daily = 60;
      monthly = 6;
    };
  };

  services.syncthing = {
    enable = true;
    # package = pkgs.syncthingtray;
    dataDir = "/home/munnik";
    openDefaultPorts = true;
    configDir = "/home/munnik/.config/syncthing";
    user = "munnik";
    group = "users";
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;
  };
  
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    # displayManager.gdm = {
    #     enable = true;
    #     wayland = true;
    # };
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  xdg.portal.config.common.default = "*";


  hardware.nvidia = {
    # prime = {
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };

    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:1:0:0";
    # };
    modesetting.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.passSecretService.enable = true;
  services.languagetool.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
        user = "greeter";
      };
    };
  };

  #programs.hyprland.enableNvidiaPatches = true;
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  environment.variables = {
    LIBSEAT_BACKEND = "logind";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.munnik = {
    isNormalUser = true;
    initialPassword = "dunno";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "libvirtd" "video" "docker" "input" "wireshark" "dialout" "plugdev" ];
  };
  users.groups.plugdev = {};
  services.onedrive.enable = true;

  services.udev.extraRules = ''
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"

##
## This file is part of the libsigrok project.
##
## Copyright (C) 2010-2013 Uwe Hermann <uwe@hermann-uwe.de>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see <http://www.gnu.org/licenses/>.
##

#
# These rules do not grant any permission by itself, but flag devices
# supported by libsigrok.
# The access policy is stored in the 61-libsigrok-plugdev.rules and
# 61-libsigrok-uaccess.rules.
#
# Note: Any syntax changes here will need to be tested against the
# 'update-device-filter' Makefile target in the sigrok-androidutils
# repo, since that parses this file.
#

#
# Please keep this list sorted alphabetically by vendor/device name.
#

ACTION!="add|change", GOTO="libsigrok_rules_end"
SUBSYSTEM!="usb|usbmisc|usb_device|hidraw", GOTO="libsigrok_rules_end"

# Agilent USBTMC-connected devices
# 34405A
ATTRS{idVendor}=="0957", ATTRS{idProduct}=="0618", ENV{ID_SIGROK}="1"
# 34410A
ATTRS{idVendor}=="0957", ATTRS{idProduct}=="0607", ENV{ID_SIGROK}="1"
# 34460A
ATTRS{idVendor}=="0957", ATTRS{idProduct}=="1b07", ENV{ID_SIGROK}="1"
# DSO1000 series
ATTRS{idVendor}=="0957", ATTRS{idProduct}=="0588", ENV{ID_SIGROK}="1"
# MSO7000A series
ATTRS{idVendor}=="0957", ATTRS{idProduct}=="1735", ENV{ID_SIGROK}="1"

# ASIX SIGMA
# ASIX SIGMA2
# ASIX OMEGA
ATTRS{idVendor}=="a600", ATTRS{idProduct}=="a000", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="a600", ATTRS{idProduct}=="a004", ENV{ID_SIGROK}="1"

# Braintechnology USB-LPS
ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0498", ENV{ID_SIGROK}="1"

# Brymen BU-86X adapter (e.g. for Brymen BM867/BM869 and possibly others).
ATTRS{idVendor}=="0820", ATTRS{idProduct}=="0001", ENV{ID_SIGROK}="1"

# ChronoVu LA8 (new VID/PID)
# ChronoVu LA16 (new VID/PID)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="8867", ENV{ID_SIGROK}="1"

# CWAV USBee AX
# ARMFLY AX-Pro (clone of the CWAV USBee AX)
# ARMFLY Mini-Logic (clone of the CWAV USBee AX)
# EE Electronics ESLA201A (clone of the CWAV USBee AX)
# HT USBee-AxPro (clone of the CWAV USBee AX)
# MCU123 USBee AX Pro clone (clone of the CWAV USBee AX)
# Noname LHT00SU1 (clone of the CWAV USBee AX)
# XZL_Studio AX (clone of the CWAV USBee AX)
ATTRS{idVendor}=="08a9", ATTRS{idProduct}=="0014", ENV{ID_SIGROK}="1"

# CWAV USBee DX
# HT USBee-DxPro (clone of the CWAV USBee DX), not yet supported!
# XZL_Studio DX (clone of the CWAV USBee DX)
ATTRS{idVendor}=="08a9", ATTRS{idProduct}=="0015", ENV{ID_SIGROK}="1"

# CWAV USBee SX
ATTRS{idVendor}=="08a9", ATTRS{idProduct}=="0009", ENV{ID_SIGROK}="1"

# CWAV USBee ZX
ATTRS{idVendor}=="08a9", ATTRS{idProduct}=="0005", ENV{ID_SIGROK}="1"

# Cypress FX2 eval boards without EEPROM:
# Lcsoft Mini Board
# Braintechnology USB Interface V2.x
# fx2grok-tiny
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="8613", ENV{ID_SIGROK}="1"

# Dangerous Prototypes Buspirate (v3)
# ChronoVu LA8 (old VID/PID)
# ChronoVu LA16 (old VID/PID)
# ftdi-la (FT232R)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ENV{ID_SIGROK}="1"

# Dangerous Prototypes Buspirate (v4)
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="fb00", ENV{ID_SIGROK}="1"

# dcttech.com USB relay card, and other V-USB based firmware
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", ENV{ID_SIGROK}="1"

# DreamSourceLab DSLogic
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0001", ENV{ID_SIGROK}="1"
# DreamSourceLab DSLogic Pro
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0003", ENV{ID_SIGROK}="1"
# DreamSourceLab DScope
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0002", ENV{ID_SIGROK}="1"
# DreamSourceLab DSLogic Plus
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0020", ENV{ID_SIGROK}="1"
# DreamSourceLab DSLogic Basic
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0021", ENV{ID_SIGROK}="1"

# Great Scott Gadgets
# GreatFET One
ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60e6", ENV{ID_SIGROK}="1"

# GW-Instek GDM-9061 (USBTMC mode)
ATTRS{idVendor}=="2184", ATTRS{idProduct}=="0059", ENV{ID_SIGROK}="1"

# HAMEG HO720
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="ed72", ENV{ID_SIGROK}="1"

# HAMEG HO730
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="ed73", ENV{ID_SIGROK}="1"

# Hantek DSO-2090
# lsusb: "04b4:2090 Cypress Semiconductor Corp."
# lsusb after FW upload: "04b5:2090 ROHM LSI Systems USA, LLC"
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2090", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="2090", ENV{ID_SIGROK}="1"

# Hantek DSO-2150
# lsusb: "04b4:2150 Cypress Semiconductor Corp."
# lsusb after FW upload: "04b5:2150 ROHM LSI Systems USA, LLC"
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2150", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="2150", ENV{ID_SIGROK}="1"

# Hantek DSO-2250
# lsusb: "04b4:2250 Cypress Semiconductor Corp."
# lsusb after FW upload: "04b5:2250 ROHM LSI Systems USA, LLC"
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2250", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="2250", ENV{ID_SIGROK}="1"

# Hantek DSO-5200
# lsusb: "04b4:5200 Cypress Semiconductor Corp."
# lsusb after FW upload: "04b5:5200 ROHM LSI Systems USA, LLC"
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="5200", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="5200", ENV{ID_SIGROK}="1"

# Hantek DSO-5200A
# lsusb: "04b4:520a Cypress Semiconductor Corp."
# lsusb after FW upload: "04b5:520a ROHM LSI Systems USA, LLC"
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="520a", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="520a", ENV{ID_SIGROK}="1"

# Hantek 6022BE, renumerates as 1d50:608e "sigrok fx2lafw", Serial: Hantek 6022BE
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="6022", ENV{ID_SIGROK}="1"

# Hantek 6022BL, renumerates as 1d50:608e "sigrok fx2lafw", Serial: Hantek 6022BL
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="602a", ENV{ID_SIGROK}="1"

# Hantek 4032L
ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="4032", ENV{ID_SIGROK}="1"

# IKALOGIC Scanalogic-2
ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="4123", ENV{ID_SIGROK}="1"

# IKALOGIC ScanaPLUS
# ftdi-la (FT232H)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", ENV{ID_SIGROK}="1"

# ftdi-la (TIAO USB Multi Protocol Adapter (TUMPA))
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="8a98", ENV{ID_SIGROK}="1"

# Kecheng KC-330B
ATTRS{idVendor}=="1041", ATTRS{idProduct}=="8101", ENV{ID_SIGROK}="1"

# Keysight USBTMC-connected devices
# 34465A
ATTRS{idVendor}=="2a8d", ATTRS{idProduct}=="0101", ENV{ID_SIGROK}="1"

# Kingst LA2016
ATTRS{idVendor}=="77a1", ATTRS{idProduct}=="01a2", ENV{ID_SIGROK}="1"

# Lascar Electronics EL-USB-2
# Lascar Electronics EL-USB-CO
# This is actually the generic SiLabs (Cygnal) F32x USBXpress VID:PID.
ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="0002", ENV{ID_SIGROK}="1"

# LeCroy LogicStudio16
ATTRS{idVendor}=="05ff", ATTRS{idProduct}=="a001", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="05ff", ATTRS{idProduct}=="a002", ENV{ID_SIGROK}="1"

# LeCroy WaveRunner
# 05ff:1023: 625Zi
ATTRS{idVendor}=="05ff", ATTRS{idProduct}=="1023", ENV{ID_SIGROK}="1"

# Link Instruments MSO-19
ATTRS{idVendor}=="3195", ATTRS{idProduct}=="f190", ENV{ID_SIGROK}="1"

# Logic Shrimp
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="fa95", ENV{ID_SIGROK}="1"

# MiniLA Mockup
# ftdi-la (FT2232H)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", ENV{ID_SIGROK}="1"

# ftdi-la (FT4232H)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", ENV{ID_SIGROK}="1"

# MIC 98581
# MIC 98583
# Tondaj SL-814
ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", ENV{ID_SIGROK}="1"

# Microchip PICkit2
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="0033", ENV{ID_SIGROK}="1"

# Openbench Logic Sniffer
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="000a", ENV{ID_SIGROK}="1"

# Rigol DS1000 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0588", ENV{ID_SIGROK}="1"

# Rigol 1000Z series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="04ce", ENV{ID_SIGROK}="1"

# Rigol DS2000 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="04b0", ENV{ID_SIGROK}="1"

# Rigol DS4000 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="04b1", ENV{ID_SIGROK}="1"

# Rigol DG4000 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0641", ENV{ID_SIGROK}="1"

# Rigol DG1000z series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0642", ENV{ID_SIGROK}="1"

# Rigol DG800 and DG900 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0643", ENV{ID_SIGROK}="1"

# Rigol DP800 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0e11", ENV{ID_SIGROK}="1"

# Rigol MSO5000 series
ATTRS{idVendor}=="1ab1", ATTRS{idProduct}=="0515", ENV{ID_SIGROK}="1"

# Rohde&Schwarz HMO series mixed-signal oscilloscope (previously branded Hameg) VCP/USBTMC mode
ATTRS{idVendor}=="0aad", ATTRS{idProduct}=="0117", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0aad", ATTRS{idProduct}=="0118", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0aad", ATTRS{idProduct}=="0119", ENV{ID_SIGROK}="1"

# Rohde&Schwarz HMC series power supply (previously branded Hameg) VCP/USBTMC mode
ATTRS{idVendor}=="0aad", ATTRS{idProduct}=="0135", ENV{ID_SIGROK}="1"

# Sainsmart DDS120 / Rocktech BM102, renumerates as 1d50:608e "sigrok fx2lafw", Serial: Sainsmart DDS120
ATTRS{idVendor}=="8102", ATTRS{idProduct}=="8102", ENV{ID_SIGROK}="1"

# Saleae Logic
# EE Electronics ESLA100 (clone of the Saleae Logic)
# Hantek 6022BL in LA mode (clone of the Saleae Logic)
# Instrustar ISDS205X in LA mode (clone of the Saleae Logic)
# Robomotic MiniLogic (clone of the Saleae Logic)
# Robomotic BugLogic 3 (clone of the Saleae Logic)
# MCU123 Saleae Logic clone (clone of the Saleae Logic)
ATTRS{idVendor}=="0925", ATTRS{idProduct}=="3881", ENV{ID_SIGROK}="1"

# Saleae Logic16
ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1001", ENV{ID_SIGROK}="1"

ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1003", ENV{ID_SIGROK}="1"

# Saleae Logic 8, currently unsupported by libsigrok
#ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1004", ENV{ID_SIGROK}="1"

# Saleae Logic Pro 8
ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1005", ENV{ID_SIGROK}="1"

# Saleae Logic Pro 16
ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1006", ENV{ID_SIGROK}="1"

# Siglent USBTMC devices.
# f4ec:ee3a: E.g. SDS1052DL+ scope
# f4ec:ee38: E.g. SDS1104X-E scope or SDM3055 Multimeter
# f4ed:ee3a: E.g. SDS1202X-E scope or SDG1010 waveform generator
ATTRS{idVendor}=="f4ec", ATTRS{idProduct}=="ee38", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="f4ec", ATTRS{idProduct}=="ee3a", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="f4ed", ATTRS{idProduct}=="ee3a", ENV{ID_SIGROK}="1"

# sigrok FX2 LA (8ch)
# fx2grok-flat (before and after renumeration)
ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608c", ENV{ID_SIGROK}="1"

# sigrok FX2 LA (16ch)
ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608d", ENV{ID_SIGROK}="1"

# sigrok FX2 DSO (2ch)
ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608e", ENV{ID_SIGROK}="1"

# sigrok usb-c-grok
ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608f", ENV{ID_SIGROK}="1"

# SiLabs CP210x (USB CDC) UART bridge, used (among others) in:
# CEM DT-8852
# Manson HCS-3202
# MASTECH MS2115B
# MASTECH MS5308
# MASTECH MS8250D
# PeakTech 3330
# Voltcraft PPS-11815
ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ENV{ID_SIGROK}="1"

# SiLabs CP2110 (USB HID) UART bridge, used (among others) in:
# UNI-T UT612
# UNI-T UT-D09 multimeter cable (for various UNI-T and rebranded DMMs)
ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea80", ENV{ID_SIGROK}="1"

# Sysclk LWLA1016
ATTRS{idVendor}=="2961", ATTRS{idProduct}=="6688", ENV{ID_SIGROK}="1"

# Sysclk LWLA1034
ATTRS{idVendor}=="2961", ATTRS{idProduct}=="6689", ENV{ID_SIGROK}="1"

# Sysclk SLA5032 ("32CH 500M" mode)
ATTRS{idVendor}=="2961", ATTRS{idProduct}=="66b0", ENV{ID_SIGROK}="1"

# Testo 435
ATTRS{idVendor}=="128d", ATTRS{idProduct}=="0003", ENV{ID_SIGROK}="1"

# UNI-T UT-D04 multimeter cable (for various UNI-T and rebranded DMMs)
# UNI-T UT325
ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="e008", ENV{ID_SIGROK}="1"

# V&A VA4000 multimeter cable (for various V&A DMMs)
ATTRS{idVendor}=="04fc", ATTRS{idProduct}=="0201", ENV{ID_SIGROK}="1"

# Victor 70C
# Victor 86C
ATTRS{idVendor}=="1244", ATTRS{idProduct}=="d237", ENV{ID_SIGROK}="1"

# Voltcraft DSO2020, renumerates as 1d50:608e "sigrok fx2lafw", Serial: Hantek 6022BE
ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2020", ENV{ID_SIGROK}="1"

# YiXingDianZi MDSO
ATTRS{idVendor}=="d4a2", ATTRS{idProduct}=="5660", ENV{ID_SIGROK}="1"

# ZEROPLUS Logic Cube LAP-C series
# There are various devices in the ZEROPLUS Logic Cube series:
# 0c12:7002: LAP-16128U
# 0c12:7009: LAP-C(16064)
# 0c12:700a: LAP-C(16128)
# 0c12:700b: LAP-C(32128)
# 0c12:700c: LAP-C(321000)
# 0c12:700d: LAP-C(322000)
# 0c12:700e: LAP-C(16032)
# 0c12:7016: LAP-C(162000)
# 0c12:7025: LAP-C(16128+)
# 0c12:7100: AKIP-9101
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7002", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7007", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7009", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="700a", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="700b", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="700c", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="700d", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="700e", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7016", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7025", ENV{ID_SIGROK}="1"
ATTRS{idVendor}=="0c12", ATTRS{idProduct}=="7100", ENV{ID_SIGROK}="1"

LABEL="libsigrok_rules_end"



##
## This file is part of the libsigrok project.
##
## Copyright (C) 2017 Stefan Bruens <stefan.bruens@rwth-aachen.de>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see <http://www.gnu.org/licenses/>.
##

# Grant access permissions to users who are in the "plugdev" group.
# "plugdev" is typically used on Debian based distributions and may not
# exist elsewhere.
#
# This file, when installed, must be installed with a name lexicographically
# sorted later than the accompanied 60-libsigrok.rules

ACTION!="add|change", GOTO="libsigrok_rules_plugdev_end"

ENV{ID_SIGROK}=="1", MODE="660", GROUP="plugdev"

LABEL="libsigrok_rules_plugdev_end"
  '';

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  programs.dconf.enable = true;
  programs.zsh.enable = true;

  # services.teamviewer.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  services.peroxide.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    catppuccin-cursors

    pinentry-curses
    gnupg

    home-manager

    cage
  ];

  programs.virt-manager.enable = true;
  
  security.pam.services.swaylock = {};

  environment.shells = with pkgs; [ zsh ];

  fonts = {
    packages = with pkgs; [
      nerdfonts
      montserrat
    ];
    fontDir.enable = true;
  };

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

