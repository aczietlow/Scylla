#! /bin/bash

set -e

# Get the full path of the dir the bash script is in.
top=$(dirname $0)/..
pushd $top &>/dev/null
base=$PWD

settings=$base/www/sites/default/settings.php
confd='cnf/default'

if [[ ! -d www ]]; then
  mkdir www
fi

if [[ -d $base/www/sites/all/modules/custom ]]; then
  mkdir $base/www/sites/all/modules/custom
fi

if [[ -d $base/www/sites/all/modules/contrib ]]; then
  mkdir $base/www/sites/all/modules/contrib
fi

if [[ -d www ]]; then
  chmod -R +w www/sites/default
fi

if [[ ! -d $base/www/sites/default/files ]]; then
  mkdir $base/www/sites/default/files
fi

if [[ -d features ]]; then
  if [[ -d $base/www/sites/all/modules/features ]]; then
    rm -Rf $base/www/sites/all/modules/features
  fi

  ln -s $base/features $base/www/sites/all/modules/
fi


chmod -R g+w www/sites/default