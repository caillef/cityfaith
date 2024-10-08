cp props/props.lua tmpprops.lua
echo `ghead -n -2 config/config.lua` "\n\n" `cat props/props.lua` > tmpnewprops.lua
mv tmpnewproprs.lua props/props.lua

git add .
git commit -m "x"
git push origin main

cp tmpprops.lua props/props.lua

# rm tmpprops.lua tmpnewprops.lua

# copy commit id
git rev-parse HEAD | pbcopy
