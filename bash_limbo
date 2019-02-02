#!/bin/bash

function runTests() {
    stack test --silent --fast 2>/dev/null
}

function wip() {
    git add . && git commit -m "Limbo-ing! See tags/releases for what you'd normally expect in a commit message."
}

function revert() {
    git reset --hard
}

function addTests() {
    PROJECT_BASE=$(git rev-parse --show-toplevel)

    git add "${PROJECT_BASE}/test" > /dev/null
    git commit -uno -m "wip" > /dev/null
}

function cleanupWIP() {
    local FIRST_WIP=$(git log --grep=wip | grep commit | tail -n 1 | awk '{ print $2; }')

    ! tc                && return $?
    [[ -z $FIRST_WIP ]] && echo "Nothing to clean up." && return 0

    git reset --soft ${FIRST_WIP}~
    git commit -a
}

function tc() {
    runTests || ( local RET=$?; stack test; return $RET; ) && echo && wip
}

function tcr() {
    tc || revert
}

function feature() {
    git checkout develop && git checkout -b "feature/$@"
}

function squash() {
    local BRANCH=$(git symbolic-ref --short -q HEAD)
    local FIRST_WIP=$(git log --grep=wip | grep commit | tail -n 1 | awk '{ print $2; }')

    ! tc                && return $?
    [[ -n $FIRST_WIP ]] && echo -e "\nFound work in progress. Call cleanupWIP?" && return 1

    git rebase -i develop "$BRANCH"
}

function tcr-loop() {
    while :; do
        git ls-files | entr -dcs "source functions.sh ; tcr-sync"
    done
}

function tcr-sync() {
        reset

        tcr
        TCR_RET=$?

        while ( ! git pull -q --rebase ); do
            echo "Press <enter> to re-try the pull."
            read
        done
        
        if [[ $TCR_RET -eq 0 ]]; then
            runTests >/dev/null || ( clear; runTests ; false; ) && git push
        fi
}

function limbo() {
    while : ; do
        tcr-sync
        
        echo
        read -s -p "<enter> to test && commit || revert "
    done
}
