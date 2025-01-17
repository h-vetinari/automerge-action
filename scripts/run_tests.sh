#!/bin/bash

set -e

export CONDA_SMITHY_LOGLEVEL=DEBUG

pushd cf-autotick-bot-test-package-feedstock

git reset --hard HEAD
git checkout master
git pull upstream master
git pull
git push

python ../move_to_dev_branch.py

python ../make_extra_commit.py azure azure $1

python ../make_no_merge_user.py azure azure $1

for linux in travis azure circle; do
  python ../make_ci_fail.py circle ${linux} $1
  for osx in azure; do
    python ../make_prs.py ${linux} ${osx} $1
  done
done

python ../make_prs.py circle circle $1

popd
