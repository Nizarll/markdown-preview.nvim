# Installation Guide for lazy.nvim

## Step-by-Step Installation

### 1. Remove Old Installation

```bash
# Close all Neovim instances first!
pkill -9 nvim
pkill -9 node

# Remove the old plugin
rm -rf ~/.local/share/nvim/lazy/markdown-preview.nvim
```

### 2. Update Your lazy.nvim Config

Edit your lazy.nvim plugin configuration (usually in `~/.config/nvim/lua/plugins/` or similar):

**Remove or comment out the old plugin:**
```lua
-- OLD - Remove this:
-- {
--   "iamcco/markdown-preview.nvim",
--   ...
-- }
```

**Add the new forked version:**
```lua
{
  "Nizarll/markdown-preview.nvim",
  branch = "claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    -- Install dependencies
    vim.fn.system("cd app && npx --yes yarn install")
    -- Build the app
    vim.fn.system([[
      export NODE_OPTIONS="--openssl-legacy-provider" &&
      npm run build-lib &&
      cd app &&
      npx next build &&
      npx next export
    ]])
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
```

### 3. Install via lazy.nvim

Open Neovim and run:
```vim
:Lazy clean
:Lazy install
```

Wait for the installation and build to complete (may take 1-2 minutes).

### 4. Alternative: Manual Build

If the automatic build fails, install manually:

```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./repair.sh
```

### 5. Verify Installation

In Neovim:
```vim
" Check command exists
:echo exists(':MarkdownPreview')
" Should return: 2

" Check plugin path
:echo stdpath('data') . '/lazy/markdown-preview.nvim'

" Check for errors
:messages

" Test it
:MarkdownPreview
```

## Your Existing Config

You already have this in your config, which is perfect:
```lua
vim.g.mkdp_auto_start = 1
vim.g.mkdp_auto_close = 1
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_browserfunc = "MkdpOpenBrowser"
```

Keep all of that! Just update the plugin source.

## Testing

1. Create a test file:
```bash
nvim ~/test.md
```

2. Add content:
```markdown
# Test shadcn Typography

This is a paragraph with ==highlighted text==.

## Features

- Dark/light theme
- Inter font
- Beautiful styles
```

3. The preview should auto-open (since `g:mkdp_auto_start = 1`)
4. Hover over header to see theme toggle
5. Try `==highlighting==` syntax

## Troubleshooting

**If preview doesn't open:**
```bash
# Check for errors
tail -f ~/.local/state/nvim/log

# Kill stuck processes
pkill -9 node

# Rebuild manually
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./repair.sh
```

**If you see the old styles:**
- Clear browser cache (Ctrl+Shift+R)
- Check that `shadcn-typography.css` exists:
  ```bash
  ls ~/.local/share/nvim/lazy/markdown-preview.nvim/app/_static/shadcn-typography.css
  ```

**If command doesn't exist:**
```vim
:Lazy reload markdown-preview.nvim
```

## What You Should See

✅ Preview opens in Firefox
✅ Inter font family
✅ Clean, modern typography
✅ Dark/light theme toggle in header
✅ Yellow highlighting for `==text==`
✅ Responsive design
