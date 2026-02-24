# Neovim Configuration

Opinionated Neovim config optimized for fast navigation, minimal UI noise, and sane defaults.

![Screenshot](assets/screenshot.png)

## Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and efficient plugin management
- **LSP Support**: Full Language Server Protocol integration with native Neovim LSP
- **Autocompletion**: [blink.cmp](https://github.com/Saghen/blink.cmp) for fast, minimal completion
- **AI Assistance**: [Supermaven](https://supermaven.com/) integration for AI-powered code suggestions
- **File Explorer**: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) for intuitive file navigation
- **Fuzzy Finder**: [Telescope](https://github.com/nvim-telescope/telescope.nvim) with frecency + ui-select
- **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) + context window
- **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for Git decorations and hunks
- **Status Line**: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) with compact VSCode-inspired styling
- **Tab/Buffer Management**: [barbar.nvim](https://github.com/romgrk/barbar.nvim) + [bufstack.nvim](https://github.com/BibekBhusal0/bufstack.nvim)
- **Sessions**: [auto-session](https://github.com/rmagatti/auto-session) for restore/save
- **Debugging**: DAP UI + virtual text for Python debugging
- **Code Formatting**: Automatic code formatting with conform.nvim
- **Linting**: nvim-lint for real-time code linting
- **Comments**: [Comment.nvim](https://github.com/numToStr/Comment.nvim)
- **Scrollbar**: [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) with search + git markers
- **Search Enhancement**: [nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens) for better search highlighting
- **Git Conflict Resolution**: [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) for resolving merge conflicts
- **Cmdline UI**: [cmdline.nvim](https://github.com/vzze/cmdline.nvim) fuzzy command line
- **Color Preview**: [nvim-colorizer](https://github.com/catgoose/nvim-colorizer.lua)
- **Lazygit Integration**: [Snacks.nvim](https://github.com/folke/snacks.nvim) with `nvr` for file jumps
- **Theme**: [vscode.nvim](https://github.com/Mofiqul/vscode.nvim) with custom highlight overrides
- **Clipboard**: OSC 52 clipboard support for remote environments
- **Sensitive Files**: Automatic filetype for secrets to disable inline AI completions

## Structure

```
.
├── init.lua                 # Entry point
├── lua/
│   ├── plugins/
│   │   ├── init.lua        # Lazy.nvim bootstrap + plugin list
│   │   ├── barbar.lua      # Buffer tabs
│   │   ├── blink.lua       # Completion
│   │   ├── bufstack.lua    # Buffer stack
│   │   ├── cmdline.lua     # Cmdline UI
│   │   ├── colorizer.lua   # Color preview
│   │   ├── comment.lua     # Comment toggles
│   │   ├── conflict.lua    # Git conflict helpers
│   │   ├── debug.lua       # DAP + UI
│   │   ├── format.lua      # Formatting (conform.nvim)
│   │   ├── gitsigns.lua    # Git signs
│   │   ├── hlslens.lua     # Search lens
│   │   ├── lint.lua        # Linting
│   │   ├── lsp.lua         # LSP config
│   │   ├── lualine.lua     # Status line
│   │   ├── neotree.lua     # File explorer
│   │   ├── scrollbar.lua   # Scrollbar
│   │   ├── session.lua     # Auto sessions
│   │   ├── snacks.lua      # Lazygit + utilities
│   │   ├── supermaven.lua  # AI suggestions
│   │   ├── telescope.lua   # Finder
│   │   └── treesitter.lua  # Treesitter + context
│   ├── settings.lua        # Neovim settings
│   ├── themes/
│   │   ├── utils.lua       # Theme helpers
│   │   └── vscode.lua      # VSCode theme overrides
│   └── utils/
│       ├── get_json_env.lua # JSON env helper
│       └── init.lua         # Utils entry
└── assets/
    └── screenshot.png      # Screenshot
```

## Installation

### Prerequisites

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for proper icon display
- ripgrep (for Telescope live grep)
- fd (for Telescope file finder)
- make (for telescope-fzf-native build)
- lazygit
- nvr (for Lazygit integration)
- delta (optional, for Lazygit paging)

### Optional tooling

- **LSP servers**: `ty`, `lua_ls`, `gopls`, `rust_analyzer`, `tsserver`, `jsonls`, `codebook`, `nixd`
- **Formatters**: `stylua`, `ruff`, `rustfmt`, `goimports`, `gofmt`, `prettierd`/`prettier`, `taplo`, `nixfmt`
- **Linters**: `ruff`, `clippy`, `golangci-lint`, `eslint`
- **Debugging (Python)**: `debugpy`

### Install

1. Backup your existing Neovim configuration (if any):

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this repository:

```bash
git clone git@github.com:catvitalio/nvim-config.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

## Key Bindings (highlights)

- `Alt+e`: Neo-tree (float reveal)
- `Alt+p`: Telescope frecency (cwd)
- `Alt+f`: Telescope live grep
- `Alt+g`: Lazygit (Snacks)
- `Alt+.`: LSP code action
- `Alt+s`: Format + save
- `Alt+[`, `Alt+]`: Buffer prev/next
- `Alt+1..0`: Buffer goto
- `Alt+w`: Buffer close
- `Alt+S-w`: Buffer close force
- `Alt+S-t`: Buffer reopen
- `Alt+d`: DAP UI toggle
- `Alt+b`: DAP breakpoint toggle
- `F5`, `Shift+F5`: DAP continue/terminate
