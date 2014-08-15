#!/bin/bash
host_pattern=^.*\..*$
protocol_pattern=\/\/
ssh_pattern=^.*@.*\..*:.*$

# Check for git
git --version > /dev/null 2>&1
GIT_INSTALLED=$?

[[ $GIT_INSTALLED -ne 0 ]] && { echo "Install git before executing this script."; exit 0; }

# Get input for Git
repo_url=""
while [[ ! $repo_url =~ $ssh_pattern ]]; do
  if [[ $repo_url != "" ]]; then
    echo "Invalid Git SSH URL"
  fi
  read -p "Enter Git SSH URL: " repo_url
done

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
echo -e "\nGit URL\t$repo_url"
echo -e "Dev App Name\t\t$dev_app_name"
echo -e "Dev Host\t\t\t$dev_host\n"

read -p "Are these settings correct? " confirm
if [[ $confirm =~ ^[yY] ]]; then
  # Intialize new git repo
  set -e
  rm -rf .git
  git init

  git remote add origin $repo_url
  git checkout -b master
  # Add submodules from .gitmodules, if any
  if [ -e ".gitmodules" ] && [ -s ".gitmodules" ]; then
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

    rm tempfile
    rm modules.txt
  fi
  git submodule add $cookbooks_repo_url cookbooks
  git submodule update --init --recursive

  # Update Vagrantfile
  sed -i "" s/%DEV_APP_NAME%/$dev_app_name/g Vagrantfile
  sed -i "" s/%DEV_HOST%/$dev_host/g Vagrantfile

  #rm initialize.sh
else
  echo "Initialization cancelled"
fi