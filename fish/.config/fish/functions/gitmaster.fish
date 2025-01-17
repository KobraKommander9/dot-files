#!/usr/bin/env fish

function gitmaster -d "checkout master branch, update, and clean other branches"
    git checkout master && git pull && gitclean
end
