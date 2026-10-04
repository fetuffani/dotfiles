# Rules for agents, harnesses and automation

This repo holds shell dotfiles and is synced between servers. It must never contain secrets.

## Before every commit (mandatory)
Do NOT read secret values. Never run `git diff`, `git diff --cached`, `git show`, `cat`, or `Read`
on staged/changed config files, and never open `~/.zshrc.local`, `.env*` or key files. Doing so puts
secrets into your context and logs. Review by key names only:

1. Run `scripts/staged-keys`. It lists staged files and every added config KEY with its value
   masked (`NAME = <N chars>`), then runs the automated secret scan.
2. Check each key name. A key that looks like a credential (`*_TOKEN`, `*_KEY`, `*_SECRET`,
   `*PASSWORD*`, `AUTH*`, `*_URL` with embedded creds, or any long opaque value) must not be
   committed. Move it to `~/.zshrc.local` (untracked) without printing its value.
3. Make sure the hook is active: `git config core.hooksPath` must print `.githooks`.
   If not, run `git config core.hooksPath .githooks`.
4. Commit normally so `.githooks/pre-commit` runs. If `scripts/staged-keys` or the hook fails,
   stop and report which file and key, not the value.

## Never
- Never use `git commit --no-verify`, `-n`, or edit/remove/disable the hook or `core.hooksPath`.
- Never commit `.zshrc.local`, `.env*`, `*.pem`, `*.key`, `id_*`, `.netrc`, `hosts.yml`.
- Never print or read secret values in output, logs or commit messages. Refer to keys by name only.
- Never `git add -A` or `git add .` blindly; stage specific files and review them.

## If a secret is found
Stop. Unstage it, move it to `~/.zshrc.local` (untracked), and tell the user.
If it was already pushed, tell the user to rotate it; deleting it from history is not enough.

Machine-specific values and secrets go in `~/.zshrc.local`, which is gitignored.
