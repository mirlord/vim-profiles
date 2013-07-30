#!/bin/sh

if [ "$#" = "0" ];then
  echo "Usage: "
  echo "  move-bundle.sh <bundle-old-path> <bundle-new-path>"
  echo ""
  echo "Example:"
  echo "  move-bundle.sh bundle/localvimrc profiles/base/localvimrc"
  echo ""
  exit 1
fi

if [ ! -d "./.git" ]; then
  echo "Script must be run from the git repo root directory"
  exit 2
fi

old_path="$1"
old_name="`basename $old_path`"

new_path="$2"
new_name="`basename $new_path`"

repo=`(cd $old_path; git remote show origin | grep 'Fetch URL:' | cut -d ' ' -f 5 | sed "s/^git/https/")`
ref=`(cd $old_path; git show-ref --head | grep -e ' HEAD$' | cut -d ' ' -f 1)`
if [ "x$repo" == "x" ]; then
  exit 1
fi

git config -f .git/config --remove-section submodule.$old_path
git config -f .gitmodules --remove-section submodule.$old_path
git rm --cached $old_path
git add .gitmodules

rm -rf .git/modules/$old_path
rm -rf $old_path

(cd `dirname $new_path` && git clone $repo $new_name && cd $new_name && git checkout $ref)
git submodule add $repo $new_path
git commit -am "$old_name moved to $new_path"

