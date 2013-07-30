#!/bin/sh

if [ "$#" = "0" ];then
  echo "Usage: "
  echo "  delete-bundle.sh <bundle-path>"
  echo ""
  echo "Example:"
  echo "  delete-bundle.sh bundle/solarized"
  echo ""
  exit 1
fi

if [ ! -d "./.git" ]; then
  echo "Script must be run from the git repo root directory"
  exit 2
fi

submodulepath="$1"
bundle_name="`basename $1`"

git config -f .git/config --remove-section submodule.$submodulepath
git config -f .gitmodules --remove-section submodule.$submodulepath
git rm --cached $submodulepath

git add .gitmodules
git commit -m "remove bundle: $bundle_name"

rm -rf $submodulepath
rm -rf .git/modules/$submodulepath

