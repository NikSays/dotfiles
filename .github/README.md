# Install

First, install [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)
```shell
git clone --bare git@github.com:NikSays/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --recursive --init
```
