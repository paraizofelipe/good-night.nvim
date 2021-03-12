local vim = vim
local ui = require('gnight.ui')
local cmd = require('gnight.cmd')
local request_file = require('gnight.request_file')
local request_list = require('gnight.request_list')

local gnight = {
    current_file = '/home/paraizo/.gnight/requests.gnt',
    suported_content_type = {'application/json','application/yaml'}
}


gnight.GNStart = function()
    request_file.start(gnight.current_file)
    request_list.start(request_file.blocks)

    ui.request_file = request_file
    ui.request_list = request_list
end

gnight.GNMakeRequest = function()
    local coordinates = ui.motion(0)
    local lines = ui.extract_lines(coordinates)
    local request = cmd.build_request(lines)
    local response = cmd.make_request(request)

    ui.show_win()
    ui.redraw(response)
end

return gnight
