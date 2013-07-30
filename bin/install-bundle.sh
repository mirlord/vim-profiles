#!/bin/sh

if [ "$#" = "0" ];then
  echo "Usage: "
  echo "  install-bundle.sh <bundle-git-repository> <bundle-installation-path>"
  echo ""
  echo "Example:"
  echo "  install-bundle.sh https://github.com/tpope/vim-pathogen/ system/pathogen"
  echo "  install-bundle.sh https://github.com/mirlord/vim-profiles/ system/profiles"
  echo ""
  exit 1
fi

if [ ! -d "./.git" ]; then
  echo "Script must be run from the git repo root directory"
  exit 2
fi

bundle_repo="$1"
bundle_path="$2"
bundle_name="`basename $bundle_path`"

bundle_path_parent=`dirname $bundle_path`
mkdir -p $bundle_path_parent

(cd `dirname $bundle_path` && git clone $bundle_repo $bundle_name)
git submodule add $bundle_repo $bundle_path
git commit -m "$bundle_name added as a submodule" .gitmodules $bundle_path

