{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra
    nil
    ripgrep
    black
    codespell
    shfmt

    (inputs.nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvim {
      #colorschemes.catppuccin.enable = true;
      autoCmd = [
        {
          event = ["TextYankPost"];
          pattern = ["*"];
          command = "silent! lua vim.highlight.on_yank()";
        }
        {
          event = ["BufEnter"];
          pattern = ["github.com_*.txt"];
          command = "set filetype=markdown";
        }
      ];

      extraConfigLua = ''
        vim.loop.fs_mkdir(vim.o.backupdir, 750)
        vim.loop.fs_mkdir(vim.o.directory, 750)
        vim.loop.fs_mkdir(vim.o.undodir, 750)

        vim.o.backupdir = vim.fn.stdpath("data") .. "/backup"    -- set backup directory to be a subdirectory of data to ensure that backups are not written to git repos
        vim.o.directory = vim.fn.stdpath("data") .. "/directory" -- Configure 'directory' to ensure that Neovim swap files are not written to repos.
        vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
        vim.o.undodir = vim.fn.stdpath("data") .. "/undo" -- set undodir to ensure that the undofiles are not saved to git repos.
      '';
      plugins = {
        lightline.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        ts-autotag.enable = true;
        nvim-autopairs.enable = true;
        persistence.enable = true;
        telescope = {
          enable = true;
          extensions = {
            fzf-native = {
              enable = true;
            };
          };
        };
        toggleterm = {
          enable = true;
          settings = {
            hide_numbers = true;
            autochdir = true;
            close_on_exit = true;
            direction = "vertical";
          };
        };
        none-ls = {
          enable = true;
          settings = {
            cmd = ["bash -c nvim"];
            debug = true;
          };
          sources = {
            diagnostics = {
              deadnix.enable = true;
            };
            formatting = {
              alejandra.enable = true;
              shfmt.enable = true;
              nixpkgs_fmt.enable = true;
            };
            completion = {
              luasnip.enable = true;
              spell.enable = true;
            };
          };
        };
        nix.enable = true;
        conform-nvim = {
          enable = true;

          settings = {
            formatters = {
              codespell = {
                prepend_args = ["-L" "crate"];
              };
            };

            formatters_by_ft = {
              "_" = ["trim_whitespace"];
              "*" = ["codespell"];
              json = ["jq"];
              nix = ["alejandra"];
              sh = ["shfmt"];
            };

            format_on_save = ''
              function(bufnr)
               local ignore_filetypes = { "helm" }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                  return
                end

                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
                end

                -- Disable autoformat for files in a certain path
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match("/node_modules/") then
                  return
                end
                return { timeout_ms = 1000, lsp_fallback = true }
              end
            '';
          };
        };
        # Language server
        lsp = {
          enable = true;
          servers = {
            html.enable = true; # HTML
            nil-ls.enable = true; # Nix
            dockerls.enable = true; # Docker
            bashls.enable = true; # Bash
            yamlls.enable = true; # YAML
          };
        };
        nvim-ufo.enable = true;
        cmp = {
          enable = true;
          settings = {
            autoEnableSources = true;
            experimental = {ghost_text = true;};
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            snippet = {expand = "luasnip";};
            formatting = {fields = ["kind" "abbr" "menu"];};
            sources = [
              {name = "nvim_lsp";}
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
              }
              # { name = "copilot"; } # enable/disable copilot
              {
                name = "path"; # file system paths
                keywordLength = 3;
              }
              {
                name = "luasnip"; # snippets
                keywordLength = 3;
              }
            ];

            window = {
              completion = {border = "solid";};
              documentation = {border = "solid";};
            };

            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
          };
        };
        cmp-nvim-lsp = {
          enable = true; # LSP
        };
        cmp-buffer = {
          enable = true;
        };
        cmp-path = {
          enable = true; # file system paths
        };
        cmp_luasnip = {
          enable = true; # snippets
        };
        cmp-cmdline = {
          enable = true; # autocomplete for cmdline
        };

        lspkind = {
          enable = true;
          extraOptions = {
            maxwidth = 50;
            ellipsis_char = "...";
          };
        };
        tmux-navigator.enable = true;

        schemastore = {
          enable = true;
          yaml.enable = true;
          json.enable = false;
        };

        # Code snippets
        luasnip = {
          enable = true;
          #extraConfig = {
          #  enable_autosnippets = true;
          #  store_selection_keys = "<Tab>";
          #};
        };
      };

      opts = {
        # foldexpr = "v:lua.vim.treesitter.foldexpr()";
        # foldmethod = "expr";
        # foldmethod = "manual";
        # foldtext = "v:lua.vim.treesitter.foldtext()";
        autoindent = true;
        backspace = "indent,eol,start";
        backup = true;
        cmdheight = 2;
        colorcolumn = "80";
        completeopt = "menu,menuone,noselect";
        conceallevel = 0;
        cursorline = true;
        expandtab = true;
        foldcolumn = "1";
        foldenable = true;
        foldlevel = 5;
        foldlevelstart = 99;
        ignorecase = true;
        laststatus = 3;
        mouse = "a";
        number = true;
        pumheight = 0;
        relativenumber = true;
        shiftwidth = 2;
        showtabline = 1;
        signcolumn = "no";
        smartcase = true;
        tabstop = 2;
        termguicolors = true;
        timeoutlen = 300;
        undofile = true;
        updatetime = 300;
        wrap = false;
        writebackup = true;
      };

      globals.mapleader = " ";

      # Telescope bindings
      keymaps = [
        {
          action = "<cmd>Telescope live_grep<CR>";
          key = "<leader>fg";
        }
        {
          action = "<cmd>Telescope find_files<CR>";
          key = "<leader>ff";
        }
        {
          action = "<cmd>Telescope oldfiles<CR>";
          key = "<leader>fh";
        }
        {
          action = "<cmd>Telescope colorscheme<CR>";
          key = "<leader>ch";
        }
        {
          action = "<cmd>Telescope man_pages<CR>";
          key = "<leader>fm";
        }

        # Buffer navigation
        {
          mode = "n";
          action = ":bnext<CR>";
          key = "<Tab>";
          options.silent = true;
        }
        {
          mode = "n";
          action = ":bnext<CR>";
          key = "<S-Tab>";
          options.silent = true;
        }
        {
          mode = "n";
          action = ":bd!<CR>";
          key = "<leader>bd";
          options.silent = true;
        }
      ];
    })
  ];
}
