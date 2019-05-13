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

To remove a submodule you need to:

    Delete the relevant section from the .gitmodules file.
    Stage the .gitmodules changes git add .gitmodules
    Delete the relevant section from .git/config.
    Run git rm --cached path_to_submodule (no trailing slash).
    Run rm -rf .git/modules/path_to_submodule (no trailing slash).
    Commit git commit -m "Removed submodule "
    Delete the now untracked submodule files rm -rf path_to_submodule


See [here](https://www.atlassian.com/git/tutorials/dotfiles) for detailed instructions
