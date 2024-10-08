#!/bin/bash

# Function to concat config
concat_config() {
    local name="$1"
    local file="$name.lua"
    local filepath="$name/$file"
    cp "$filepath" "tmp_$file"
    echo "$(ghead -n -2 config/config.lua)" "\n\n" "$(cat $file)" > "tmpnew_$file"
    mv "tmpnew_$file" "$filepath"
}

# Function to revert to previous state
revert_state() {
    local name="$1"
    local file="$name.lua"
    local filepath="$name/$file"
    mv "tmp_$file" "$filepath"
    rm -f "tmpnew_$file"
}

# Concat configs
concat_config "props"
concat_config "squads"

# Git operations
git add .
git commit -m "x"
git push origin main

# Revert to previous state
revert_state "props"
revert_state "squads"

# copy commit id
git rev-parse HEAD | pbcopy
