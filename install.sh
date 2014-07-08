#!/bin/bash

set -e
rm -rf .git
git init

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' > tempfile

while read -u 3 path_key path
do
    url_key=$(echo $path_key | sed 's/\.path/.url/')
    url=$(git config -f .gitmodules --get "$url_key")
    echo "Updating $path";
    rm -rf $path; git submodule add $url $path;
done 3<tempfile

rm tempfile

while read line; do
    IFS=':' read -a array <<< "$line"
    echo "Updating ${array[0]}";
    cd "${array[0]}"; git checkout "${array[1]}"; cd ..;
done <modules.txt

rm modules.txt; rm install.sh;
