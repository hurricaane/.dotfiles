local configs = require("nvim-treesitter.configs")
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()

-- Treesitter configuration
configs.setup {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "c",
    "markdown",
    "markdown_inline",
    "yaml",
    "make",
    "go",
    "bash",
    "python",
    "help",
    "json",
    "hcl",
    "dockerfile",
    "terraform",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/msvechla/tree-sitter-go-template",
    branch = "fix_brackets",
    files = {"src/parser.c"},
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl"},
}
