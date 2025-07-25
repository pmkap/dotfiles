-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
require("config.lazy")

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.breakindent = true
require('guess-indent').setup {}

-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox]]
vim.o.completeopt = 'menuone,noselect'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.laststatus = 3
vim.o.autoread = true
vim.cmd [[autocmd FileType * setlocal formatoptions-=o]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- opens vimrc/init.lua
vim.keymap.set('n', '<leader>rc', '<cmd>edit $MYVIMRC<CR>')

-- split navigation
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<ESC><C-w>j')
vim.keymap.set('n', '<A-k>', '<ESC><C-w>k')
vim.keymap.set('n', '<A-l>', '<ESC><C-w>l')
vim.keymap.set('n', '<A-h>', '<ESC><C-w>h')

-- buffer navigation
vim.keymap.set('n', '<leader>,', '<cmd>bprev<CR>')
vim.keymap.set('n', '<leader>.', '<cmd>bnext<CR>')

-- safer <C-u> and <C-w>
vim.keymap.set('i', '<C-U>', '<C-G>u<C-U>')
vim.keymap.set('i', '<C-W>', '<C-G>u<C-W>')

-- change to the dir of currently open file
vim.keymap.set('n', '<leader>cd', '<cmd>cd %:p:h<CR><cmd>pwd<CR>')

-- quick access
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>')
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>')

-- clipboard and registers
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')

-- disable annoying defaults
vim.keymap.set('n', 'ZZ', '<ESC>')

-- save and source current file
vim.keymap.set('n', '<leader><leader>x', '<cmd>w<CR><cmd>so %<CR>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

