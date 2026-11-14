# sops

Use [sops](https://github.com/getsops/sops) with age to encrypt YAML/JSON/etc without managing a plaintext key file.

## How it works

This module sets `SOPS_AGE_KEY_CMD` to `~/.local/bin/sops-age-key-from-wbs`, which decrypts your passphrase-protected wbs identity on-demand.

- **No `keys.txt`** - The private key is only in memory while sops runs
- **Prompt on use** - You'll be asked for your wbs identity passphrase when sops needs the key
- **Shares the wbs identity** - By default it uses `${XDG_CONFIG_HOME:-$HOME/.config}/age/wbs-identity.age` and the public key from the same directory

`SOPS_AGE_KEY_CMD` is exported by `sops/env.zsh`, which `.zshrc` sources. Bash
and other shells do not read it: export the variable in that shell (or its
startup file) if you use sops outside zsh:

```sh
export SOPS_AGE_KEY_CMD="$HOME/.local/bin/sops-age-key-from-wbs"
```

## Setup

1. Install: `make sops` (or include in `LOCAL_MODULES`)
2. Create `${XDG_CONFIG_HOME:-$HOME/.config}/age/` (the module creates it with mode
   `700`) and place `wbs-identity.age` there, or point `WBS_IDENTITY` at another
   encrypted identity
3. Get your public key: `age-keygen -y "${XDG_CONFIG_HOME:-$HOME/.config}/age/wbs-identity.age"`
4. Add to `.sops.yaml` in your repo:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: age1YOUR_PUBLIC_KEY_HERE
```

## Usage

```sh
sops edit secrets/config.yaml   # Create/edit encrypted file
sops -d secrets/config.yaml    # Decrypt to stdout
sops -e -i secrets/config.yaml # Encrypt in place
sops -d -i secrets/config.yaml # Decrypt in place
```

## Notes

- `wbs` remains the interface for `~/.whalebyte/.secret` and is completely separate.
- The helper respects `WBS_IDENTITY` if you want to use a different identity; the
  default is baked in from `XDG_CONFIG_HOME` when the module is installed.
- If you need true key separation, generate a separate identity with `age-keygen` and adjust `SOPS_AGE_KEY_CMD`.
- On non-interactive shells without a TTY, sops will fail to prompt (by design).
- `make doctor` warns when the helper is missing or not executable.
