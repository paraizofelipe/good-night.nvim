local vim = vim

local ui = {}

local buf, win, start_win

--- create_win
ui.create_win = function()
    start_win = vim.api.nvim_get_current_win()
    vim.api.nvim_command('botright vnew') -- We open a new vertical window at the far right

    win = vim.api.nvim_get_current_win() -- We save our navigation window handle...
    buf = vim.api.nvim_get_current_buf() -- ...and it's buffer handle.

    vim.api.nvim_buf_set_name(buf, 'GNResponse #' .. buf)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'gnight')

    -- For better UX we will turn off line wrap and turn on current line highlight.
    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'cursorline', true)
end

--- redraw
ui.redraw = function (result)
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

--- motion
ui.motion = function(bufnr)
  local b_line, b_col, e_line, e_col

  b_line, b_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '<'))
  e_line, e_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '>'))

  b_col = b_col + 1
  e_col = e_col + 2

  return {
    from = {b_line, b_col},
    to = {e_line, e_col},
    bufnr = bufnr
  }
end

--- show_win
ui.show_win = function()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
    else
        ui.create_win()
    end
end


return ui
