local vim = vim

local M = {
    request_list = nil,
    request_file = nil,
}


--- motion
M.motion = function(bufnr)
  local b_line, b_col, e_line, e_col

  b_line, b_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '('))
  e_line, e_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ')'))

  b_col = b_col + 1
  e_col = e_col + 2

  return {
    from = {b_line, b_col},
    to = {e_line, e_col},
    bufnr = bufnr
  }
end

--- extract_lines
M.extract_lines = function(coordinates)
  local lines = vim.api.nvim_buf_get_lines(coordinates.bufnr, coordinates.from[1] - 1, coordinates.to[1], false)

  return lines
end

--- show_block
M.show_block = function()
    local line = vim.api.nvim_get_current_line()
    local num_line = vim.split(line, " | ")[2]
    print(vim.inspect(num_line))

    vim.api.nvim_set_current_win(M.request_file.screen.win)
    vim.api.nvim_win_set_cursor(M.request_file.screen.win, {tonumber(num_line), 1})
end


return M
