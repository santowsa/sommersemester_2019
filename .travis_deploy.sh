#!/bin/sh
set -e #Exit with nonzero exit code if anything fails

#zip _site for oer upload
cd _site
zip -r ../oer.zip assets content images units index.html intro.html motivation.html search.html
cd ..
python oer_upload.py

#switch urls in jekyll _config for github deploy
sed -i '27,28s/^/#/' _config.yml
sed -i '31,32s/#//' _config.yml

make book && make site


openssl aes-256-cbc -K $encrypted_9d525ff4942a_key -iv $encrypted_9d525ff4942a_iv -in deploy-key.enc -out deploy-key -d
chmod 600 deploy-key
eval `ssh-agent -s`
ssh-add deploy-key

./node_modules/.bin/gh-pages -d _site/ -b gh-pages -r git@github.com:${TRAVIS_REPO_SLUG}.git

