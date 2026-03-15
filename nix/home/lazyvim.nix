{ inputs, pkgs, unstable, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  home.packages = with unstable; [
    statix
    tree-sitter
    ghostscript
    ast-grep
    mermaid-cli
  ];

  programs.lazyvim = {
    enable = true;

    extras = {
      lang = {
       nix.enable = true;
        julia.enable = true;
        python.enable = true;
      };
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

    plugins = {
      # colorscheme = ''
      #   return {
      #     {
      #       "loctvl842/monokai-pro.nvim",
      #       opts = { filter = "octagon" }, -- classic | octagon | pro | machine | ristretto | spectrum
      #     },
      #     {
      #       "LazyVim/LazyVim",
      #       opts = {
      #         colorscheme = "monokai-pro",
      #       },
      #     },
      #   }
      # '';
      
      colorscheme = ''
        return {
          {
            "folke/tokyonight.nvim",
            opts = {
              style = "night",
              transparent = true,
              styles = {
                sidebars = "transparent",
                floats = "transparent",
              },
            },
          },
        }
      '';

      vim-slime = ''
        return {
          "jpalardy/vim-slime",
          -- lazy = false,
        }
      '';

      neo-tree = ''
        -- aniadi esto para mostrar mis playgrounds, que son documentos ignorados por git
        return {
          "nvim-neo-tree/neo-tree.nvim",
          opts = {
            filesystem = {
              filtered_items = {
                visible = false,
                hide_dotfiles = true,
                hide_gitignored = false,
              },
            },
          },
        }
      '';

      julia-vim = ''
        return {
          {
            "JuliaEditorSupport/julia-vim",
          },
        }
      '';

      # lsp-config = ''
      #   return {
      #     "neovim/nvim-lspconfig",
      #     opts = function(_, opts)
      #       -- Add additional LSP configuration here
      #       return opts
      #     end,
      #   }
      # '';
    };
  };
}
