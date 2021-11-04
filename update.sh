#!/bin/bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
        echo "missing version"
        exit 1
fi

actionsRepos=(test1
	test2)

for repo in "${actionsRepos[@]}"; do
	echo $repo
	git clone --depth 1 git@github.com:irespaldiza/"$repo".git
	pushd "$repo"
	git config user.name "irespaldiza"
        git config user.email "irespaldiza@okteto.com"
        sed -iE 's_FROM\ okteto\/okteto\:latest_FROM\ okteto\/okteto\:'"$VERSION"'_' Dockerfile
        git add Dockerfile
        ret=0
        git commit -m "release $VERSION" || ret=1
        if [ $ret -ne 1 ]; then
                git push git@github.com:okteto/"$repo".git master
                git --no-pager log -1
        fi
        ghr -token "$GITHUB_TOKEN" -replace "$VERSION"
        ghr -token "$GITHUB_TOKEN" -delete "latest"
        popd
        rm -rf "$repo"
done
