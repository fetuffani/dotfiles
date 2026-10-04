# Rules for agents, harnesses and automation

This repo holds shell dotfiles and is synced between servers. It must never contain secrets.

## Before every commit (mandatory)
1. Run `git diff --cached` and read it. Look for private keys, tokens, passwords, API keys,
   `.env` contents, SSH keys, cloud credentials, internal hostnames or IPs.
2. Make sure the hook is active: `git config core.hooksPath` must print `.githooks`.
   If not, run `git config core.hooksPath .githooks`.
3. Commit normally so `.githooks/pre-commit` runs. Optionally run `.githooks/pre-commit` first.

## Never
- Never use `git commit --no-verify`, `-n`, or edit/remove/disable the hook or `core.hooksPath`.
- Never commit `.zshrc.local`, `.env*`, `*.pem`, `*.key`, `id_*`, `.netrc`, `hosts.yml`.
- Never print secret values in output, logs or commit messages.
- Never `git add -A` or `git add .` blindly; stage specific files and review them.

## If a secret is found
Stop. Unstage it, move it to `~/.zshrc.local` (untracked), and tell the user.
If it was already pushed, tell the user to rotate it; deleting it from history is not enough.

Machine-specific values and secrets go in `~/.zshrc.local`, which is gitignored.
