local M = {}

M.workspace = vim.env.WORKSPACE_IMAGE == "1"
M.debug = vim.env.K8S_DEBUG == "1"
M.maintenance = vim.env.NVIM_MAINTENANCE == "1"

-- These tools are present in both mise manifests. Do not silently substitute
-- an independently updated Mason installation if a mise install is missing.
M.mise_packages = {
  gopls = true,
  goimports = true,
  gofumpt = true,
  staticcheck = true,
  ["golangci-lint"] = true,
}
if not M.workspace then
  for _, name in ipairs({ "stylua", "ruff", "terraform-ls", "marksman" }) do
    M.mise_packages[name] = true
  end
end

-- The image consumes this list directly through the prepare Make target; do not
-- maintain a second MasonInstall list in the Dockerfile.
M.workspace_packages = {
  "docker-compose-language-service",
  "dockerfile-language-server",
  "helm-ls",
  "json-lsp",
  "lua-language-server",
  "shellcheck",
  "shfmt",
  "stylua",
  "taplo",
  "terraform-ls",
  "yaml-language-server",
}

M.workspace_servers = {
  docker_compose_language_service = true,
  dockerls = true,
  gopls = true,
  helm_ls = true,
  jsonls = true,
  lua_ls = true,
  taplo = true,
  terraformls = true,
  yamlls = true,
}

return M
