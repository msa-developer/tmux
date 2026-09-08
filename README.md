# dotfiles-tmux

Clone-ready tmux config - no re-configuration needed.

Current setup:
- Theme: PowerKit `tokyo-night` (via `fabioluciano/tmux-tokyo-night`)
- Plugins: `uptime` (`uptime -p` exact, 5s real-time), `datetime`, `battery`, `hostname`, `git` (cpu/memory removed)
- Prefix: `C-a`

## Install on new machine
```bash
git clone <your-github-url> ~/dotfiles-tmux
cd ~/dotfiles-tmux && ./install.sh
```

## That's it
`install.sh` links `.tmux.conf`, installs TPM + plugins, and applies the `uptime -p` patch.
