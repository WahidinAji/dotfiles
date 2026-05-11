------------------------------------------------------------
-- 0) Auto-install lazy.nvim (plugin manager)
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- 1) Plugins
------------------------------------------------------------
require("lazy").setup({ ----------------------------------------------------------
-- vim-one colorscheme
----------------------------------------------------------
{
    "rakr/vim-one",
    priority = 1000,
    config = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("one")
    end
}, ----------------------------------------------------------
-- Neo-tree file explorer + nesting config
----------------------------------------------------------
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim",
                    "saifulapm/neotree-file-nesting-config" -- the plugin you want
    },
    config = function()
        -- Load the file nesting rules
        local nesting_rules = require("neotree-file-nesting-config").nesting_rules
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true -- show hidden files too
                },
                nesting_rules = nesting_rules
            }
        })

        -- Optional keymap to toggle Neo-tree
        vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
            desc = "Toggle Neo-tree"
        })

        -- Shortcut: Command + B to toggle Neo-tree (like VSCode)
        vim.keymap.set("n", "<D-b>", ":Neotree toggle<CR>", {
            desc = "Toggle Neo-tree (Cmd+B)"
        })
    end
}, {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("bufferline").setup({
            options = {
                diagnostics = "nvim_lsp",
                separator_style = "slant",
                offsets = {{
                    filetype = "neo-tree",
                    text = "Explorer",
                    text_align = "left",
                    separator = true
                }},
                show_buffer_close_icons = false,
                show_close_icon = false,
                always_show_bufferline = true
            }
        })
    end
} ----------------------------------------------------------
-- Buffer tabs (like LazyVim)
----------------------------------------------------------
})

------------------------------------------------------------
-- 2) Basic settings
------------------------------------------------------------
vim.g.mapleader = " "
vim.o.termguicolors = true

------------------------------------------------------------
-- 3) Cursor setup
------------------------------------------------------------
vim.opt.guicursor = table.concat({"n-v-c:block-Cursor/lCursor", "i-ci-ve:ver25-Cursor/lCursor",
                                  "r-cr:hor20-Cursor/lCursor", "o:hor50-Cursor/lCursor", "sm:block-Cursor/lCursor"}, ",")

local function apply_cursor_colors()
    if vim.o.background == "light" then
        vim.api.nvim_set_hl(0, "Cursor", {
            bg = "#000000",
            fg = "#ffffff"
        })
        vim.api.nvim_set_hl(0, "lCursor", {
            bg = "#000000",
            fg = "#ffffff"
        })
        vim.api.nvim_set_hl(0, "TermCursor", {
            bg = "#000000",
            fg = "#ffffff"
        })
    else
        vim.api.nvim_set_hl(0, "Cursor", {
            bg = "#ffffff",
            fg = "#000000"
        })
        vim.api.nvim_set_hl(0, "lCursor", {
            bg = "#ffffff",
            fg = "#000000"
        })
        vim.api.nvim_set_hl(0, "TermCursor", {
            bg = "#ffffff",
            fg = "#000000"
        })
    end
end

vim.api.nvim_create_autocmd({"ColorScheme", "OptionSet"}, {
    pattern = {"one", "background"},
    callback = apply_cursor_colors
})

apply_cursor_colors()

------------------------------------------------------------
-- 4) Theme toggle shortcuts
------------------------------------------------------------
vim.keymap.set("n", "<leader>vl", function()
    vim.o.background = "light"
    vim.cmd("colorscheme one")
    vim.schedule(apply_cursor_colors)
end, {
    desc = "One Light"
})

vim.keymap.set("n", "<leader>vd", function()
    vim.o.background = "dark"
    vim.cmd("colorscheme one")
    vim.schedule(apply_cursor_colors)
end, {
    desc = "One Dark"
})

------------------------------------------------------------
-- 5) Default theme on startup
------------------------------------------------------------
vim.o.background = "dark"
vim.cmd("colorscheme one")

------------------------------------------------------------
-- 6) System clipboard + custom shortcuts (mac-style)
------------------------------------------------------------

-- Use the macOS system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- NOTE about ⌘ (Command) keys:
-- - They work natively in GUI Neovim (Neovide, goneovim, MacVim, etc.) using <D-…>.
-- - In a terminal (iTerm/Terminal/Alacritty/Kitty), Neovim usually CAN'T see the Command key.
--   If you want ⌘C/⌘V there, set your terminal to send the keys to Neovim (or use Option B below).
--   iTerm2 example: Preferences → Keys → create mappings that send the sequences you want.

-- === Paste (⌘V) ===
-- Normal/Visual mode: paste from system clipboard
vim.keymap.set({"n", "x"}, "<D-v>", '"+p', {
    desc = "Paste (system clipboard)"
})
-- Insert/Command mode: insert from system clipboard
vim.keymap.set("i", "<D-v>", function()
    return "<C-r>+"
end, {
    expr = true,
    desc = "Paste (system clipboard)"
})
vim.keymap.set("c", "<D-v>", function()
    return "<C-r>+"
end, {
    expr = true,
    desc = "Paste (system clipboard)"
})

