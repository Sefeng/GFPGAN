#!/bin/bash
# Script to download individual .nc files from the ORNL
# Daymet server at: http://daymet.ornl.gov

git pull

docker build -t gfpgan .

docker run -d --gpus all --volume="/home/featurize/work/tmp:/home/appuser/tmp" -p 5000:5000 --name gfpgan-running gfpgan


docker exec -it gfpgan-running bash