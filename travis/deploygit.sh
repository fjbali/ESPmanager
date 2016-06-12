#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

echo "DEPLOY TO GIT"

SHA=`git rev-parse --verify HEAD`
cd /tmp/sticilface
mkdir -p projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1
cp -r /tmp/package/. projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1/
git config --global push.default simple
git config user.name "sticilface"
git config user.email "$COMMIT_AUTHOR_EMAIL"
git remote set-url origin https://github.com/sticilface/sticilface.github.io
git add .
git commit -m "Deploy to GitHub Pages: ${SHA}"
eval `ssh-agent -s`
#mkdir ~/.ssh
# rm ~/.ssh/id_rsa
cp /tmp/travis.key ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa  
#ssh -vT git@github.com

git push -v
# $SSH_REPO $TARGET_BRANCH
