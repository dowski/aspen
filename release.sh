#!/bin/sh
confirm () {
    proceed=""
    while [ "$proceed" != "y" ]; do
        read -p"$1 (y/N) " proceed
        if [ "$proceed" == "n" -o "$proceed" == "N" -o "$proceed" == "" ]
        then
            return 1
        fi
    done
    return 0
}

confirm "Tag version $1 and upload to PyPI?"
if [ $? -eq 0 ]; then
    printf "$1" > version.txt
    git commit --all -m"Version bump for release."
    git tag $1

    git push
    git push --tags

    python setup.py sdist --formats=zip,gztar,bztar upload

    printf "+" >> version.txt
    git commit --all -m"Version bump post-release."
    git push
fi
