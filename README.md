# My Neovim Configuration

A simple,feature-rich Neovim configuration.

## Features
- **File Exploration**: `neo-tree.nvim` for intuitive navigation.
- **Fuzzy Finding**: `telescope.nvim` for searching files, buffers, and symbols.
- **AI-Powered**: Integrated with `supermaven-nvim` for intelligent coding assistance.
- **Bufferline**: `bufferline.nvim` for modern, tab-like buffer management.
- **Language Support**: Pre-configured LSP for Lua, TypeScript, JavaScript, Go, Rust, Prisma, and more.

## Prerequisites
- **Neovim 0.10+** (0.11 recommended).
- **Nerd Font**: Required for icons. Download from [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (JetBrainsMono is recommended).
- **Core Tools**: `git`, `make`, `unzip`, and a C compiler (`gcc`).
- **Search Tools**: `ripgrep` and `fd`.

## Installation

> [!NOTE]
> Backup your previous configuration (if any exists).

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

### Clone the repository

#### Linux and Mac
```bash
git clone https://github.com/shemaikuzwe/my-neovim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

#### Windows
If you're using `cmd.exe`:
```cmd
git clone https://github.com/shemaikuzwe/my-neovim-config.git "%localappdata%\nvim"
```

If you're using `powershell.exe`:
```powershell
git clone https://github.com/shemaikuzwe/my-neovim-config.git "$env:LOCALAPPDATA\nvim"
```

Then simply start Neovim:

```bash
nvim
```

Plugins and LSPs will be automatically installed on the first run.
