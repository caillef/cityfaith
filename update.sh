#!/bin/bash

# files to add config
configs=("props" "squads")
concatfiles=("config" "common")

# Function to concat config
concat_config() {
    local name="$1"
    local file="$name.lua"
    local filepath="$name/$file"
    cp "$filepath" "tmp_$file"
    local content=""
    for concatfile in "${concatfiles[@]}"
    do
        content+="$(ghead -n -2 $concatfile/$concatfile.lua)\n\n"
    done
    echo -e "$content$(cat $filepath)" > "tmpnew_$file"
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
for config in "${configs[@]}"
do
    concat_config "$config"
done

# Git operations
git add .
git commit -m "x"
git push origin main

# Revert to previous state
for config in "${configs[@]}"
do
    revert_state "$config"
done

# copy commit id
git rev-parse HEAD | cut -c1-8 | pbcopy
