#!/bin/bash
set -e



actionsRepos=(
        test1
	)

for repo in "${actionsRepos[@]}"; do
	echo $repo
	git clone --depth 1 git@github.com:irespaldiza/"$repo".git
	cd "$repo"
	git config user.name "irespaldiza"
        git config user.email "irespaldiza@okteto.com"
        d=$(date)
        echo $d > test.txt
        git add .
        ret=0
        git commit -m "release $d" || ret=1
        if [ $ret -ne 1 ]; then
                git push
        fi
        cd -
        rm -rf "$repo"
done
