local function chat_adapter()
  local configured = vim.env.CODECOMPANION_ADAPTER
  if configured == "copilot_acp" or configured == "opencode" then
    return configured
  end
  return "opencode"
end

local function add_buffer_context()
  local codecompanion = require("codecompanion")
  local chat = codecompanion.last_chat() or codecompanion.chat({ stop_context_insertion = true })
  if not chat then
    return
  end

  chat.prompt:add({ content = "#{buffer} " })
  chat.ui:open()

  vim.schedule(function()
    if chat.ui.input and chat.ui.input:is_visible() then
      return chat.ui.input:focus()
    end

    if chat.ui.winnr and vim.api.nvim_win_is_valid(chat.ui.winnr) then
      vim.api.nvim_set_current_win(chat.ui.winnr)
      vim.api.nvim_win_set_cursor(chat.ui.winnr, { vim.api.nvim_buf_line_count(chat.bufnr), 0 })
      vim.cmd("startinsert!")
    end
  end)
end

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanionChat",
    keys = {
      { "<leader>a", "", desc = "+AI", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat" },
      { "<leader>ac", add_buffer_context, desc = "Add Buffer to AI Chat" },
      {
        "<leader>as",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "Add Selection to AI Chat",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local adapter = chat_adapter()
      local executable = adapter == "copilot_acp" and "copilot" or "opencode"

      if vim.fn.executable(executable) == 0 then
        vim.notify(
          string.format("CodeCompanion: `%s` is not on PATH; install it before using `%s`.", executable, adapter),
          vim.log.levels.ERROR,
          { title = "CodeCompanion" }
        )
      end

      return {
        interactions = {
          chat = {
            adapter = adapter,
          },
        },
      }
    end,
  },
}
