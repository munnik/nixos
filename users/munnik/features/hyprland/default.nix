{ config, pkgs, inputs, ... }:
let
  userName = "munnik";
  userId = "1000";
  groupId = "100";
  homeDirectory = "/home/${userName}";
  wallpaperPath = "${homeDirectory}/.local/share/wallpaper/wallpaper.png";
  font = "Hasklug Nerd Font Mono";
  screensaverTimeout = 300;
in
{
  home.sessionVariables = {
      # GDK_BACKEND = "wayland,x11";
      # GDK_SCALE = "1";
      # MOZ_ENABLE_WAYLAND = "1";
      # NIXOS_OZONE_WL = "1";
      # WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # XCURSOR_SIZE = "32";
      # XCURSOR_THEME = "Bibata-Modern-Classic";
      # XDG_CURRENT_DESKTOP = "Hyprland";
      # XDG_SESSION_DESKTOP = "Hyprland";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      env = [
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME ,nvidia"
        "XDG_SESSION_TYPE,wayland"
      ];
      monitor = [
        "eDP-1,highres,auto,1"
      ];
      exec-once = [
        "${pkgs.ydotool}/bin/ydotoold &"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
      ];
      input = {
        follow_mouse = true;
        natural_scroll = true;
        touchpad = {
          natural_scroll = true;
        };
      };
      cursor = {
        no_hardware_cursors = true;
      };
      misc = {
        disable_hyprland_logo = true;
      };
      bind = [
        "SUPER, Return, exec, alacritty"
        "SUPER, Space, exec, rofi -show drun -show-icons"
        "SUPER, W, killactive, "
        "SUPER, M, fullscreen, "
        "SUPER, E, exec, Thunar"
        "SUPER, F, togglefloating, "
        "SUPER, F, centerwindow, "
        "SUPER, L, exec, loginctl lock-session"
        "SUPER, J, togglesplit, # dwindle"
        "SUPER, P, exec, keepmenu"
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, S, exec, hyprshot -m output"
        "SUPER_SHIFT, S, exec, hyprshot -m window"
        "SHIFT_ALT, S, exec, hyprshot -m region"
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "SUPER, ${ws}, workspace, ${toString (x + 1)}"
              "SUPER SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      windowrulev2 = [
        "idleinhibit fullscreen, class:^(*)$"
        "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];
    };
  };

  home.packages = with pkgs; [
    hyprshot
    slurp
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    ydotool
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          timeout = screensaverTimeout;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ wallpaperPath ];
      wallpaper = [ ",${wallpaperPath}" ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = {
        path = "screenshot";
        blur_passes = 1;
        blur_size = 15;
        noise = 0;
      };
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          fade_timeout = 500;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
          shadow_passes = 2;
        }
      ];
      label = [ 
        {
          monitor = "";
          text = "cmd[update:500] echo \"$TIME\"";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 55;
          font_family = font;
          position = "-100, -40";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 20;
          font_family = font;
          position = "-100, 160";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 7500;
  };
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = { 
      modi = "drun";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
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
  };

  programs.waybar = {
    enable = true;
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
          format = " {:%H:%M:%S  %a, %e %b %Y}";
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
}
