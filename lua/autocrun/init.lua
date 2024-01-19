local api = vim.api

---@class Autocrun
local M = {} -- Module
M.opts = {}

-- INFO: Validates if there is a `gcc` compiler
-- INFO: Validates if ther is a buffer open
-- functions might uses:
--   - nvim_list_bufs
--   - nvim_create_buf
--   - nvim_open_win
--
-- INFO: If the file has no `main` function, ask for the user if he wants to compile

-- TODO: Add the following options to opt:
--  compiler_args: string e.g `-O3`

---@param filepath string
M.has_main_on_file = function(filepath)
  for line in io.lines(filepath) do
    if string.find(line, "int main%(") then
      return true
    end
  end
end


---@param filepath string
M.execute = function (filepath)

  local bufnr = api.nvim_create_buf(false, true)

  local ui = api.nvim_list_uis()[1]
  local col = 12
  if ui ~= nil then
    col = math.max(ui.width - 13, 0)
  end

  local win_id = api.nvim_open_win(bufnr, true, {
     relative = "editor",
     anchor = "NW",
     row = 1,
     col = col,
     width = 40,
     height = 3,
     border = "rounded",
     title = "Autocrun",
     style = "minimal"
  })

  local cmd = M.opts.cmd ..  " " .. filepath .. " -o " .. M.opts.output_filename
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
    pattern = M.opts.pattern or "*.c",
    callback = M.callback
  })
end

return M
