local M = {}

M.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

M.read_file = function(file)
  if not M.file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
      table.insert(lines, line)
  end
  return lines
end

M.tabular_line = function(line)
    local tabulated_line
    tabulated_line = vim.api.nvim_command("echo "..line.." | column -t ")
    return tabulated_line
end

return M
