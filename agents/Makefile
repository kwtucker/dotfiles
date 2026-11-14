include ../env.mk

AGENTS_HOME := $(HOME)/.agents
LINKS := skills/conventional-commits skills/go-development skills/caveman skills/temporary-ssh-key instructions/engineering.md

.PHONY: install clean sync-skills

# Preflight every source and destination before making links. Preserve local files.
install:
	@for path in $(LINKS); do \
		source="$(CURDIR)/$$path"; target="$(AGENTS_HOME)/$$path"; \
		if [ -d "$$source" ]; then \
			$(DOTFILES_LINK) preflight_dir "$$source" "$$target"; \
		else \
			$(DOTFILES_LINK) preflight_file "$$source" "$$target"; \
		fi; \
	done
	@for path in $(LINKS); do \
		source="$(CURDIR)/$$path"; target="$(AGENTS_HOME)/$$path"; \
		if [ -d "$$source" ]; then \
			$(DOTFILES_LINK) link_dir "$$source" "$$target"; \
		else \
			$(DOTFILES_LINK) link_file "$$source" "$$target"; \
		fi; \
	done
	@echo "Shared agent instructions and skills installed."

# Leave the parent directory and any skills installed by other tools untouched.
clean:
	@set -e; for path in $(LINKS); do \
		target="$(AGENTS_HOME)/$$path"; \
		if [ -L "$$target" ] && [ "$$(readlink "$$target")" = "$(CURDIR)/$$path" ]; then \
			rm "$$target"; \
		fi; \
	done

# Pass a pinned commit with: make -C agents sync-skills SKILL_SYNC_ARGS="--sha <sha>"
SKILL_SYNC_ARGS ?=

sync-skills:
	@bash ./skills/conventional-commits/sync.sh $(SKILL_SYNC_ARGS)
