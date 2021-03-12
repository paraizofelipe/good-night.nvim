local vim = vim

local cmd = {}

cmd.build_command = function(request)
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

cmd.make_request = function(request)
    local command = cmd.build_command(request)
    return vim.api.nvim_call_function('systemlist', {
            command
        })
end

cmd.build_request = function(lines)
    local request = {
        method = '',
        header = {},
    }

    for _, line in pairs(lines) do
        local params = vim.split(line, ' ')
        if vim.tbl_contains(cmd.suported_methods, params[1]) then
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
