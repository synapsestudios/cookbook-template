# Template for project cookbooks

### Creating a new cookbooks repository
1. Create a new repository on github called `<project-name>-cookbooks`.
1. Run `git clone git@github.com:synapsestudios/cookbook-template.git <project-name>-cookbooks`.
1. Run the initialization script `chmod +x initialize.sh; ./initialize.sh` from the cookbooks directory. It will ask for:
    - Repository SSH clone URL
    - Development App Name environment variable
    - Development Host Name
1. Commit the files and submodules to master and push to origin.
1. Add the cookbooks repository to the main project (see [api-template README](https://github.com/synapsestudios/api-template) for more details).
