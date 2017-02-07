# predictive
Method development for joint reporting and dynamics models for infectious disease.

# using this repository
This repository uses the R package remake to specify the order code is
run in. See remake.yaml for how
dependencies are specified (and the matching example yaml file for other
syntax).  The remake doc is in its github repo:
https://github.com/richfitz/remake

Remake does in-tree builds so to get a clean build:
- go to a directory where you want the tree
- run `git clone git@github.com:reichlab/predictive`
- go into the repo doing `cd predictive`
- run `Rscript -e 'remake::make()'` to build
- _do not add build output to the repository!!!!_

To edit the repository:
- go to a directory where you want the tree
- run `git clone git@github.com:reichlab/predictive`
- go into the repo doing `cd predictive`
- make specific changes
- use `git add <file>` to add specific files, never add output to the
  repo.
- `git commit -m '<message>'` as usual
- use `git push <remote> <local_branch>:<remote_branch>` to push to a
  remote branch of the repo.
- in the github interface merge your changes with a pull request

# subdirectories

## analysis
This directory is for analyzing model fits/predictions, comparing
them to data, etc... this makes it easier to run analysis separately
from vignettes/manuscripts.

## code
This directory is for code in package format either downloaded
or generated from within the project.

## data-processing
This directory is for code used to process download/process data
in prep for fitting.

## fits
This directory is for code to fit models to specific data sets.

## manuscripts
Self-explanatory (?)

## models
This directory is for code specifying models and model descriptions.
Code to use models goes in `fits` and code for simulating data goes in 
`simulation`.  Code for analysis of model results goes in `analysis`.

## simulation
This directory is for data simulation code.


