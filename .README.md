# BEDUMONT DOTFILES

> One repo to configure them all

To init:

    git init --bare $HOME/.myconfig 
	alias config="/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME"
	config config --local status.showUntrackedFiles no
To clone :

    git clone --bare <repo> $HOME/.myconfig
    alias config="/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME"
	config checkout
	config config --local status.showUntrackedFiles no

See [here](https://www.atlassian.com/git/tutorials/dotfiles) for detailed instructions
