# dotfiles

zsh + oh-my-zsh + starship (Catppuccin Macchiato). Run `./install.sh` to install or sync (pulls, updates omz, plugins and starship, re-links).

On a new server:

    wget -qO- https://raw.githubusercontent.com/fetuffani/dotfiles/main/install.sh | bash

To sync later: `~/dotfiles/install.sh` (after `git push` from the other machine).

Recommended font: **CommitMono Nerd Font Mono**, set in the terminal you connect from (client side). Download: https://www.nerdfonts.com/font-downloads

Also set the terminal colors to Catppuccin Macchiato (client side).

Machine-specific config and secrets go in `~/.zshrc.local` (untracked).
