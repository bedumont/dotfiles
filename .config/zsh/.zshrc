# vi mode
bindkey -v
# Example aliases
alias cfz="vim $HOME/.config/zsh/.zshrc" \
        cfi="vim ~/.config/i3/config" \
        suck="cd ~/.local/suckless" \
        pipinstall="pip install --user" \
        sourcez="source $HOME/.config/zsh/.zshrc" \
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

bindkey '^[[Z' reverse-menu-complete

zstyle ':completion:*' menu select

# Load zsh-syntax-highlignting
source /home/ben/.config/zsh/plugins/zsh-sudo/sudo.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Enable autocompletion
autoload -Uz compinit && compinit
