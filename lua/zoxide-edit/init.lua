local M = {}

local default_config = {
  abbreviate_e_cmd = true,
}

local exec = function(opts)
  local entered_path = opts.args
  local cmd = { "zoxide", "query", "--", entered_path }
  vim.fn.jobstart(cmd, {
    on_stdout = function(zoxide_result)
      vim.cmd("e " .. zoxide_result[1])
    end,
    on_stderr = function(_, data)
      print(table.concat(data))
    end,
  })
end

M.setup = function(user_config)
  config = vim.tbl_deep_extend("force", default_config, user_config or {})
  if config.abbreviate_e_cmd then
    vim.cmd(":cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>")
  end
  vim.api.nvim_create_user_command("E", exec, { nargs = 1 })
end

return M
