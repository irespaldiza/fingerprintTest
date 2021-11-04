#!/bin/bash
set -e

VERSION=0.1

if [ -z "$VERSION" ]; then
        echo "missing version"
        exit 1
fi

actionsRepos=(test1
	)

for repo in "${actionsRepos[@]}"; do
	echo $repo
	git clone --depth 1 git@github.com:irespaldiza/"$repo".git
	pushd "$repo"
	git config user.name "irespaldiza"
        git config user.email "irespaldiza@okteto.com"
        sed -iE 's_FROM\ okteto\/okteto\:latest_FROM\ okteto\/okteto\:'"$VERSION"'_' Dockerfile
        git add .
        ret=0
        git commit -m "release $VERSION" || ret=1
        if [ $ret -ne 1 ]; then
                git push git@github.com:okteto/"$repo".git master
                git --no-pager log -1
        fi
        popd
        rm -rf "$repo"
done
