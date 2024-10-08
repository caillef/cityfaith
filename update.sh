# Function to concat config
concat_config() {
    local file="$1"
    cp "$file" "tmp$file"
    echo "`ghead -n -2 config/config.lua`" "\n\n" "`cat $file`" > "tmpnew$file"
    cp "tmpnew$file" "$file"
}

# Function to revert to previous state
revert_state() {
    local file="$1"
    cp "tmp$file" "$file"
    rm "tmp$file" "tmpnew$file"
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
