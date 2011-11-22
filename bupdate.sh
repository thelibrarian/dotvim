#!/bin/sh

utd="Already up-to-date."

git checkout -q master

cd bundle

for bundle in *; do
  if [ -d $bundle ] && [ -d ${bundle}/.git ]
  then
    printf "%s: " $bundle
    cd $bundle
    git checkout -q master
    result=$(git pull)
    if [ "$result" = "$utd" ]
    then
      echo $result
    else
      echo "Updated."
    fi
    cd ..
  fi
done

cd ..

git status
