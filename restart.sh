#!/bin/bash
# Script to download individual .nc files from the ORNL
# Daymet server at: http://daymet.ornl.gov

git pull

docker build -t gfpgan .

docker run -it --gpus all --volume="/home/featurize/work/tmp:/home/appuser/tmp" --rm --name gfpgan-running gfpgan