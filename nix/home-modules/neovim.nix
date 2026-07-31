{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withRuby = false;
    withPython3 = false;
    initLua =
      let
        plugins = with pkgs.vimPlugins; [
          # LazyVim
          LazyVim
          blink-cmp
          flash-nvim
          bufferline-nvim
          which-key-nvim
          tokyonight-nvim
          none-ls-nvim
          noice-nvim
          snacks-nvim
          neo-tree-nvim
          yanky-nvim
        ];
        mkEntryFromDrv = drv:
        if lib.isDerivation drv then
          { name = "${lib.getName drv}"; path = drv; }
        else
          drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in ''
        vim.g.mapleader = " "
        local keymap = vim.keymap.set
        -- keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
        -- vim.keymap.set("n", "<leader>:", ":", { desc = "Com mand mode" })


        local lazy = require('lazy')
        lazy.setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = true,
          },
          spec = {
            { 
              "LazyVim/LazyVim", 
              import = "lazyvim.plugins",
            },
            {
              "folke/tokyonight.nvim",
              lazy = true,
              opts = { style = "night" },
            },
            { import = "lazyvim.plugins.extras.lang.go" },
            { import = "lazyvim.plugins.extras.lang.json" },
            {
              "stevearc/aerial.nvim",
              event = "LazyFile",
              opts = function()
                local icons = vim.deepcopy(LazyVim.config.icons.kinds)

                -- HACK: fix lua's weird choice for `Package` for control
                -- structures like if/else/for/etc.
                icons.lua = { Package = icons.Control }

                ---@type table<string, string[]>|false
                local filter_kind = false
                if LazyVim.config.kind_filter then
                  filter_kind = assert(vim.deepcopy(LazyVim.config.kind_filter))
                  filter_kind._ = filter_kind.default
                  filter_kind.default = nil
                end

                local opts = {
                  attach_mode = "global",
                  backends = { "lsp", "treesitter", "markdown", "man" },
                  show_guides = true,
                  layout = {
                    resize_to_content = false,
                    win_opts = {
                      winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
                      signcolumn = "yes",
                      statuscolumn = " ",
                    },
                  },
                  icons = icons,
                  filter_kind = filter_kind,
                  -- stylua: ignore
                  guides = {
                    mid_item   = "├╴",
                    last_item  = "└╴",
                    nested_top = "│ ",
                    whitespace = "  ",
                  },
                }
                return opts
              end,
              keys = {
                { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
              },
            },
            {
              "folke/snacks.nvim",
              opts = {
                picker = {
                  hidden = true, -- This makes hidden files appear by default
                  ignored = true, -- Also show .gitignore files if needed
                },
              },
            }
          }
        })
      '';
    extraConfig = ''
      set nocompatible
      set nobackup
      set hidden
      set list
      set listchars=tab:↦\ ,trail:⬝
      set clipboard=unnamedplus
      set mouse=a
      set signcolumn=yes:2

      set relativenumber
      autocmd InsertEnter * :set number
      autocmd InsertLeave * :set relativenumber

      set scrolloff=8
      set sidescrolloff=8
      set updatetime=300
      
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l

      set laststatus=2
    '';
    plugins = with pkgs.vimPlugins; [
      ctrlp-vim
      lazy-nvim
    ];
  };
}
