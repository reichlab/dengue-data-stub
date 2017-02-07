# dengue-data-stub
Project stub for an R project dealing with the Dengue data database.


# using this repository
This repository uses the R package remake to specify the order code is
run in. See remake.yaml for how
dependencies are specified (and the matching example yaml file for other
syntax).  The remake doc is in its github repo:
https://github.com/richfitz/remake

Remake does in-tree builds so to get a clean build:
- go to a directory where you want the tree
- run `git clone git@github.com:reichlab/dengue-data-stub`
- go into the repo doing `cd dengue-data-stub`
- run `Rscript -e 'remake::make()'` to build
- _do not add build output to the repository!!!!_

To edit the repository:
- go to a directory where you want the tree
- run `git clone git@github.com:reichlab/dengue-data-stub`
- go into the repo doing `cd dengue-data-stub`
- make specific changes
- use `git add <file>` to add specific files, never add output to the
  repo.
- `git commit -m '<message>'` as usual
- use `git push <remote> <local_branch>:<remote_branch>` to push to a
  remote branch of the repo.
- in the github interface merge your changes with a pull request
- in scripts/setup/connect.R you might need to modify the path to 
  your credentials file and server.

