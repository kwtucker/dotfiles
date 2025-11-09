include ../env.mk

install: .ensure.xdg
	@if ! command -v mise >/dev/null 2>&1; then \
		echo "🔧 'mise' not found. Installing..."; \
		curl -sSf https://mise.run | sh; \
	else \
		echo "✅ 'mise' is already installed."; \
	fi

	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/mise

clean: .remove.xdg.module.mise
	rm -rf ~/.local/bin/mise

.PHONY: install clean
