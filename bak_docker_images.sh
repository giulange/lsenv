#!/bin/bash
# This script save in tar.gz all the GCI images.
# All the *.run files used to run containers are used to get 
# the labels of the images.
#
# USAGE:
# ./bak_docker_images.sh dev
#
# DELETE or save elsewhere:
# TO REMOVE DANGLING IMAGES:
# docker images --filter "dangling=true"

defval="dev"
ENV=${1:-$defval}

PATH_IN_CONTAINERS="/opt/lsenv/run"
PATH_OUT_IMAGES="/opt/lsenv/docker_images/$ENV"

for f in $(ls $PATH_IN_CONTAINERS/*.run);
do
  #echo "$f"
  filename=$(basename -- "$f")
  #echo "$filename"
  #extension="${filename##*.}"
  #echo "$extension"
  fname_noext="${filename%.*}"
  #echo "$fname_noext"

  if [ "$(docker images -q $fname_noext)" != "" ]; then
    echo "image $fname_noext exists, saving..."
    echo "docker save $fname_noext | gzip > $PATH_OUT_IMAGES/${fname_noext}_save_$(date '+%Y-%m-%dT%H%M').tar.gz"
    docker save $fname_noext | gzip > $PATH_OUT_IMAGES/${fname_noext}_save_$(date '+%Y-%m-%dT%H%M').tar.gz
    echo "...done!"
    echo ""

  elif [ "$(docker images -q $fname_noext)" == "" ]; then
    echo "image $fname_noext does not exist, skipped!"
    echo ""
  
  fi
done

