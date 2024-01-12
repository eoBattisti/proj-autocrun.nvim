local api = vim.api

---@class Autocrun
local M = {} -- Module

---@param opts table
function M:setup(opts)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("AutoCRun", { clear = true }),
    pattern = "*.c",
    callback = function ()
        local file = api.nvim_buf_get_name(0)

        api.nvim_command("vsplit new")

        -- get current buff number
        local bufnr = api.nvim_get_current_buf()

        local cmd = "gcc " .. file .. " -o main.c"

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
    end,
  })
end

return M
