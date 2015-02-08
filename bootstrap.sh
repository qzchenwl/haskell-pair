#!/usr/bin/env bash

cp /vagrant/config/sources.list /etc/apt/ -v
apt-get update -q
apt-get install gcc libgmp-dev alex happy curl libcurl4-gnutls-dev libpcre3-dev libffi-dev make python-software-properties vim ctags git tmux ruby ufw fail2ban xz-utils zsh -y -q

GHC_VER=7.8.3
CABAL_VER=1.20.0.3

if hash ghc 2>/dev/null; then
  echo "-----> GHC detected"
else
  GHC_FILE="ghc-$GHC_VER-x86_64-unknown-linux-deb7.tar.xz"
  GHC_URL="http://www.haskell.org/ghc/dist/$GHC_VER/$GHC_FILE"
  echo "-----> Downloading GHC $GHC_VER"
  if [ ! -e /vagrant/downloads/$GHC_FILE ]; then
    wget --quiet -O /vagrant/downloads/$GHC_FILE $GHC_URL
  fi
  tar xf /vagrant/downloads/$GHC_FILE -C /tmp
  cd /tmp/ghc-$GHC_VER
  echo "-----> Installing GHC $GHC_VER"
  ./configure
  make install
fi

if hash cabal 2>/dev/null; then
  echo "-----> Cabal detected"
else
  CABAL_FILE="cabal-install-$CABAL_VER.tar.gz"
  CABAL_URL="http://www.haskell.org/cabal/release/cabal-install-$CABAL_VER/$CABAL_FILE"
  echo "-----> Downloading cabal-install $CABAL_VER"
  if [ ! -e /vagrant/downloads/$CABAL_FILE ]; then
    wget --quiet -O /vagrant/downloads/$CABAL_FILE $CABAL_URL
  fi
  tar xf /vagrant/downloads/$CABAL_FILE -C /tmp
  cd /tmp/cabal-install-$CABAL_VER
  echo "-----> Installing cabal-install $CABAL_VER"
  ./bootstrap.sh --global --no-doc
fi

echo "-----> Saving system tmux.conf"
cp /vagrant/config/tmux.conf /etc

if hash wemux 2>/dev/null; then
  echo "-----> Wemux detected"
else
  echo "-----> Installing wemux"
  git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
  ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
  cp /vagrant/config/wemux.conf /usr/local/etc
fi

if hash gh-auth 2>/dev/null; then
  echo "-----> github-auth detected"
else
  echo "-----> Installing Github key-based auth"
  gem install github-auth
fi

echo "-----> Adding pairing scripts"
mkdir -p $HOME/bin
cp /vagrant/user-scripts/* $HOME/bin

echo "-----> Creating user 'friend'"
adduser friend
echo "wemux pair; exit" > /home/friend/.bash_profile

echo "-----> Firewalling everything except SSH"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

echo "-----> Hardening OpenSSH"
cp /vagrant/config/sshd_config /etc/ssh/sshd_config
