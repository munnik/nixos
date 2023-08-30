{ config, lib, pkgs, flake-inputs, ... }:
let
  userName = "munnik";
  userId = "1000";
  groupId = "100";
  homeDirectory = "/home/${userName}";
  wallpaperPath = "${homeDirectory}/.local/share/wallpaper/wallpaper.png";
  lockImagePath = "${homeDirectory}/.local/share/wallpaper/lock.png";
  font = "Hasklug Nerd Font Mono";
  screensaverTimeout = 300;
in
{
  home.username = "munnik";
  home.homeDirectory = /home/munnik;
  home.stateVersion = "23.05";

  imports = [
    ./features/go.nix
    ./features/nvim.nix
    ./features/helix
    ./features/git
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
    air
    bat
    bc
    brightnessctl
    delta
    fd
    feh
    ffmpeg_6-full
    flake-inputs.eza.packages.${pkgs.system}.default
    flake-inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.keepmenu
    fontconfig
    freecad
    fzf
    fzf-zsh
    gcc
    gimp
    gnumake
    grim
    haruna
    impl
    jq
    keepassxc
    kitty-themes
    languagetool
    lf
    libnotify
    libreoffice
    librewolf
    lua-language-server
    macchina
    nil
    nix-zsh-completions
    nodejs_20
    flake-inputs.nixpkgs-unfree.legacyPackages.${pkgs.system}.notable
    pavucontrol
    perl
    peroxide
    pgadmin4-desktopmode
    picard
    python311
    ripgrep
    screen
    signal-desktop
    silver-searcher
    socat
    sshfs
    stylua
    swww
    teams-for-linux
    thunderbird
    transmission-remote-gtk
    tree-sitter
    unzip
    flake-inputs.nixpkgs-unfree.legacyPackages.${pkgs.system}.vscode
    wget
    wayland-protocols
    wayland-utils
    wireshark
    wl-clipboard
    wlroots
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    ydotool
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
    btop.source = dotfiles/config/btop;
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
        editor = nvim
        terminal = kitty
        type_library = ydotool

        hide_groups = Recycle Bin      
      '';
    };
    macchina.source = dotfiles/config/macchina;
  };
  xdg.dataFile = {
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
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland,x11";
      GDK_SCALE = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      WLR_NO_HARDWARE_CURSORS = "1";
      XCURSOR_SIZE = "32";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    #recommendedEnvironment = true;
    extraConfig = ''
      monitor=,highres,auto,1
      exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1
      exec-once=swww init
      exec-once=swww img ${wallpaperPath}
      exec-once=ydotoold --socket-path=/run/user/${userId}/.ydotool_socket --socket-own=${userId}:${groupId}
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =
        follow_mouse = 1
        natural_scroll = yes
        touchpad {
          natural_scroll = yes
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
      general {
        gaps_in = 2
        gaps_out = 4
        border_size = 2
        col.active_border = rgba(89dcebff)
        col.inactive_border = rgba(7f849cff)
        layout = dwindle
        cursor_inactive_timeout = 299 # 1 second before screensaver
      }
      animations {
        enabled = yes
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }
      dwindle {
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
      }
      master {
        new_is_master = true
      }
      gestures {
        workspace_swipe = off
      }
      misc {
        disable_hyprland_logo = yes
        disable_splash_rendering = yes
      }
      bind = SUPER, Return, exec, kitty /bin/sh -c 'macchina && exec zsh'
      bind = SUPER, W, killactive, 
      bind = SUPER, M, fullscreen, 
      bind = SUPER, E, exec, Thunar
      bind = SUPER, F, togglefloating, 
      bind = SUPER, F, centerwindow, 
      bind = SUPER, space, exec, rofi -show drun -show-icons
      bind = SUPER, S, exec, grimblast copy active
      bind = SUPER SHIFT, S, exec, grimblast copy area
      bind = SUPER, J, togglesplit, # dwindle
      bind = SUPER, P, exec, keepmenu
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
      bind = SUPER SHIFT, 6, movetoworkspacesilent, 6
      bind = SUPER SHIFT, 7, movetoworkspacesilent, 7
      bind = SUPER SHIFT, 8, movetoworkspacesilent, 8
      bind = SUPER SHIFT, 9, movetoworkspacesilent, 9
      bind = SUPER SHIFT, 0, movetoworkspacesilent, 10
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
    '';
    systemdIntegration = true;
    xwayland.enable = true;
  };

  services.mako = {
    enable = true;

    font = "${font}";
    defaultTimeout = 7500;
    backgroundColor = "#303446";
    textColor = "#c6d0f5";
    borderColor = "#8caaee";
    progressColor = "over #414559";
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      { 
        event = "before-sleep"; 
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
    timeouts = [
      { 
        timeout = screensaverTimeout; 
        command = "${pkgs.grim}/bin/grim -c ${lockImagePath} && ${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
  };

  programs.btop = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "${font}";
      size = 10;
    };
    theme = "Catppuccin-Mocha";
    shellIntegration.enableZshIntegration = true;
    settings = {
      background_opacity = "0.6";
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = { 
      modi = "drun";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
    theme = "catppuccin-mocha";
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      ignore-empty-password = true;
      font = "${font}";
      fade-in = 1;
      grace = 5;
      image = "${lockImagePath}";
      effect-pixelate = 15;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.catppuccin
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
    ];
    extraConfig = ''
      set-option -sa terminal-features ",xtermkitty:RGB"
      set-option -g mouse on

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window
                   a
      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      set-window-option -g mode-keys vi

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.waybar = {
    enable = true;
    package = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.waybar;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      mainBar = {
        position = "top";
        mod = "docker";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        modules-left = [
          "clock"
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "backlight"
          "pulseaudio"
          "pulseaudio#microphone"
          "battery"
          "bluetooth"
          "network"
          "network#wireguard"
          "temperature"
          "cpu"
          "memory"
          "disk"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          persistent_workspaces = {
            "*" = 10;
          };
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
            urgent = "";
            active = "";
            default = "";
          };
          on-click = "activate";
          on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e+1";
          on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e-1";
          sort-by-number = true;
        };
        tray = {
          icon-size = 15;
          spacing = 10;
        };
        clock = {
          interval = 1;
          format = "{: %H:%M:%S  %a, %e %b %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent:3}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
          reverse-mouse-scrolling = true;
          scroll-step = 1;
          min-length = 6;
        };
        battery = {
          battery = "BAT0";
          adapter = "AC";
          states = {
            good = 95;
            warning = 50;
            critical = 10;
          };
          format = "{icon} {capacity:3}%";
          format-charging = " {capacity:3}%";
          format-plugged = " {capacity:3}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        pulseaudio = {
          format = "{icon} {volume:3}%";
          format-muted = "󰸈 {volume:3}%";
          on-click = "${pkgs.alsa-utils}/bin/amixer set Master 1+ toggle";
          on-scroll-up = "${pkgs.alsa-utils}/bin/amixer sset Master 1%+";
          on-scroll-down = "${pkgs.alsa-utils}/bin/amixer sset Master 1%-";
          reverse-mouse-scrolling = true;
          scroll-step = 1;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume:3}%";
          format-source-muted = "󰍭 {volume:3}%";
          on-click = "${pkgs.alsa-utils}/bin/amixer set Capture 1+ toggle";
          on-scroll-up = "${pkgs.alsa-utils}/bin/amixer sset Capture 1%+";
          on-scroll-down = "${pkgs.alsa-utils}/bin/amixer sset Capture 1%-";
          reverse-mouse-scrolling = true;
          scroll-step = 1;
        };
        temperature = {
          thermal-zone = 1;
          format = " {temperatureC:2}°C";
          critical-threshold = 80;
          format-critical = " {temperatureC:2}°C";
        };
        network = {
          interface = "wlp*";
          format-wifi = "󰖩 {signalStrength:3}%";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{essid} - {ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "󰖩 {ifname}:{essid} {ipaddr}/{cidr}";
        };
        "network#wireguard" = {
          interface = "wg*";
          format-wifi = "󰖩 {signalStrength:3}%";
          format-ethernet = " up";
          tooltip-format = "{ipaddr}/{cidr} - {ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = " down";
          format-alt = " {ifname} {ipaddr}/{cidr}";
        };
        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {num_connections}";
          tooltip-format = "{device_alias}";
          tooltip-format-connected = " {device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
        };
        cpu = {
          interval = 1;
          format = " {usage:3}% 󰜎 {avg_frequency:4}GHz";
        };
        memory = {
          interval = 1;
          format = " {:2}%";
        };          
        disk = {
          interval = 10;
          format = "󰋊 {percentage_used:2}%";
        };          
      };
    };
    style = ''
/*
*
* Catppuccin Mocha palette
* Maintainer: rubyowo
*
*/

@define-color base   #1e1e2e;
@define-color mantle #181825;
@define-color crust  #11111b;

@define-color text     #cdd6f4;
@define-color subtext0 #a6adc8;
@define-color subtext1 #bac2de;

@define-color surface0 #313244;
@define-color surface1 #45475a;
@define-color surface2 #585b70;

@define-color overlay0 #6c7086;
@define-color overlay1 #7f849c;
@define-color overlay2 #9399b2;

@define-color blue      #89b4fa;
@define-color lavender  #b4befe;
@define-color sapphire  #74c7ec;
@define-color sky       #89dceb;
@define-color teal      #94e2d5;
@define-color green     #a6e3a1;
@define-color yellow    #f9e2af;
@define-color peach     #fab387;
@define-color maroon    #eba0ac;
@define-color red       #f38ba8;
@define-color mauve     #cba6f7;
@define-color pink      #f5c2e7;
@define-color flamingo  #f2cdcd;
@define-color rosewater #f5e0dc;

* {
  border: none;
  border-radius: 0;
  font-family: "JetBrainsMono Nerd Font";
  font-weight: bold;
  font-size: 11px;
  min-height: 0;
  transition: 0.3s;
}

window#waybar {
  background: rgba(0, 0, 0, 0);
}

tooltip {
  background: @base;
  border-width: 1.5px;
  border-style: solid;
  border-color: @crust;
  transition: 0.3s;
}

#window,
#clock,
#battery,
#pulseaudio,
#network,
#bluetooth,
#temperature,
#workspaces,
#cpu,
#memory,
#disk,
#custom-power,
#backlight {
  background: @base;
  color: @text;
  padding: 0 8px 0 8px;
  border: 2px solid @mantle;
}

