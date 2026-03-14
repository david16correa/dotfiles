{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    adw-gtk3
  ];

  dconf.settings = {
    "org/gnome/desktop/interface".text-scaling-factor = 1.25;
    # "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    configFile = {
      "gtk-3.0/gtk.css".source = ./config/gtk/tokyo-night.css;
      "gtk-4.0/gtk.css".source = ./config/gtk/tokyo-night.css;
      "environment.d/gtk.conf".source = ./config/environment.d/gtk.conf;
    };
  };

  gtk = {
      enable = true;
      theme = {
          name = "adw-gtk3-dark";
          # name = "Adwaita-dark";
          # name = "Adwaita";
          package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
      };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  imports = [ inputs.lazyvim.homeManagerModules.default ];
  programs.lazyvim = {
    enable = true;

    extras = {
      lang.nix.enable = true;
      lang.julia.enable = true;
      lang.python.enable = true;
    };

    
    config = {
      options = ''
        vim.g.slime_target = "tmux"
        vim.g.slime_default_config = {
          socket_name = "default",
          target_pane = ":.2",
        }
        vim.g.slime_dont_ask_default = true

        vim.cmd("let g:latex_to_unicode_tab = 'off'")
        vim.cmd("let g:latex_to_unicode_auto = 1")

        vim.g.snacks_animate = false
        vim.opt.conceallevel = 0 -- keep \alpha as \alpha instead of α
        vim.g.autoformat = false
      '';
    };

    # IMPORTANT: Extras don't install treesitter parsers automatically
    # You must add them manually for syntax highlighting
    # treesitterParsers = with pkgs.tree-sitter-grammars; [
      # tree-sitter-nix
      # tree-sitter-julia
      # tree-sitter-python
    # ];

  };

  home.stateVersion = "25.11"; # the state version is required and should stay at the version you originally installed
}
