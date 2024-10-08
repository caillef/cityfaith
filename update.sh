#!/bin/bash

# Function to concat config
concat_config() {
    local file="$1"
    cp "$file" "tmp_$file"
    echo "$(ghead -n -2 config/config.lua)" "\n\n" "$(cat $file)" > "tmpnew_$file"
    mv "tmpnew_$file" "$file"
}

# Function to revert to previous state
revert_state() {
    local file="$1"
    mv "tmp_$file" "$file"
    rm -f "tmpnew_$file"
}

# Concat configs
concat_config "props/props.lua"
concat_config "squads/squads.lua"

# Git operations
git add .
git commit -m "x"
git push origin main

# Revert to previous state
revert_state "props/props.lua"
revert_state "squads/squads.lua"

# copy commit id
git rev-parse HEAD | pbcopy
