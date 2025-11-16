# Installation Guide - shadcn UI Typography Edition

## For lazy.nvim Users on Linux

### One-Command Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Nizarll/markdown-preview.nvim/claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T/install-lazy.sh | bash
```

Or download and run:

```bash
wget https://raw.githubusercontent.com/Nizarll/markdown-preview.nvim/claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T/install-lazy.sh
chmod +x install-lazy.sh
./install-lazy.sh
```

Or clone and install:

```bash
git clone --branch claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T https://github.com/Nizarll/markdown-preview.nvim.git
cd markdown-preview.nvim
./install-lazy.sh
```

### What the Script Does

The installation script automatically:

1. ✅ Checks system requirements (Node.js, npm, git, Neovim)
2. ✅ Detects your lazy.nvim installation
3. ✅ Kills any stuck markdown-preview processes
4. ✅ Backs up your existing installation (if any)
5. ✅ Clones/updates to the latest version
6. ✅ Cleans old build artifacts
7. ✅ Installs root dependencies (yarn)
8. ✅ Installs app dependencies (npm)
9. ✅ Compiles TypeScript
10. ✅ Builds Next.js app with correct Node options
11. ✅ Verifies installation (8 checks)
12. ✅ Provides configuration instructions

### After Running the Script

**1. Update Your Neovim Config**

Add this to your lazy.nvim plugin configuration:

```lua
-- File: ~/.config/nvim/lua/plugins/markdown-preview.lua
return {
  "Nizarll/markdown-preview.nvim",
  branch = "claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && npx --yes yarn install",

  config = function()
    -- Your settings here (keep your existing config!)
    vim.g.mkdp_auto_start = 1
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_filetypes = { "markdown" }
    -- ... etc
  end,
}
```

**Important:** Remove any old `"iamcco/markdown-preview.nvim"` entries!

**2. Sync lazy.nvim**

```vim
:Lazy sync
```

**3. Test It**

```bash
nvim test.md
```

Type some markdown:
```markdown
# Hello shadcn UI

This is a paragraph with ==highlighted text==.

## Features
- Beautiful typography
- Dark/light theme
- Inter font
```

Run `:MarkdownPreview` - it should open in your browser!

---

## Features

### 🎨 shadcn UI Typography
- Professional typography following shadcn UI design system
- New York color theme (clean, modern aesthetic)
- Inter font family (loaded from Google Fonts)
- JetBrains Mono for code blocks

### 🌓 Dark/Light Theme
- Automatic theme detection based on system preferences
- Manual toggle in preview header (hover to reveal)
- Smooth transitions between themes
- Optimized colors for both modes

### ✨ Text Highlighting
- Use `==highlighted text==` syntax
- Renders with yellow background (light) or gold (dark)
- Works seamlessly with other markdown features

### 📱 Responsive Design
- Mobile-friendly typography
- Adaptive font sizes
- Optimized for all screen sizes

### 🎯 Enhanced Features
- Beautiful code blocks with custom scrollbars
- Clean table styling
- Proper heading hierarchy
- List styling improvements
- Print-friendly styles

---

## Verification

### In Neovim

```vim
" Should return 2
:echo exists(':MarkdownPreview')

" Check for errors
:messages

" View plugin info
:Lazy
```

### In Terminal

```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim

# Run diagnostics
./diagnose.sh

# Check git remote (should show Nizarll)
git remote -v

# Verify files exist
ls -la app/_static/shadcn-typography.css
ls -la app/out/index.html
```

---

## Troubleshooting

### Preview doesn't open

1. **Check command exists:**
   ```vim
   :echo exists(':MarkdownPreview')
   ```
   Should return `2`

2. **Check configuration:**
   - Make sure you updated your Neovim config
   - Removed old `iamcco/markdown-preview.nvim` entry
   - Added new `Nizarll/markdown-preview.nvim` entry
   - Ran `:Lazy sync`

3. **Restart Neovim:**
   ```bash
   pkill -9 nvim
   nvim
   ```

4. **Check for errors:**
   ```vim
   :messages
   ```

### Old styles showing

1. **Clear browser cache:**
   - Press `Ctrl+Shift+R` in browser
   - Or clear cache manually

2. **Verify CSS file:**
   ```bash
   ls ~/.local/share/nvim/lazy/markdown-preview.nvim/app/_static/shadcn-typography.css
   cat ~/.local/share/nvim/lazy/markdown-preview.nvim/app/out/index.html | grep shadcn
   ```

3. **Rebuild:**
   ```bash
   cd ~/.local/share/nvim/lazy/markdown-preview.nvim
   ./repair.sh
   ```

### Command not found

1. **Check lazy.nvim loaded it:**
   ```vim
   :Lazy
   ```
   Look for `markdown-preview.nvim` in the list

2. **Reload plugin:**
   ```vim
   :Lazy reload markdown-preview.nvim
   ```

3. **Check file type:**
   ```vim
   :set filetype?
   ```
   Should be `markdown`

### Build failures

1. **Node version too old:**
   ```bash
   node --version  # Should be v14+
   ```

2. **Missing dependencies:**
   ```bash
   cd ~/.local/share/nvim/lazy/markdown-preview.nvim
   npx --yes yarn install
   cd app && npm install
   ```

3. **OpenSSL errors:**
   ```bash
   export NODE_OPTIONS="--openssl-legacy-provider"
   cd ~/.local/share/nvim/lazy/markdown-preview.nvim
   ./repair.sh
   ```

---

## Manual Installation (Alternative)

If the script doesn't work for some reason:

```bash
# 1. Clone to lazy.nvim directory
cd ~/.local/share/nvim/lazy
git clone --branch claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T \
  https://github.com/Nizarll/markdown-preview.nvim.git

# 2. Install dependencies
cd markdown-preview.nvim
npx --yes yarn install
cd app && npm install && cd ..

# 3. Build
npm run build-lib
export NODE_OPTIONS="--openssl-legacy-provider"
cd app && npx next build && npx next export
```

---

## Additional Scripts

### repair.sh
Fixes broken installations:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./repair.sh
```

### diagnose.sh
Checks installation health:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./diagnose.sh
```

---

## Requirements

- **OS:** Linux (tested on Ubuntu, Fedora, Arch)
- **Node.js:** v14.0.0 or higher
- **npm:** v6.0.0 or higher
- **Neovim:** v0.5.0 or higher
- **Plugin Manager:** lazy.nvim
- **Browser:** Any modern browser (Firefox, Chrome, Safari, etc.)

---

## Support

- **Issues:** Open an issue on GitHub
- **Documentation:** Check `QUICK_FIX.md` for common problems
- **Diagnostics:** Run `./diagnose.sh` for automated checks

---

## What's New

Compared to the original `iamcco/markdown-preview.nvim`:

- ✨ shadcn UI typography system
- ✨ New York color theme
- ✨ Dark/light mode support
- ✨ Text highlighting with `==text==`
- ✨ Inter font family
- ✨ Enhanced code block styling
- ✨ Responsive design
- ✨ Print-friendly styles
- ✨ Better table styling
- ✨ Custom scrollbars
- ✨ Smooth theme transitions

---

## License

MIT License - Same as original markdown-preview.nvim

---

**Enjoy your beautiful markdown previews! 🎉**
