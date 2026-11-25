# Documentation

Choose documentation by what you need to do. Shared installation and ownership
rules live here; application-specific details live in the
[module READMEs](../README.md#modules).

## Tutorials

Tutorials teach through a bounded exercise with expected results.

- [First installation](tutorials/first-install.md): install a minimal environment
  on a new macOS or Linux machine and inspect the result.

## How-to guides

These guides assume you know your goal and need a practical sequence.

- [Update dotfiles and tools](how-to/update-dotfiles.md)
- [Choose or switch profiles](how-to/switch-profiles.md)
- [Resolve conflicts and recover configuration](how-to/recover-configuration.md)
- [Customize one machine or enable a module](how-to/customize-machine.md)
- [Use SSH hosts, DevPod, and devcontainers](how-to/remote-workspaces.md)
- [Add a module](how-to/add-module.md)
- [Create and export a signing key](../git/how-to.md#generate-and-copy-a-signing-key)
- [Maintain Neovim](../nvim/how-to.md)
- [Set up or migrate a secrets vault](../whalebyte/how-to.md)

## Reference

Reference is for lookup, not a step-by-step lesson.

- [Commands and side effects](reference/commands.md)
- [Profiles, module selection, and tool ownership](reference/profiles-and-tools.md)
- [Environment variables and local overrides](reference/environment.md)
- [Deployment helper contracts](../scripts/README.md#reference)
- [Git and GPG reference](../git/reference.md)
- [Neovim reference](../nvim/reference.md)
- [Vault reference](../whalebyte/reference.md)

## Explanation

Explanation covers why the system works this way and where its limits are.

- [Architecture and installation state](explanation/architecture.md)
- [Safety and reproducibility](explanation/safety-and-reproducibility.md)
- [Neovim design choices](../nvim/explanation.md)
- [Vault encryption and security boundaries](../whalebyte/explanation.md)

## Maintaining documentation

Distinguish learning, tasks, lookup, and understanding. Do not manufacture
four documents for every small module:
separate sections are enough until a topic needs its own page. READMEs are
entry points, not copies of every shared guide.

Before documenting behavior, read the relevant Makefile, configuration, and
callers. Keep version pins in `mise.toml` and artifact pins in their Makefiles;
link to them rather than maintaining a second version catalog in prose.
Show prerequisites, the command's working directory, side effects, and expected
verification. Put warnings beside destructive examples.

Keep agent policy files, executable skills/commands, licenses, and vendored
upstream docs in their existing locations. For validation, check relative links
and heading anchors, module README coverage, and `git diff --check`. Do not run
installers, upgrades, cleanup, key generation, or model sessions merely to check
documentation examples. Temporary check scripts belong outside the checkout.
