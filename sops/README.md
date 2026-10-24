# sops

Use [sops](https://github.com/getsops/sops) with age to encrypt YAML/JSON/etc without managing a plaintext key file.

## How it works

This module sets `SOPS_AGE_KEY_CMD` to `~/.local/bin/sops-age-key-from-wbs`, which decrypts your passphrase-protected wbs identity on-demand. 

- **No `keys.txt`** - The private key is only in memory while sops runs
- **Prompt on use** - You'll be asked for your wbs identity passphrase when sops needs the key
- **Shares the wbs identity** - By default it uses `~/.config/age/wbs-identity.age` and the public key from `~/.config/age/wbs-recipient`

## Setup

1. Install: `make sops` (or include in `LOCAL_MODULES`)
2. Get your public key: `age-keygen -y ~/.config/age/wbs-identity.age`
3. Add to `.sops.yaml` in your repo:

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
- The helper respects `WBS_IDENTITY` if you want to use a different identity.
- If you need true key separation, generate a separate identity with `age-keygen` and adjust `SOPS_AGE_KEY_CMD`.
- On non-interactive shells without a TTY, sops will fail to prompt (by design).
