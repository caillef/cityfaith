#!/bin/bash

# files to add config
filesToUpgrade=("props" "squads" "city")
concatfiles=("config" "common" "progressbar" "ui_blocks")

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

# Concat fileToUpgrade
for fileToUpgrade in "${filesToUpgrade[@]}"
do
    concat_config "$fileToUpgrade"
done

# Git operations
git add .
git commit -m "x"
git push origin main

# Revert to previous state
for fileToUpgrade in "${filesToUpgrade[@]}"
do
    revert_state "$fileToUpgrade"
done

# copy commit id
commit_hash=$(git rev-parse HEAD | cut -c1-8)
sed -i '' "1s/.*local COMMIT_HASH.*/local COMMIT_HASH = \"$commit_hash\"/" world.lua

cat world.lua | pbcopy
