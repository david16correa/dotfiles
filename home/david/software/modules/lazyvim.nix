{ inputs, pkgs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  home.packages = with pkgs; [
    statix
    ghostscript
    ast-grep
    mermaid-cli
    clang-tools
    markdownlint-cli2
    tree-sitter
    ltex-ls-plus
  ];

  programs.lazyvim = {
    enable = true;
    extras = {
      lang = {
        nix.enable = true;
        julia.enable = true;
        python.enable = true;
        clangd.enable = true;
        markdown.enable = true;
        git.enable = true;
        tex.enable = true;
        dotnet.enable = true;
      };
    };

    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      bash
      zsh
    ];

    config = {
      options = /*lua*/''
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

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "tex", "markdown" },
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.breakindent = true
          end,
        })
      '';

      autocmds = /*lua*/''
        vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
      '';
    };

    plugins = {

      colorscheme = /*lua*/''
        return {
          {
            "folke/tokyonight.nvim",
            opts = {
              style = "moon",
            },
          },
        }
      '';

      vimtex = /*lua*/''
        return {
          -- basic setup for latex
          "lervag/vimtex",
          ft = "tex",
          lazy = false, -- we don't want to lazy load VimTeX
          -- tag = "v2.15", -- uncomment to pin to a specific release
          init = function()
            -- VimTeX configuration goes here, e.g.
            -- vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_view_general_viewer = "evince"
            vim.g.vimtex_compiler_method = "latexmk"

            vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", { desc = "vimtex-compile" })
            vim.keymap.set("n", "<leader>lc", ":VimtexCompile<CR>", { desc = "vimtex-clean-aux" })
          end,
        }
      '';

      vim-slime = /*lua*/''
        return {
          "jpalardy/vim-slime",
          -- lazy = false,
        }
      '';

      neo-tree = /*lua*/''
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

      julia-vim = /*lua*/''
        return {
          {
            "JuliaEditorSupport/julia-vim",
          },
        }
      '';

      lsp-config = /*lua*/''
        return {
          {
            "neovim/nvim-lspconfig",
            opts = {
              diagnostics = {
                virtual_text = false,
              },
              servers = {
                ltex = {
                  cmd = { "ltex-ls-plus" },
                  filetypes = { "tex", "markdown", "plaintex", "bib" },
                  settings = {
                    ltex = {
                      language = "en-US",
                      disabledRules = {
                        ["en-US"] = {
                          "UPPERCASE_SENTENCE_START",
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        }
      '';
    };
  };
}
