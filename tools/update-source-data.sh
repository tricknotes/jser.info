#!/bin/bash
# https://github.com/jser/source-data
declare currentDir=$(cd $(dirname $0);pwd)

# http://rcmdnk.github.io/blog/2013/12/08/computer-bash/
tmpDir=$(mktemp -d 2>/dev/null||mktemp -d -t tmp)

# items.jsonを作成する
node ${currentDir}/converter/all_in_one_JSON.js

lastCommit=$(git log --oneline | head -n 1)
# source-dataのall.min.jsonをアップデートする
git clone https://github.com/jser/source-data.git "${tmpDir}/source-data"
mv ${currentDir}/converter/items.json "${tmpDir}/source-data"

cd "${tmpDir}/source-data"
# git update
git add items.json
git commit -m "${lastCommit}"
if [ -z "${GH_TOKEN}" ]; then
    git push --force --quiet "https://github.com/jser/source-data.git" gh-pages:gh-pages > /dev/null
else
    git push --force --quiet "https://${GH_TOKEN}@github.com/jser/source-data.git" gh-pages:gh-pages > /dev/null
fi
# pop
cd -