#workspaces {
  background: @base;
  border-left: 0;
}

#workspaces button {
  color: @blue;
}

#workspaces button:hover {
  box-shadow: inherit;
  text-shadow: inherit;
  background: @base;
  color: @crust;
}

#workspaces button.active {
  color: @green;
}

#workspaces button.urgent {
  color: @red;
  background: @crust;
}

#workspaces button.persistent {
  color: @text;
}

#temperature {
  border-left: 0;
  border-right: 0;
}

#temperature.critical {
  color: @red;
}

#cpu {
  border-left: 0;
  border-right: 0;
}

#memory {
  border-left: 0;
  border-right: 0;
}

#disk {
  border-left: 0;
  padding-right: 10px;
}

#backlight {
  border-right: 0;
  padding-left: 10px;
}

#window {
  padding-left: 10px;
  padding-right: 10px;
}

#clock {
  border-right: 0;
  padding-left: 10px;
}

#network {
  border-left: 0;
  border-right: 0;
}

#bluetooth {
  border-left: 0;
  border-right: 0;
} 

#pulseaudio {
  border-left: 0;
  border-right: 0;
}

#pulseaudio.microphone {
  border-left: 0;
  border-left: 0;
}

#battery {
  border-left: 0;
  border-right: 0;
}
   '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;
    shellAliases = {
      eza = "eza --git --group --group-directories-first --header --long --icons --time-style=long-iso";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
        "sudo" 
        "tmux" 
      ];
      theme = "gnzh";
    };
  };
  
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
      };
    };
  };
}

