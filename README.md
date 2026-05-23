# nvim

Personal Neovim configuration for Python, Lua, C/C++, HTML/CSS/JS/TS,
Bash/Zsh, JSON, and LaTeX. Built on Neovim's native LSP client (no
`nvim-lspconfig`), `lazy.nvim` for plugin management, and Treesitter for
syntax highlighting.

**Requires Neovim 0.12+ on Ubuntu / WSL2 (x86-64).**

---

## Language support

| Language | Treesitter | LSP server | Linter / formatter |
|---|---|---|---|
| Python | ✓ | pyright (types) · ruff (lint) | ruff\_format |
| C / C++ | ✓ | clangd | clang-format |
| JavaScript | ✓ | ts\_ls | prettier |
| TypeScript | ✓ | ts\_ls | prettier |
| HTML | ✓ | html | prettier |
| CSS | ✓ | cssls | prettier |
| Lua | ✓ | lua\_ls | stylua |
| Bash / sh | ✓ | bashls + shellcheck | — |
| Zsh | ✓ (bash parser) | bashls (completion/hover only¹) | — |
| JSON / JSONC | ✓ | jsonls | — |
| LaTeX | VimTeX | texlab | — |
| Markdown | ✓ | — | — |

> ¹ shellcheck does not support zsh syntax; diagnostics are unavailable for
> `.zsh` files. Completion, hover, and go-to-definition still work.

---

## Features

- **Native LSP** — configured via `lsp/*.lua` + `ftplugin/*.lua` using
  `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11+ API, no wrapper plugin).
- **Treesitter** — `nvim-treesitter` main branch. Parsers install automatically
  on first launch. Zsh reuses the bash parser via a language alias.
- **Format on save** — `conform.nvim` with per-language formatters and
  buffer/global toggle commands.
- **Autocompletion** — `blink.cmp` with LSP, buffer, path, and snippet sources.
  VimTeX omnifunc wired in for LaTeX.
- **HTML tag auto-close/rename** — `nvim-ts-autotag` auto-inserts closing tags
  on `>` and keeps paired tags in sync when one is renamed.
- **LaTeX workflow** — VimTeX + Zathura with SyncTeX forward/inverse search.
- **Fuzzy finding** — Telescope for files, live grep, buffers, help, and recent
  files.
- **Git integration** — Gitsigns for hunk navigation and inline blame.
- **Soft wrap** — long lines wrap visually at the window edge (`wrap`,
  `linebreak`, `breakindent`); no newlines are inserted into the file.

---

## Setup

### 1. Clone

```bash
git clone https://github.com/lazyinspirit/neovim-configuration-x86 ~/.config/nvim
```

On first launch `nvim` bootstraps `lazy.nvim`, installs all plugins, and
downloads the required Treesitter parsers (allow ~30 s).

### 2. Install external tools

LSP servers and formatters are **not** fully auto-installed — they live outside
the config directory. Install everything below before opening files.

```bash
# Core utilities
sudo apt install -y ripgrep fd-find fzf clangd shellcheck \
                    texlab latexmk zathura npm python3-pip wl-clipboard

# fd symlink (Ubuntu ships the binary as fdfind)
mkdir -p ~/.local/bin && ln -sf /usr/bin/fdfind ~/.local/bin/fd

# npm: point global prefix to ~/.local to avoid sudo
npm config set prefix ~/.local

# JS / TS / HTML / CSS / JSON + formatters
npm install -g typescript typescript-language-server \
               vscode-langservers-extracted prettier bash-language-server \
               pyright neovim

# Python
pip3 install --user --break-system-packages ruff neovim

# Lua formatter (pre-built binary, no Rust required)
STYLUA=$(curl -s https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest \
         | grep tag_name | cut -d'"' -f4)
curl -sL "https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA}/stylua-linux-x86_64.zip" \
  | python3 -c "import sys,zipfile,io; zipfile.ZipFile(io.BytesIO(sys.stdin.buffer.read())).extract('stylua','$HOME/.local/bin')"
