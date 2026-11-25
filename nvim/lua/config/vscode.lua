local M = {}

function M.setup()
  local vscode = require("vscode")
  vim.keymap.set("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
  vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Clear search" })
  for key, action in pairs({
    ["<C-h>"] = "workbench.action.navigateLeft",
    ["<C-j>"] = "workbench.action.focusBelowGroup",
    ["<C-k>"] = "workbench.action.focusAboveGroup",
    ["<C-l>"] = "workbench.action.focusRightGroup",
    ["<leader>-"] = "workbench.action.splitEditorDown",
    ["<leader>/"] = "workbench.action.findInFiles",
    ["<leader><Bar>"] = "workbench.action.splitEditorRight",
    ["<leader>e"] = "workbench.action.toggleSidebarVisibility",
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
