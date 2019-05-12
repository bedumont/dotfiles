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

To add a git repo as a submodule :

	config submodule add https://github.com/anishathalye/dotbot dotbot
	config submodule update --init --recursive
	config add .gitmodules

When checking another branch out or cloning :

	config submodule --init --recursive
	config submodule update --recursive

To update submodules :

	config submodule update --init --remote


See [here](https://www.atlassian.com/git/tutorials/dotfiles) for detailed instructions
