local M = {}

-- LazyVim automatically enables its VS Code extra. Apply only our mappings,
-- after its defaults, rather than returning plugin specs from a config module.
function M.setup()
  local vscode = require("vscode")
  vim.keymap.set("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
  vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Clear search" })
  for key, action in pairs({
    ["<leader>ff"] = "workbench.action.quickOpen",
    ["<leader>fg"] = "workbench.action.findInFiles",
    gd = "editor.action.revealDefinition",
    gr = "editor.action.goToReferences",
  }) do
    vim.keymap.set("n", key, function()
      vscode.action(action)
    end, { desc = action })
  end
end

return M
