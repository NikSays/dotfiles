# Dotfile install

First, add ssh keys to github
`ssh-keygen` may be needed.

`git clone --recursive --bare git@github.com:NikSays/dotfile-repo.git $HOME/.dotfile-repo`

`git --git-dir=$HOME/.dotfile-repo/ --work-tree=$HOME checkout`
