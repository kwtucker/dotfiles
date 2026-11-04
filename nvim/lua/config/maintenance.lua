local M = {}
local timeout = 20 * 60 * 1000

local function check_plugins()
  local config = require("lazy.core.config")
  for _, notification in ipairs(config.spec.notifs) do
    assert(notification.level < vim.log.levels.ERROR, notification.msg)
  end
  for name, plugin in pairs(config.plugins) do
    assert(not require("lazy.core.plugin").has_errors(plugin), "Plugin operation failed: " .. name)
  end
end

local function plugins(upgrade)
  local manage = require("lazy.manage")
  -- Missing plugins are installed at their locked revisions, not today's HEAD.
  manage.install({ wait = true, show = false, lockfile = true })
  check_plugins()
  if upgrade then
    manage.update({ wait = true, show = false })
  else
    manage.restore({ wait = true, show = false })
  end
  check_plugins()
end

local function mason(install, parsers)
  require("lazy").load({ plugins = { "mason.nvim" } })
  local registry = require("mason-registry")
  local finished, success = false, false
  registry.update(function(ok)
    finished, success = true, ok
  end)
  assert(
    vim.wait(timeout, function()
      return finished
    end, 100),
    "Mason registry update timed out"
  )
  assert(success, "Mason registry update failed")
  if not install then
    return
  end

  local names = vim.deepcopy(require("config.tooling").mason_ensure or {})
  if parsers and vim.fn.executable("tree-sitter") == 0 then
    names[#names + 1] = "tree-sitter-cli"
  end
  local packages = {}
  for _, name in ipairs(names) do
    local package = registry.get_package(name)
    packages[#packages + 1] = package
    if not package:is_installed() and not package:is_installing() then
      package:install()
    end
  end
  local failed
  assert(
    vim.wait(timeout, function()
      for _, package in ipairs(packages) do
        if not package:is_installed() then
          if not package:is_installing() then
            failed = package.name
            return true
          end
          return false
        end
      end
      return true
    end, 100),
    "Mason package installation timed out"
  )
  assert(not failed, "Mason package installation failed: " .. tostring(failed))
end

local function parsers()
  require("lazy").load({ plugins = { "nvim-treesitter" } })
  assert(LazyVim.treesitter.check(), "Missing Treesitter build requirements")
  local languages = LazyVim.opts("nvim-treesitter").ensure_installed
  local installed = require("nvim-treesitter").install(languages, { summary = true }):wait(timeout)
  assert(installed, "Treesitter parser installation failed")
end

-- Headless entry point: Lua/startup/async failures must produce a nonzero exit,
-- not a misleading successful Make target. Nothing is silently cleaned/uninstalled.
function M.run(action)
  assert(vim.env.NVIM_MAINTENANCE == "1" and #vim.api.nvim_list_uis() == 0, "Run maintenance through the nvim Makefile")
  local ok, err = xpcall(function()
    assert(vim.v.errmsg == "", vim.v.errmsg)
    if action == "restore" then
      plugins(false)
    elseif action == "upgrade" then
      plugins(true)
      mason(false)
    elseif action == "prepare" then
      plugins(false)
      mason(true, true)
      parsers()
    elseif action == "mason-install" then
      mason(true)
    else
      error("Unknown maintenance action: " .. tostring(action))
    end
    assert(vim.v.errmsg == "", vim.v.errmsg)
  end, debug.traceback)
  if not ok then
    vim.api.nvim_err_writeln(tostring(err))
    vim.cmd("cquit 1")
    return
  end
  vim.cmd("qa")
end

return M
