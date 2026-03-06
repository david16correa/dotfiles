-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- for conciseness
local opts = { noremap = true, silent = true }

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", unpack(opts) })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", unpack(opts) })
vim.keymap.set("n", "<leader>bd", ":bdelete!<CR>", { desc = "[B]uffer [D]elete", unpack(opts) })
vim.keymap.set("n", "<leader>bn", "<cmd> enew <CR>", { desc = "[B]uffer [N]ew", unpack(opts) }) -- new buffer

-- window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "[L]ine [W]rap", unpack(opts) })

-- stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- clear search selection on <Esc>
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR><Esc>", opts)

-- better pasting
vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "Paste from yank register" })

-- add characters at EOL
vim.keymap.set("n", "<leader>;", "A;<Esc>", { desc = "; at EOL", unpack(opts) })
vim.keymap.set("n", "<leader>,", "A,<Esc>", { desc = ", at EOL", unpack(opts) })

-- yanking
vim.keymap.set("v", "<leader>y", '"+y', { desc = "[Y]ank (to clipboard)", unpack(opts) })
vim.keymap.set("n", "<leader>ly", '"+yy', { desc = "[Y]ank [L]ine (to clipboard)", unpack(opts) })
vim.keymap.set('n', '<leader>ya', 'ggVG"+y', { desc = 'Select all and copy to clipboard' })

-- compilation
vim.keymap.set("n", "<Leader>cc", ":w<CR>:!gcc % -o %:r.out<CR>", { desc = "Compile with gcc (vanilla)", unpack(opts) })
vim.keymap.set("n", "<leader>mp", function()
  local filename = vim.fn.expand("%:t") -- Get current buffer name
  if filename == "" then
    print("No file name detected")
    return
  end
  local name = vim.fn.fnamemodify(filename, ":r") -- Remove extension
  local cmd = string.format("~/.scripts/md2pdf/md2pdf.sh %s.md %s.pdf", name, name)
  vim.cmd("!" .. cmd)
end, { desc = "Convert Markdown to PDF" })

vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = "Clear search highlights" })
