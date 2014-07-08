# Template for project cookbooks

### Creating a new cookbooks repository
1. Run `git clone git@github.com:synapsestudios/cookbook-template.git [project-name]-cookbooks`
1. Open the new cookbooks directory
1. Run `chmod +x install.sh; ./install.sh`
1. Create a new empty repository on github
1. Add the new repository as the remote origin
1. Update the development and qa roles
1. Commit the files and submodules to master and push to origin
1. Open the main project repository
1. Run `git submodule add [new-cookbooks-repo-url] cookbooks`
1. Run `git submodule update --init --recursive`