-- === Copy (⌘C) ===
-- Normal mode: copy (yank) current line to system clipboard
vim.keymap.set("n", "<D-c>", '"+yy', {
    desc = "Copy line (system clipboard)"
})
-- Visual mode: copy selection to system clipboard
vim.keymap.set("x", "<D-c>", '"+y', {
    desc = "Copy selection (system clipboard)"
})

-- Cut (⌘X)
vim.keymap.set("n", "<D-x>", '"+dd', {
    desc = "Cut line (system clipboard)"
})
vim.keymap.set("x", "<D-x>", '"+d', {
    desc = "Cut selection (system clipboard)"
})

------------------------------------------------------------
-- 7) Selection with Shift + Arrow Right
------------------------------------------------------------
-- Select from cursor to end of *line*
vim.keymap.set("n", "<S-Right>", "v$", {
    desc = "Select to end of line"
})
vim.keymap.set("x", "<S-Right>", "$", {
    desc = "Extend selection to end of line"
})

-- "Shift + Arrow Left" to do the opposite (select to start of line)
vim.keymap.set("n", "<S-Left>", "v0", {
    desc = "Select to start of line"
})
vim.keymap.set("x", "<S-Left>", "0", {
    desc = "Extend selection to start of line"
})

------------------------------------------------------------
-- 8) Integrated terminal (zsh) – toggle + resize
------------------------------------------------------------

-- Config
local TERM_HEIGHT = 15

-- Keep track of the terminal window/buffer so we can truly toggle it
local term_win = nil
local term_buf = nil

local function is_valid(win)
    return win and vim.api.nvim_win_is_valid(win)
end

local function open_terminal()
    -- Use zsh explicitly; fallback to $SHELL/vim.o.shell if needed
    local shell = "/bin/zsh"
    if vim.fn.executable(shell) == 0 then
        shell = vim.env.SHELL or vim.o.shell
    end

    -- Open split at bottom, set height, and start terminal
    vim.cmd("botright split")
    vim.cmd("resize " .. TERM_HEIGHT)
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.fn.termopen(shell)
    vim.cmd("startinsert")
end

local function close_terminal()
    if is_valid(term_win) then
        vim.api.nvim_win_close(term_win, true)
    end
    term_win = nil
end

local function toggle_terminal()
    if is_valid(term_win) then
        close_terminal()
    else
        open_terminal()
    end
end

-- Toggle: Ctrl + T (works in normal AND terminal mode)
vim.keymap.set({"n", "t"}, "<C-t>", function()
    -- If we're inside terminal insert mode and want to close it, first leave terminal-mode
    if vim.bo.buftype == "terminal" then
        -- go to normal mode so the window can be closed cleanly
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
    end
    toggle_terminal()
end, {
    desc = "Toggle terminal (bottom)"
})

-- Resize with Cmd+Shift+Arrow (normal + terminal modes)
vim.keymap.set({"n", "t"}, "<D-S-Up>", function()
    if is_valid(term_win) then
        vim.cmd("resize +" .. 2)
    end
end, {
    desc = "Increase terminal height"
})

vim.keymap.set({"n", "t"}, "<D-S-Down>", function()
    if is_valid(term_win) then
        vim.cmd("resize -" .. 2)
    end
end, {
    desc = "Decrease terminal height"
})

-- (Optional) Also support Ctrl+Shift+Arrow for terminals that block Cmd keys
vim.keymap.set({"n", "t"}, "<C-S-Up>", function()
    if is_valid(term_win) then
        vim.cmd("resize +" .. 2)
    end
end, {
    desc = "Increase terminal height (Ctrl+Shift+Up)"
})

vim.keymap.set({"n", "t"}, "<C-S-Down>", function()
    if is_valid(term_win) then
        vim.cmd("resize -" .. 2)
    end
end, {
    desc = "Decrease terminal height (Ctrl+Shift+Down)"
})

------------------------------------------------------------
-- Buffer/tab navigation shortcuts
------------------------------------------------------------

-- Next / Prev buffer (like switching tabs)
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {
    desc = "Next buffer"
})
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {
    desc = "Prev buffer"
})

-- Re-order buffers
vim.keymap.set("n", "<leader>bn", "<Cmd>BufferLineMoveNext<CR>", {
    desc = "Move buffer right"
})
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineMovePrev<CR>", {
    desc = "Move buffer left"
})

-- Pick a buffer by letter
vim.keymap.set("n", "<leader>bb", "<Cmd>BufferLinePick<CR>", {
    desc = "Pick buffer"
})

-- Close current / other buffers
vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>", {
    desc = "Delete buffer"
})
vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", {
    desc = "Close other buffers"
})

-- (mac-style) Go to tab by number: ⌘1..⌘9 (works in GUIs; terminals may block ⌘)
for i = 1, 9 do
    vim.keymap.set("n", ("<C-%d>"):format(i), function()
        vim.cmd(("BufferLineGoToBuffer %d"):format(i))
    end, {
        desc = ("Go to buffer %d"):format(i)
    })
end

-- Command + Shift + E: Focus Neo-tree/reveal current file OR switch back to buffer
vim.keymap.set("n", "<D-S-e>", function()
    if vim.bo.filetype == "neo-tree" then
        vim.cmd("wincmd p")
    else
        require("neo-tree.command").execute({
            reveal = true,
            position = "left"
        })
    end
end, {
    desc = "Reveal in Neo-tree / Switch back to buffer"
})
