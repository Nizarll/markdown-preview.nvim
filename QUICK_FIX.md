# Quick Fix - 3 Steps

## The Problem

You're still loading `iamcco/markdown-preview.nvim` (the original fork) instead of `Nizarll/markdown-preview.nvim` (the enhanced version with shadcn UI).

## The Solution

### Step 1: Find Your Plugin Config

Your lazy.nvim plugin config is likely in one of these locations:
```bash
~/.config/nvim/lua/plugins/markdown-preview.lua
~/.config/nvim/lua/plugins/init.lua
~/.config/nvim/lua/plugins.lua
~/.config/nvim/init.lua
```

Look for a line like:
```lua
"iamcco/markdown-preview.nvim"
```

### Step 2: Replace the Plugin

**REMOVE or comment out:**
```lua
-- OLD - Remove this:
{
  "iamcco/markdown-preview.nvim",
  ...
}
```

**ADD the new version:**
```lua
-- NEW - Add this:
{
  "Nizarll/markdown-preview.nvim",
  branch = "claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && npx --yes yarn install",
}
```

**Keep all your existing settings!** See `lazy-config-example.lua` for the complete config with your settings.

### Step 3: Clean & Reinstall

```bash
# 1. Close all Neovim instances
pkill -9 nvim

# 2. Start Neovim
nvim

# 3. In Neovim, run:
:Lazy clean
:Lazy sync

# 4. Wait for installation to complete (1-2 minutes)

# 5. Quit and manually build:
```

Then in your terminal:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./repair.sh
```

### Step 4: Test It

```bash
nvim test.md
```

Type some markdown:
```markdown
# Hello shadcn UI

This is ==highlighted text==.

- Beautiful typography
- Dark/light theme
- Inter font
```

Since you have `mkdp_auto_start = 1`, the preview should open automatically!

---

## Quick Verification Checklist

In Neovim, run these commands:

```vim
" Should show the NEW repo path:
:echo stdpath('data') . '/lazy/markdown-preview.nvim'

" Should return 2:
:echo exists(':MarkdownPreview')

" Should show 'Nizarll':
:! ls ~/.local/share/nvim/lazy/ | grep markdown
```

The directory should be `markdown-preview.nvim` and if you check:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
git remote -v
```

Should show: `https://github.com/Nizarll/markdown-preview.nvim.git`

---

## Still Not Working?

Run the diagnostic:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
./diagnose.sh
```

Check Neovim messages:
```vim
:messages
```

Kill any stuck processes:
```bash
pkill -9 node
```

Then try `:MarkdownPreview` again.
