if [ ! -e $HOME/.haskell-vim-now/bin ]; then
  echo "-----> Retrieving prebuilt ghc-mod etc"
  git clone https://github.com/begriffs/haskell-vim-now.git $HOME/.haskell-vim-now
fi

echo "-----> Installing/updating haskell-vim-now"
curl --silent -o - https://raw.githubusercontent.com/begriffs/haskell-vim-now/master/install.sh | bash
