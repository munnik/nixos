{
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
let
  userName = "munnik";
  homeDirectory = "/home/${userName}";

  agnoster-nix-theme = builtins.fetchurl {
    url = "https://gist.githubusercontent.com/CollinDewey/2e6b6c5b257d2f6895603ddb160e6f1d/raw/804f5d1bd9cb37c18cba252ff4eebf62dadc5c7f/agnoster-nix.zsh-theme";
    sha256 = "9E8E7633378E43EA3AC2A9A0ED3E361820C267A0EA290F8D8F64FC2482AF867F";
  };
  customDir = pkgs.stdenv.mkDerivation {
    name = "oh-my-zsh-custom-dir";
    phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out/themes
      cp ${agnoster-nix-theme} $out/themes/agnoster-nix.zsh-theme
    '';
  };
in
{
  home.username = "${userName}";
  home.stateVersion = "23.05";

  imports = [
    ./features/go.nix
    ./features/helix
    ./features/git
    ./features/hyprland
    ./features/onedrive
    ./features/wezterm
    ./features/zed-editor
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    acpi
    age
    air
    alejandra
    any-nix-shell
    bat
    bc
    brightnessctl
    delta
    eza
    fd
    feh
    ffmpeg_6-full
    jq
    keepmenu
    fontconfig
    #freecad
    fzf
    fzf-zsh
    gcc
    gimp
    gnumake
    haruna
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_NL
    impl
    jq
    keepassxc
    lf
    libnotify
    libreoffice
    librewolf
    lua-language-server
    macchina
    nil
    nix-zsh-completions
    nixd
    nodejs_20
    flake-inputs.nixpkgs-unfree.legacyPackages.${pkgs.system}.notable
    nss
    onedrivegui
    pavucontrol
    perl
    #peroxide
    #pgadmin4-desktopmode
    picard
    postgresql_16
    pulseview
    python311
    qelectrotech
    ripgrep
    screen
    shotwell
    signal-desktop
    sigrok-cli
    sigrok-firmware-fx2lafw
    silver-searcher
    socat
    sops
    sshfs
    stylua
    teams-for-linux
    # flake-inputs.nixpkgs-unfree.legacyPackages.${pkgs.system}.teamviewer
    thunderbird
    transmission-remote-gtk
    tree-sitter
    ungoogled-chromium
    unzip
    wayfarer
    wget
    wireshark
    zip
    zsh-command-time
    zsh-fast-syntax-highlighting
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.configFile = {
    keepmenu = {
      target = "keepmenu/config.ini";
      text = ''
        [dmenu]
        dmenu_command = rofi -dmenu -i -theme catppuccin-mocha-keepmenu

        [dmenu_passphrase]
        obscure = True

        [database]
        database_1 = ${homeDirectory}/Documents/KeePassXC/default.kdbx

        pw_cache_period_min = 5
        editor = hx
        terminal = ${pkgs.wezterm}/bin/wezterm
        type_library = ydotool

        hide_groups = Recycle Bin
      '';
    };
  };
  xdg.dataFile = {
  };
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      "x-scheme-handler/magnet" = "userapp-transmission-gtk-VM0V81.desktop";
      "application/pdf" = "librewolf.desktop";
      "application/zip" = "thunar.desktop";
      "image/jpeg" = "org.gnome.Shotwell-Viewer.desktop";
      "image/png" = "org.gnome.Shotwell-Viewer.desktop";
      "application/json" = "code.desktop";
    };
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/munnik/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # https://github.com/hyprwm/Hyprland/issues/1878
    # GBM_BACKEND = "nvidia-drm";
    # GDK_BACKEND = "wayland,x11";
    # GDK_SCALE = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # LIBVA_DRIVER_NAME = "nvidia";
    # MOZ_ENABLE_WAYLAND = "1";
    # NIXOS_OZONE_WL = "1";
    # WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    # WLR_NO_HARDWARE_CURSORS = "1";
    # XCURSOR_SIZE = "32";
    # XCURSOR_THEME = "Bibata-Modern-Classic";
    # XDG_CURRENT_DESKTOP = "Hyprland";
    # XDG_SESSION_DESKTOP = "Hyprland";
    # XDG_SESSION_TYPE = "wayland";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.btop.enable = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    enableVteIntegration = true;
    shellAliases = {
      eza = "eza --git --group --group-directories-first --header --long --icons --time-style=long-iso";
      watch = "watch --color";
    };
    initExtra = ''
      any-nix-shell zsh | source /dev/stdin
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "fzf"
      ];
      theme = "agnoster-nix";
      custom = "${customDir}";
    };
  };

  programs.vscode = {
    enable = true;
    package = flake-inputs.nixpkgs-unfree.legacyPackages.${pkgs.system}.vscode;
    extensions = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      redhat.vscode-yaml
      # ms-python.vscode-pylance
      ms-python.python
      ms-python.isort
      ms-python.black-formatter
      golang.go
    ];
  };

  gtk.enable = true;
}
