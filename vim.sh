if [ ! -e $HOME/.haskell-vim-now/bin ]; then
  echo "-----> Retrieving prebuilt ghc-mod etc"
  git clone https://github.com/begriffs/haskell-vim-now.git $HOME/.haskell-vim-now
  if [ -e /vagrant/downloads/binaries.tar.xz ]; then
    echo "-----> Extracting prebuilt ghc-mod etc"
    mkdir -pv $HOME/.haskell-vim-now/bin
    tar xvf /vagrant/downloads/binaries.tar.xz -C $HOME/.haskell-vim-now/bin
  fi
fi

echo "-----> Installing/updating haskell-vim-now"
curl --silent -o - https://raw.githubusercontent.com/begriffs/haskell-vim-now/master/install.sh | bash

cp /vagrant/.vimrc.local $HOME

vim +BundleInstall +qa
