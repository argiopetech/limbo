#!/bin/bash

## Provides some additional useful functionality for Limbo
##
## I keep these around as things that might be important in future, but that I'm not using now.

# Commits the contents of the test directory, assuming they've changed
#
# -uno ensures this is a silent step; otherwise, you get two commit messages (or a commit message
# -and a failure + reversion message, which is fairly confusing and definitely not pretty.
function addTests() {
    PROJECT_BASE=$(git rev-parse --show-toplevel)

    git add "${PROJECT_BASE}/test" > /dev/null
    git commit -uno -m "wip" > /dev/null
}


# Creates a feature branch off of develop with a consistent naming scheme
#
# I previously used this to make bigger changes in an isolated branch with limbo, squash those
# changes to a feature, and merge the feature (potentially with some type of code review). I no
# longer use this because I make all commits to master and ensure they don't break anything.
#
# Params:
#   Takes the rest of the command line, expected valid branch name
#   Invalid branch names cause git errors but leave you with develop checked out.
function feature() {
    git checkout develop && git checkout -b "feature/$@"
}


# Squashes all commits with the commit summary "wip" to a single commit
#
# This doesn't currently work because the commit message has changed. Either way, I don't use it
# because I've stopped caring about pretty history.
function cleanupWIP() {
    local FIRST_WIP=$(git log --grep=wip | grep commit | tail -n 1 | awk '{ print $2; }')

    ! tc                && return $?
    [[ -z $FIRST_WIP ]] && echo "Nothing to clean up." && return 0

    git reset --soft ${FIRST_WIP}~
    git commit -a
}


# Does the same thing as cleanupWIP, but requires some manual work to decide which commits to
# squash.
#
# In retrospect, this function and cleanupWIP should probably switch names.
function squash() {
    local BRANCH=$(git symbolic-ref --short -q HEAD)
    local FIRST_WIP=$(git log --grep=wip | grep commit | tail -n 1 | awk '{ print $2; }')

    ! tc                && return $?
    [[ -n $FIRST_WIP ]] && echo -e "\nFound work in progress. Call cleanupWIP?" && return 1

    git rebase -i develop "$BRANCH"
}


# Reloads the limbo functions library and runs tcr-sync automatically any time a file is changed
#
# Due to -d flag, this does work properly when new files are added.
function tcr-loop() {
    while :; do
        git ls-files | entr -dcs "source bash_limbo ; tcr-sync"
    done
}
