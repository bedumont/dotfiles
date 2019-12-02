# Profile file runs on login. Environmental variables live here.

# Export path:
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:$PATH

# Default programs:
export TERMINAL="st"
export EDITOR="vim"
export VISUAL="vim"
export BROWSER="qutebrowser"
export READER="zathura"
export FILE="vifm"

# Config files
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"

# Other programs
export LESS=-R  # to allow ANSI colors
export RANGER_LOAD_DEFAULT_RC=false
export SSH_KEY_PATH="~/.ssh/rsa_id"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Other exports
export BIB="$HOME/documents/papers/BIB.bib"
export KEYTIMEOUT=1
