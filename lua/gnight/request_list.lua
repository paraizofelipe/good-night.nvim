local vim = vim

local M = {
    suported_methods = { 'GET','POST','DELETE','PUT','PATCH' },
    screen = { buf = nil, win = nil }
}


--- start
M.start = function(blocks)
    if M.screen.win and vim.api.nvim_win_is_valid(M.screen.win) then
        vim.api.nvim_set_current_win(M.screen.win)
    else
        local requests = M.find_requests(blocks)
        local table_list = M.build_list(requests)

        M.create_win()
        M.draw(table_list)
        M.set_mappings()
    end
end


--- create_win
M.create_win = function()
    vim.api.nvim_command('botright new')

    M.screen.win = vim.api.nvim_get_current_win()
    M.screen.buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(M.screen.buf, 'GNRequestList')
    vim.api.nvim_buf_set_option(M.screen.buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(M.screen.buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(M.screen.buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(M.screen.buf, 'filetype', 'gnight')

    vim.api.nvim_win_set_option(M.screen.win, 'wrap', false)
    vim.api.nvim_win_set_option(M.screen.win, 'cursorline', true)

    vim.api.nvim_win_set_height(M.screen.win, 15)

    return {
        win = M.screen.win,
        buf = M.screen.buf,
    }
end

--- find_requests
M.find_requests = function(blocks)
    local requests = {}

    for block_name, group in pairs(blocks) do
        requests[block_name] = {}
        for _, block in pairs(group) do
            for _, method in pairs(M.suported_methods) do
                local request = string.match(block[2], '^ *('..method..' .+)')
                if request then
                    table.insert(requests[block_name], block)
                end
            end
        end
    end
    return requests
end


--- build_list
M.build_list = function(requests)
    local table_req = {}

    for block_name, request in pairs(requests) do
        table.insert(table_req, block_name)
        for _, block in pairs(request) do
            local num_line, text = unpack(block)
            local line = "\t"..text.." | "..num_line.." | "..block_name
            table.insert(table_req, line)
        end
    end

    return table_req
end


--- set_mappings
M.set_mappings = function()
    local mappings = {
        ['<cr>'] = 'show_block()',
    }

    for k, f in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(M.screen.buf, 'n', k, ':lua require"gnight.ui".'..f..'<cr>', {
                nowait = true,
                noremap = true,
                silent = true
            })
    end
end


--- draw
M.draw = function(table_list)
    vim.api.nvim_buf_set_option(M.screen.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(M.screen.buf, 0, -1, false, table_list)
    vim.api.nvim_buf_set_option(M.screen.buf, 'modifiable', false)
end

return M
