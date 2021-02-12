local vim = vim
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
        -- user = '-U ' .. gnight.connect.user,
        -- pass = 'PGPASSWORD=' .. gnight.connect.password,
        -- host = '-h ' .. gnight.connect.host,
        -- database = '-d ' .. gnight.connect.database,
    }

    -- local command = string.format("%s psql %s %s %s -c \"%s\"", args.pass, args.host, args.user, args.database, query)
    return command
end

gnight.make_request = function(request)
    local command = gnight.build_command(request)
    return vim.api.nvim_call_function('systemlist', {
            command
        })
end

gnight.build_request = function(lines)
    request = {
        header = {},
    }

    for _, line in pairs(lines) do
        params = utils.split(line, ' ')
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

gnight.GNStart = function()
    coordinates = gnight.motion(0)
    lines = gnight.extract_lines(coordinates)

    request = gnight.build_request(lines)
    print(vim.inspect(request))
    gnight.make_request(request)

end

return gnight
