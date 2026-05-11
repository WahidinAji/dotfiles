-- 0) Auto-install lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 1) Plugins
require("lazy").setup({
  {
    "rakr/vim-one",
    priority = 1000,  -- load first
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("one")
    end,
  },
})

vim.g.mapleader = " " --space leader

-- 2) Optional: toggle light/dark quickly
vim.keymap.set("n", "<leader>vl", function()
  vim.o.background = "light"; vim.cmd.colorscheme("one")
end, { desc = "One Light" })

vim.keymap.set("n", "<leader>vd", function()
  vim.o.background = "dark"; vim.cmd.colorscheme("one")
end, { desc = "One Dark" })

-- 3) Sensible basics (optional)
vim.o.termguicolors = true
vim.cmd("colorscheme one")
vim.o.background = "dark"
