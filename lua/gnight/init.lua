local vim = vim
local ui = require('gnight.ui')
local utils = require('gnight.utils')

local gnight = {
    suported_methods = {'GET','POST', 'DELETE', 'PUT', 'PATCH' },
    suported_content_type = {'application/json','application/yaml'}
}

gnight.motion = function(bufnr)
  local b_line, b_col, e_line, e_col

  b_line, b_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '('))
  e_line, e_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ')'))

  return {
    from = {b_line, b_col},
    to = {e_line, e_col},
    bufnr = bufnr
  }
end

gnight.extract_lines = function(coordinates)
  local lines = vim.api.nvim_buf_get_lines(coordinates.bufnr, coordinates.from[1] - 1, coordinates.to[1], false)

  return lines
end

gnight.build_command = function(request)
    local args = {
        url = request.url,
        method = '-X ' .. request.method,
        headers = '',
        body = '',
    }

    if request.body ~= nil then
        args.body = '-d' .. request.body
    end

    for _, header in pairs(request.header) do
        args.headers = args.headers..' -H '..'"'..header..'"'
    end

    local command = string.format("curl -s -iL %s %s %s %s", args.method, args.url, args.headers, args.body)
    return command
end

gnight.make_request = function(request)
    local command = gnight.build_command(request)
    return vim.api.nvim_call_function('systemlist', {
            command
        })
end

gnight.build_request = function(lines)
    local request = {
        method = '',
        header = {},
    }

    for _, line in pairs(lines) do
        local params = utils.split(line, ' ')
        if utils.contains(gnight.suported_methods, params[1]) then
            request.method = params[1]
            request.url = params[2]
        end

        if params[1] == 'Header' then
            table.insert(request.header, params[2]..' '..params[3])
        end

        if params[1] == 'Body' then
            request.body = params[2]
        end
    end

    return request
end

gnight.set_mappings = function()
    local mappings = {
        r = 'GNMakeRequest()',
    }

    for k, f in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(0, 'n', k, ':lua require"gnight".'..f..'<cr>', {
                nowait = true,
                noremap = true,
                silent = true
            })
    end
end

gnight.GNStart = function()
    vim.api.nvim_command('edit ~/.gnight/requests.gnt')
    gnight.set_mappings()
end

gnight.GNMakeRequest = function()

    local coordinates = gnight.motion(0)
    local lines = gnight.extract_lines(coordinates)
    local request = gnight.build_request(lines)
    local response = gnight.make_request(request)

    ui.show_win()
    ui.redraw(response)
end

return gnight
