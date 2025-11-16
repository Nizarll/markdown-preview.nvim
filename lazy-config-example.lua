-- ============================================
-- PASTE THIS INTO YOUR LAZY.NVIM PLUGIN CONFIG
-- ============================================
--
-- Location: ~/.config/nvim/lua/plugins/markdown-preview.lua
-- (or wherever you define your lazy.nvim plugins)

return {
  -- REMOVE or COMMENT OUT the old plugin first!
  -- Look for: "iamcco/markdown-preview.nvim"

  -- NEW PLUGIN - Add this:
  {
    "Nizarll/markdown-preview.nvim",
    branch = "claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",

    -- Your existing config works perfectly - keep it!
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,

    config = function()
      -- All your existing settings stay here:
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_highlight_css = "/home/nizar/notes/css/index.css"

      -- Your custom browser function
      vim.cmd([[
        function! MkdpOpenBrowser(url)
          call jobstart(['firefox', '--new-tab', a:url], {'stdout_buffered': v:true, 'stderr_buffered': v:true})
        endfunction
      ]])

      vim.g.mkdp_browserfunc = "MkdpOpenBrowser"

      -- Theme auto-switching based on time
      local function update_theme()
        local hour = tonumber(os.date("%H"))
        if hour >= 18 or hour < 7 then
          vim.g.mkdp_theme = "dark"
        else
          vim.g.mkdp_theme = "light"
        end
      end

      vim.defer_fn(function()
        update_theme()
        vim.loop.new_timer():start(1800000, 1800000, vim.schedule_wrap(update_theme))
      end, 0)
    end,
  },
}
