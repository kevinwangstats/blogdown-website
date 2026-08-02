#!/bin/bash

set -e  # Exit immediately if any command fails

source_code_repo="/Users/kevinwang/projects/kevinwangstats-blogdown-website"

if [ "$(pwd)" == "$source_code_repo" ]; then
  echo "Local blogdown path was verified, proceeding to update procedures."

  # Change directory and verify success
  cd "$source_code_repo" || { echo "Failed to change directory. Exiting."; exit 1; }

  echo "Using blogdown to build the website"
  R -e "blogdown::build_site()" || { echo "R command failed. Exiting."; exit 1; }

  # Change to public directory and verify success
  cd "$source_code_repo/public" || { echo "Failed to change to public directory. Exiting."; exit 1; }

  echo "Adding and committing all contents in the public repo"
  git add -A
  git commit -m "Update website" || { echo "Git commit failed. Exiting."; exit 1; }

  ls  # List contents for verification

  echo "Pushing public site to kevinwangstats (triggers Cloudflare Pages build)"
  git push kws master || { echo "Git push to kws failed. Exiting."; exit 1; }

  echo "Pushing source code to kevinwangstats"
  cd "$source_code_repo" || { echo "Failed to change back to source repo. Exiting."; exit 1; }
  git add -A
  git commit -m "Update website" || { echo "Git commit for source repo failed. Exiting."; exit 1; }

  git push kws master || { echo "Git push of source repo to kws failed. Exiting."; exit 1; }

  echo "Completed updates. Exiting program."

else
  echo "Wrong blogdown path. Exiting program."
  exit 1
fi


