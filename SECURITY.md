# Security Playbook

This repository now treats credentials and host-local state as non-versioned.

## Untracked Sensitive Files

These files are intentionally ignored by Git and should stay local-only:

- `config/gh/hosts.yml`
- `config/msmtp/config`
- `ssh/id_*`
- `ssh/*.pub`
- `ssh/known_hosts`
- `ssh/known_hosts.old`

## Rotate Credentials Now

Because credentials were previously tracked, rotate them before any push.

### 1) Rotate GitHub CLI token

1. Revoke old token in GitHub settings:
   - `https://github.com/settings/tokens`
2. Re-authenticate CLI:
   - `gh auth logout -h github.com`
   - `gh auth login -h github.com --git-protocol ssh --web`
   - `gh auth status`

### 2) Rotate SSH key (recommended)

If your private key lived under this repo path, rotate it:

```bash
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519_github
ssh-add ~/.ssh/id_ed25519_github
cat ~/.ssh/id_ed25519_github.pub
```

Add the public key at `https://github.com/settings/keys` and remove old keys.

## Migrate `~/.ssh` Out Of Dotfiles

Use:

```bash
./scripts/migrate_ssh_out_of_repo.zsh
```

This script:

- Creates a real `~/.ssh` directory from your current symlinked contents
- Preserves a timestamped backup
- Re-links only `~/.ssh/config` to `ssh/config` in this repo

## Safe Pre-Push Check

Run before each push:

```bash
git status --short
git diff --cached --name-only | rg -i "(hosts\\.yml|id_ed25519|id_rsa|token|secret|password|credentials|\\.pem$|\\.key$)" || true
```
