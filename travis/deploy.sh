#!/bin/bash
set -e # Exit with nonzero exit code if anything fails


echo "script started"
mkdir /tmp/package
cp "/tmp/build/.pioenvs/nodemcu/firmware.bin" "/tmp/package/"
cp -r "examples/ESPmanager-example/data" "/tmp/package/"
ls /tmp/package/

# generate the manifest
python $TRAVIS_BUILD_DIR/travis/buildmanifest.py /tmp/package /tmp/package/manifest.json

#  no host checking
#ssh -v -p 4022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/travis.key $HOME_USER@$HOME_IP "mkdir -p ~/projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/latest/"
#scp -v -P 4022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/travis.key -rp /tmp/package/. "$HOME_USER@$HOME_IP:~/projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/latest/"  
#echo "repo slug = $TRAVIS_REPO_SLUG"

echo "DEPLOY HOME"
 
ssh -v -p 4022  -i /tmp/travis.key $HOME_USER@$HOME_IP "mkdir -p ~/projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1/"
scp -v -P 4022  -i /tmp/travis.key -rp /tmp/package/. "$HOME_USER@$HOME_IP:~/projects/$TRAVIS_REPO_SLUG/$TRAVIS_BRANCH/$1/"  

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

git push
# $SSH_REPO $TARGET_BRANCH


