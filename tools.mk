# tools.mk — mise tool ownership for install-time profiles.
#
# `mise.toml` remains the single version catalog. This file decides which
# catalog entries a profile installs:
#
#   active  = base + shared + unclassified
#             + tools of the selected modules
#             + extras of the selected profile
#   managed = every module-owned and profile-owned tool
#
# A profile switch only uninstalls tools in `managed`. Base tools, explicit
# shared tools, unclassified catalog entries, and tools declared in a local mise
# config are never removed by profile cleanup.
#
# Keep backend-qualified names exactly as they appear in mise.toml. Names must
# match the catalog key (`aqua:jqlang/jq`, not `jq`) so `mise uninstall` can find
# the installed version.

# ── Always installed ──────────────────────────────────────────────────────────
# make bootstraps the profile/tool resolution itself; shellcheck and shfmt are
# required by `make lint` on every machine.
BASE_TOOLS := make shellcheck shfmt

# Catalog tools with no module or profile owner. They install everywhere and are
# never uninstalled by profile cleanup. Unclassified tools are also treated as
# shared (with a warning from `make tools.check`).
SHARED_TOOLS := github:kwtucker/temp-ssh-key github:kwtucker/vpn

# ── Module ownership ──────────────────────────────────────────────────────────
# Define every tracked module explicitly, including modules that own no tools, so
# `make tools.check` can distinguish an intentional empty set from a forgotten
# declaration.
TOOLS_bin :=
TOOLS_zsh := aqua:starship/starship
TOOLS_alacritty :=
TOOLS_fzf := github:junegunn/fzf aqua:sharkdp/fd aqua:sharkdp/bat
TOOLS_tmux := tmux
TOOLS_git := aqua:jesseduffield/lazygit aqua:cli/cli
TOOLS_tig := conda:tig
TOOLS_golang := \
	go \
	go:golang.org/x/tools/gopls \
	go:golang.org/x/tools/cmd/goimports \
	aqua:mvdan/gofumpt \
	github:dominikh/go-tools \
	go:golang.org/x/vuln/cmd/govulncheck \
	github:golangci/golangci-lint
TOOLS_kubernetes := kubectl aqua:fullstorydev/grpcurl
TOOLS_helm := helm
TOOLS_terraform := \
	terraform \
	aqua:hashicorp/terraform-ls \
	aqua:terraform-linters/tflint \
	aqua:terraform-docs/terraform-docs
TOOLS_docker := aqua:docker/cli
TOOLS_bat := aqua:sharkdp/bat
TOOLS_ripgrep := aqua:BurntSushi/ripgrep
TOOLS_nvim := \
	aqua:neovim/neovim \
	node \
	python \
	uv \
	ruff \
	cargo:stylua \
	aqua:artempyanykh/marksman \
	aqua:BurntSushi/ripgrep
TOOLS_psql :=
TOOLS_fonts :=
TOOLS_rust := rust
TOOLS_agents :=
TOOLS_opencode := http:opencode
TOOLS_sops := aqua:getsops/sops aqua:FiloSottile/age
TOOLS_whalebyte := aqua:FiloSottile/age aqua:jqlang/jq
# Modules outside the active profile still declare their tools here so an
# explicit `make tools.install MODULES=<module>` includes them.
TOOLS_copilot := aqua:github/copilot-cli
TOOLS_cosmic :=

# ── Profile extras ────────────────────────────────────────────────────────────
# Install-scoped tools that do not belong to a configuration module. They are
# removed when the profile that selected them is replaced.
PROFILE_TOOLS_minimal :=
PROFILE_TOOLS_dev :=
PROFILE_TOOLS_infra :=
PROFILE_TOOLS_workstation := aqua:charmbracelet/vhs conda:ttyd conda:ffmpeg
PROFILE_TOOLS_full := $(PROFILE_TOOLS_workstation) conda:libqrencode conda:graphviz

# ── Derived sets ──────────────────────────────────────────────────────────────
# Parse the [tools] table without requiring mise or Python. Shell command
# substitution flattens the sorted newline output into a space-separated list.
MISE_TOOL_KEYS := $(shell awk '\
	/^\[tools\]$$/ { in_tools = 1; next } \
	/^\[/ { \
		in_tools = 0; \
		if ($$0 ~ /^\[tools\."[^"]+"\]$$/) { \
			line = $$0; \
			sub(/^\[tools\."/, "", line); \
			sub(/"\]$$/, "", line); \
			print line; \
		} \
		next; \
	} \
	in_tools && /^[[:space:]]*"/ { \
		line = $$0; \
		sub(/^[[:space:]]*"/, "", line); \
		sub(/".*/, "", line); \
		print line; \
	} \
	in_tools && /^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/ { \
		line = $$0; \
		sub(/[[:space:]]*=.*/, "", line); \
		gsub(/^[[:space:]]+|[[:space:]]+$$/, "", line); \
		print line; \
	}' "$(DOTFILES_ROOT_DIR)/mise.toml" | LC_ALL=C sort -u)

TRACKED_MODULES := $(ALL_MODULES)
ALL_MODULE_TOOLS := $(sort $(foreach m,$(TRACKED_MODULES) $(LOCAL_MODULES),$(TOOLS_$(m))))
ALL_PROFILE_TOOLS := $(sort $(foreach p,$(PROFILE_NAMES),$(PROFILE_TOOLS_$(p))))
MANAGED_TOOLS := $(sort $(ALL_MODULE_TOOLS) $(ALL_PROFILE_TOOLS))

ACTIVE_MODULE_TOOLS := $(sort $(foreach m,$(MODULES),$(TOOLS_$(m))))
ACTIVE_PROFILE_TOOLS := $(PROFILE_TOOLS_$(ACTIVE_PROFILE))
UNMAPPED_TOOLS := $(filter-out $(BASE_TOOLS) $(SHARED_TOOLS) $(MANAGED_TOOLS),$(MISE_TOOL_KEYS))
ACTIVE_TOOLS := $(sort $(BASE_TOOLS) $(SHARED_TOOLS) $(UNMAPPED_TOOLS) $(ACTIVE_MODULE_TOOLS) $(ACTIVE_PROFILE_TOOLS))

# `make tools.check` diagnoses declaration mistakes. A mapped name that is not in
# mise.toml is a typo; an unclassified catalog entry is only a warning.
UNKNOWN_MAPPED_TOOLS := $(filter-out $(MISE_TOOL_KEYS),$(sort $(BASE_TOOLS) $(SHARED_TOOLS) $(MANAGED_TOOLS)))
MISSING_TOOL_DECLS := $(strip $(foreach m,$(TRACKED_MODULES),$(if $(filter undefined,$(origin TOOLS_$(m))),$(m))))
