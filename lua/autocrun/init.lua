local api = vim.api

---@class Autocrun
local M = {} -- Module
M.opts = {}

-- INFO: Validates if there is a `main` function on the file saved
-- INFO: Validates if there is a `gcc` compiler

-- TODO: Add the following options to opt:
--  compiler_cmd: string e.g `gcc` or `g++`
--  compiler_args: string e.g `-O3`
--  output_file: string e.g `main`



---@param data table
M.write_file = function (data)
    -- TODO: check if buff is open

    vim.fn.win_findbuf()
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
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

  api.nvim_command("vsplit new")
  local bufnr = api.nvim_get_current_buf()

  local cmd = "gcc " .. info.match .. " -o main.c"
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function (_, data)
      if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
  })
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
