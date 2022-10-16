-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-fugitive'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'tpope/vim-sleuth'
    use 'numToStr/Comment.nvim'

    use 'sitiom/nvim-numbertoggle'
    use 'jinh0/eyeliner.nvim'

    use 'nvim-treesitter/nvim-treesitter'
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = { 'nvim-treesitter' } }
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }
    use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }

    use 'jose-elias-alvarez/null-ls.nvim'

    use 'ellisonleao/gruvbox.nvim'

    use 'nvim-lualine/lualine.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use { 'akinsho/bufferline.nvim', tag = 'v2.*', requires = 'kyazdani42/nvim-web-devicons' }

    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    if is_bootstrap then
        require('packer').sync()
    end
end)

if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.breakindent = true
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
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.autoread = true
vim.cmd [[autocmd FileType * setlocal formatoptions-=o]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- require("bufferline").setup{}
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
    },
    winbar = {
        lualine_a = { '%f' },
        lualine_b = { '%m' },
    },
    inactive_winbar = {
        lualine_b = { '%f' },
        lualine_c = { '%m' },
    },
}

require('Comment').setup()

require('numbertoggle').setup()

require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
}

require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

require('null-ls').setup {
    sources = {
        require('null-ls').builtins.formatting.stylua.with {
            condition = function(utils)
                return utils.root_has_file { 'stylua.toml', '.stylua.toml' }
            end,
        },
    },
}

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
    },
}
pcall(require('telescope').load_extension, 'fzf')
local tbuiltin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>fo', tbuiltin.oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader>bb', tbuiltin.buffers, { desc = 'Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
    tbuiltin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = 'Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>fa', function()
    tbuiltin.find_files { hidden = true, no_ignore = true }
end, { desc = 'Search all Files' })

vim.keymap.set('n', '<leader>ff', tbuiltin.find_files, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>fh', tbuiltin.help_tags, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>fw', tbuiltin.grep_string, { desc = 'Search current Word' })
vim.keymap.set('n', '<leader>fg', tbuiltin.live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>fd', tbuiltin.diagnostics, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader>fk', tbuiltin.keymaps, { desc = 'Search Normal Mode Keymaps' })
vim.keymap.set('n', '<leader>fr', tbuiltin.registers, { desc = 'Search Registers' })

require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'lua', 'python' },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            -- TODO: I'm not sure for this one.
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>cn', vim.lsp.buf.rename, '[C]hange [N]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    vim.keymap.set({ 'n', 'v' }, '<leader>cf', vim.lsp.buf.format, { desc = 'LSP: Run Formatter' })

    nmap('gd', tbuiltin.lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', tbuiltin.lsp_references, '[G]o References')
    nmap('gi', tbuiltin.lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>gt', tbuiltin.lsp_type_definitions, '[G]o Type Definition')
    nmap('<leader>gs', tbuiltin.lsp_document_symbols, 'Document Symbols')
    nmap('<leader>gw', tbuiltin.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')
end

local servers = { 'clangd', 'pyright', 'sumneko_lua' }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('mason').setup()

require('mason-lspconfig').setup {
    ensure_installed = servers,
}

for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            format = {
                enable = false,
            },
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            telemetry = { enable = false },
        },
    },
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- open this file
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
vim.o.clipboard = 'unnamedplus'
-- vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
-- vim.keymap.set({ 'n', 'v' }, 'c', '"_c')
-- vim.keymap.set('v', '<leader>p', '"_dP')
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
-- vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
-- vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')

-- disable annoying defaults
vim.keymap.set('n', 'ZZ', '<ESC>')

vim.keymap.set('n', '<leader><leader>x', '<cmd>w<CR><cmd>so %<CR>')

-- " better increasing/decreasing with <C-a>/<C-x>
-- set nrformats-=octal
--
-- " https://github.com/mhinz/neovim-remote
-- let $GIT_EDITOR = 'nvr -cc vsplit --remote-wait'
-- autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
