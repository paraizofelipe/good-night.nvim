local vim = vim

local utils = require('gnight.utils')

local M = {
    screen = { win = nil, buf = nil },
    delimiter_pattern = { begin = '{{{req:(.+)', finish = '}}}' },
    blocks_name = {},
    blocks = {},
}


--- start
M.start = function(current_file)
    if M.screen.win and vim.api.nvim_win_is_valid(M.screen.win) then
        vim.api.nvim_set_current_win(M.screen.win)
    else
        M.load_blocks(current_file)
        M.create_win(current_file)
        M.set_mappings()
    end
end


--- create_win
M.create_win = function(file)
    vim.api.nvim_command('tabnew '..file)

    M.screen.win = vim.api.nvim_get_current_win()
    M.screen.buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(M.screen.buf, 'GNRequest')
    -- vim.api.nvim_buf_set_option(M.screen.buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(M.screen.buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(M.screen.buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(M.screen.buf, 'filetype', 'gnight')
    vim.api.nvim_buf_set_option(M.screen.buf, 'modifiable', true)

    vim.api.nvim_win_set_option(M.screen.win, 'wrap', false)
    vim.api.nvim_win_set_option(M.screen.win, 'cursorline', true)


    return {
        win = M.screen.win,
        bif = M.screen.buf,
    }
end


--- load_blocks
M.load_blocks = function(current_file)
    local block = {}
    local name = nil

    local lines = utils.read_file(current_file)

    for num_line, l in pairs(lines) do
        if string.match(l, M.delimiter_pattern.begin) then
            name = string.match(l, M.delimiter_pattern.begin)
            table.insert(M.blocks_name, name)
            goto continue
        elseif string.match(l, M.delimiter_pattern.finish) then
            M.blocks[name] = block
            name = nil
            block = {}
            goto continue
        end

        if name then
           table.insert(block, {num_line, l})
        end
        ::continue::
    end

    return M.blocks
end


--- set_mappings
M.set_mappings = function()
    local mappings = {
        r = 'GNMakeRequest()',
    }

    for k, f in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(M.screen.buf, 'n', k, ':lua require"gnight".'..f..'<cr>', {
                nowait = true,
                noremap = true,
                silent = true
            })
    end
end


--- draw
M.draw = function(block)
    vim.api.nvim_buf_set_option(M.screen.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(M.screen.buf, 0, -1, false, block)
end

return M
