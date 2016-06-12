#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

echo "DEPLOY TO GIT"

SHA=`git rev-parse --verify HEAD`
cd /tmp/sticilface
mkdir -p projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1
cp -r /tmp/package/. projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1/
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"
git add .
git commit -m "Deploy to GitHub Pages: ${SHA}"
eval `ssh-agent -s`
ssh-add /tmp/travis.key  

git push -v
# $SSH_REPO $TARGET_BRANCH