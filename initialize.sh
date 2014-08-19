#!/bin/bash
host_pattern=^.*\..*$
protocol_pattern=\/\/
ssh_pattern=^.*@.*\..*:.*$

# Check for git
git --version > /dev/null 2>&1
GIT_INSTALLED=$?

[[ $GIT_INSTALLED -ne 0 ]] && { echo "Install git before executing this script."; exit 0; }

test_init=false
while getopts ":t" opt; do
  case $opt in
    t) test_init=true;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
  esac
done

# Get input for Git
if [[ $test_init == false ]]; then
  repo_url=""
  while [[ ! $repo_url =~ $ssh_pattern ]]; do
    if [[ $repo_url != "" ]]; then
      echo "Invalid Git SSH URL"
    fi
    read -p "Enter Git SSH URL: " repo_url
  done
fi

# Get input for Chef Roles
dev_app_name=""
while [[ $dev_app_name == "" ]]; do
  read -p "Enter Dev App Name [project-name]: " dev_app_name
done

dev_host=""
while [[ ! $dev_host =~ $host_pattern ]] || [[ $dev_host =~ $protocol_pattern ]]; do
  read -p "Enter Dev Host [domain only]: " dev_host
done

# Confirm settings are correct
echo -e "\n"
if [[ $test_init == false ]]; then
  echo -e "Git URL\t\t$repo_url"
fi

echo -e "Dev App Name\t$dev_app_name"
echo -e "Dev Host\t$dev_host"
echo -e "\n"

read -p "Are these settings correct? " confirm
if [[ $confirm =~ ^[yY] ]]; then

  # Collect submodule information
  git config -f .gitmodules --get-regexp '^submodule\..*\.path$' > /tmp/gitmodules.txt
  while read -u 3 path_key path
  do

      url_key=$(echo $path_key | sed 's/\.path/.url/')
      url=$(git config -f .gitmodules --get "$url_key")

      status=($(git ls-tree master $path))
      commit=${status[2]}

      echo "$path $commit $url" >> /tmp/modules.txt
  done 3</tmp/gitmodules.txt

  rm /tmp/gitmodules.txt

  # Intialize new git repo
  set -e
  rm -rf .git
  git init

  if [[ $test_init == false ]]; then
    git remote add origin $repo_url
  fi

  git checkout -b master

  # Apply specific submodules
  while read line; do
      IFS=" " read -a array <<< "$line"

      path=${array[0]}
      commit=${array[1]}
      url=${array[2]}

      echo "Updating $path to $commit"
      rm -rf $path
      git submodule add $url $path 2>&1 >/dev/null

      cd $path
      git checkout $commit 2>&1 >/dev/null
      cd ..
  done </tmp/modules.txt

  rm /tmp/modules.txt

  # Update Vagrantfile
  sed -i "" s/%DEV_APP_NAME%/$dev_app_name/g './roles/development.rb'
  sed -i "" s/%DEV_HOST%/$dev_host/g './roles/development.rb'

  rm initialize.sh
else
  echo "Initialization cancelled"
fi
