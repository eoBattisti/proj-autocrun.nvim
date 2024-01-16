local api = vim.api

---@class Autocrun
local M = {} -- Module
M.opts = {}

-- INFO: Validates if there is a `gcc` compiler
-- INFO: Validates if ther is a buffer open

-- TODO: Add the following options to opt:
--  compiler_cmd: string e.g `gcc` or `g++`
--  compiler_args: string e.g `-O3`
--  output_file: string e.g `main`
--

---@param filepath string
M.has_main_on_file = function(filepath)
  for line in io.lines(filepath) do
    if string.find(line, "int main(") then
      return true
    end
  end
end


---@param filepath string
M.execute = function (filepath)
  api.nvim_command("vsplit new")
  local bufnr = api.nvim_get_current_buf()
  local cmd = "gcc " .. filepath .. " -o main.c "
  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if #data == #{ "" } then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"Success compiling your C code!"})
      end
    end,
    on_stderr = function (_, data)
      if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
  })
end

---@param info table<string, string | number>
M.callback = function (info)
    --[[ Callback Function

    Callback function description goes here.

    @param info table A table containing information.
      - buf (number): The buffer identifier.
      - event (string): The event that triggered the callback.
      - file (string): The filename.
      - group (number): The group identifier.
      - id (number): The identifier.
      - match (string): The match pattern, in this case is the fullpath.

    ]] --


  local has_main = M.has_main_on_file(tostring(info.match))
  if has_main then
    M.execute(info.match)
  else
    print("No main function found on this file!")
  end
end

---@param opts table
M.setup = function (opts)
  M.opts = opts
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("AutoCRun", { clear = true }),
    pattern = "*.c",
    callback = M.callback
  })
end

return M
