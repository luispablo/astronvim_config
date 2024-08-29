-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo(
    { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

-- Custom command & mapping to live grep word under cursor

function SearchWithUnnamedRegisterOrWord()
  local search_text = ""

  -- Get the content of the unnamed register
  local unnamed_register = vim.fn.getreg '"'

  if unnamed_register ~= "" then
    -- If the unnamed register is not empty, use its content
    search_text = unnamed_register
  else
    -- Use the word under the cursor if the unnamed register is empty
    search_text = vim.fn.expand "<cword>"
  end

  -- Call Telescope live_grep with the search text
  require("telescope.builtin").live_grep { default_text = search_text }
end

-- Create a mapping for normal and visual mode
vim.api.nvim_set_keymap(
  "n",
  "<leader>gw",
  [[<cmd>lua SearchWithUnnamedRegisterOrWord()<CR>]],
  { noremap = true, silent = true }
)