chmod +x ~/.local/bin/stylua
```

Confirm LSP attachment with `:LspInfo` after opening a file of the relevant type.

### 3. Lua language server (via Mason)

`lua-language-server` is not in the Ubuntu apt repos. Install it from inside
Neovim after the first launch:

```
:MasonInstall lua-language-server
```

Mason downloads a pre-built binary and makes it available to Neovim automatically.

### 4. LaTeX + Zathura (optional)

Zathura is installed in step 2. SyncTeX forward search works out of the box
via `<Space>lv`. For inverse search (click in Zathura → jump to source), add
the following to your Zathura config (`~/.config/zathura/zathurarc`):

```
set synctex true
set synctex-editor-command "nvim --server /tmp/vimtexserver.txt --remote-send '<C-\><C-n>:e %{input}<CR>%{line}G'"
```

---

## Keymaps

Leader key: `<Space>`

### LSP (active when a server is attached)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | List references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` (insert) | Signature help |
| `<Leader>rn` | Rename symbol |
| `<Leader>ca` | Code action |
| `<Leader>f` | Format buffer |

### Diagnostics

| Key | Action |
|---|---|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Leader>e` | Show diagnostic float |
| `<Leader>dq` | Send diagnostics to loclist |

### Telescope

| Key | Action |
|---|---|
| `<Leader>ff` | Find files |
| `<Leader>fg` | Live grep |
| `<Leader>fb` | Buffers |
| `<Leader>fh` | Help tags |
| `<Leader>fr` | Recent files |

### Git (Gitsigns)

| Key | Action |
|---|---|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<Leader>gp` | Preview hunk |
| `<Leader>gb` | Blame line |

### File tree (neo-tree)

| Key | Action |
|---|---|
| `<Leader>tt` | Toggle file tree |
| `<Leader>tf` | Reveal current file in tree |
| `<Leader>tg` | Toggle git status panel |
| `<C-w>h` / `<C-w>l` | Move focus left / right between tree and editor |

In-tree file operations: `a` create, `d` delete, `r` rename, `y` copy, `x` cut, `p` paste, `?` full keymap.

### LaTeX (VimTeX — `.tex` files only)

| Key | Action |
|---|---|
| `<Space>ll` | Start / stop compiler |
| `<Space>lv` | Forward search (Zathura) |
| `<Space>lk` | Stop compiler |
| `<Space>le` | Open error list |
| `<Space>lc` | Clean auxiliary files |
| `<Space>lt` | Toggle table of contents |

### Format toggle

| Command | Effect |
|---|---|
| `:FormatDisable` | Disable format-on-save for this buffer |
| `:FormatDisable!` | Disable format-on-save globally |
| `:FormatEnable` | Re-enable format-on-save |

---

## Plugin inventory

| Plugin | Role |
|---|---|
| `folke/lazy.nvim` | Plugin manager |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting + indentation |
| `navarasu/onedark.nvim` | Colorscheme (pure-black variant) |
| `nvim-lualine/lualine.nvim` | Status line |
| `nvim-neo-tree/neo-tree.nvim` | File explorer with git status panel |
| `nvim-tree/nvim-web-devicons` | File type icons (neo-tree dependency) |
| `MunifTanjim/nui.nvim` | UI component library (neo-tree dependency) |
| `nvim-telescope/telescope.nvim` | Fuzzy finder |
| `lewis6991/gitsigns.nvim` | Git hunk signs + blame |
| `saghen/blink.cmp` | Autocompletion |
| `stevearc/conform.nvim` | Format on save |
| `williamboman/mason.nvim` | LSP / tool installer UI |
| `windwp/nvim-ts-autotag` | HTML/JSX/TSX tag auto-close and paired rename |
| `lervag/vimtex` | LaTeX editing, compilation, SyncTeX |
