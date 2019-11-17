# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:$PATH
#export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
export LESS=-R  # to allow ANSI colors
export TERMINAL=st
export FILE=vifm
export EDITOR=vim
export VISUAL=vim
export RANGER_LOAD_DEFAULT_RC=false
export BROWSER=qutebrowser
export BIB="$HOME/documents/papers/BIB.bib"

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bureau"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
#DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  sudo
  git
  battery
  z
)


# User configuration
setopt correct

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias cfz="vim ~/.zshrc" \
        cfi="vim ~/.config/i3/config" \
        suck="cd ~/.local/suckless" \
        pipinstall="pip install --user" \
        sourcez="source ~/.zshrc" \
        MA2="cd ~/ULB/MA2-Polytech" \
        mfe="cd ~/ULB/MA2-Polytech/MFE" \
        MFE="cd ~/ULB/MA2-Polytech/MFE; source ~/ULB/MA2-Polytech/MFE/venv/bin/activate" \
        config="/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME" \
        mutt='cd ~/attachments && mutt' \
        suckclean="make clean && rm  -f config.h && git reset --hard origin/master" \
        fixwifi="sudo ip link set wlp3s0 down" \
        updt="sudo pacman -Syu && pkill -RTMIN+9 dwmblocks" \
        pinstall="sudo pacman -S" \
        mpvrecord="mpv --demuxer-lavf-format video4linux2 --demuxer-lavf-o-set input_format=mjpeg av://v4l2:/dev/video0" \
        x="sxiv -ft *" \
        hh="cd ~/" \
        pp="cd ~/pictures" \
        ddd="cd ~/documents" \
        bb="cd ~/builds" 

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
bindkey '^[[Z' reverse-menu-complete

# Load zsh-syntax-highlignting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Node version manager
source /usr/share/nvm/init-nvm.sh
