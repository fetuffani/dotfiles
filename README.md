# dotfiles

zsh + oh-my-zsh + starship (Catppuccin Macchiato). Run `./install.sh` to install or sync (pulls, updates omz, plugins and starship, re-links).

On a new server:

    wget -qO- https://raw.githubusercontent.com/fetuffani/dotfiles/main/install.sh | bash

To sync later: `~/dotfiles/install.sh` (after `git push` from the other machine).

Use a Nerd Font in your terminal and set the terminal colors to Catppuccin Macchiato (client side).

Machine-specific config and secrets go in `~/.zshrc.local` (untracked).
