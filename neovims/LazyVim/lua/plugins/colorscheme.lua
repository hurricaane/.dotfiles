-- Manage colorschemes for LazyVim
return {
  -- Add colorschemes
  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
  },
  -- Gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
  },
  -- Ayu theme
  {
    "Shatur/neovim-ayu",
  },
  -- Onedark theme
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
    },
  },
  -- Tokyodark theme
  {
    "tiagovla/tokyodark.nvim",
  },

  -- Change the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
