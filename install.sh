#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Link tmux config
ln -sf "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf
echo "✓ Linked .tmux.conf -> ~/.tmux.conf"

# Install TPM if missing
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✓ Installed TPM"
fi

# Install plugins (powerkit/tokyo-night, vim-tmux-navigator, resurrect, continuum)
~/.tmux/plugins/tpm/bin/install_plugins

# Apply exact `uptime -p` patch (keeps "up 50 minutes" vs "50m")
if [ -f "$SCRIPT_DIR/patched-uptime.sh" ]; then
  mkdir -p ~/.tmux/plugins/tmux-tokyo-night/src/plugins
  cp "$SCRIPT_DIR/patched-uptime.sh" ~/.tmux/plugins/tmux-tokyo-night/src/plugins/uptime.sh
  echo "✓ Applied uptime -p patch"
  # clear powerkit cache so new uptime shows immediately
  rm -rf /tmp/tmux-powerkit* ~/.cache/tmux-powerkit 2>&1 || true
fi

echo ""
echo "Done! Run: tmux source-file ~/.tmux.conf  (or restart tmux)"
