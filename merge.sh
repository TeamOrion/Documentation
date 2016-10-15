#!/bin/bash

#COLORS -
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'


# Assumes source is in users home in a directory called "orion"
export ORIONPATH="${HOME}/orion"

# Set the tag you want to merge
export TAG="android-7.0.0_r14"

# Orion manifest is setup with path first, then repo name, so the path attribute is after 2 spaces, and the name within "" in it
for repos in $(grep 'remote="orion"' ${ORIONPATH}/.repo/manifests/default.xml  | awk '{print $2}' | cut -d '"' -f2)
do
echo -e ""
echo "$blu Merging $repos $end"
echo -e ""
cd $repos;
git fetch https://android.googlesource.com/platform/$repos $TAG -q && git merge --no-edit FETCH_HEAD;
if [ $? -ne 0 ];
then
echo "$repos" >> ${ORIONPATH}/failed
echo "$red $repos failed :C $end"
else
echo "$repos" >> ${ORIONPATH}/success
echo "$grn $repos succeeded $end"
fi
echo -e ""
cd ${ORIONPATH};
done

echo -e ""
echo -e "$red These repos failed $end"
cat ./failed
echo -e ""
echo -e "$grn These succeeded $end"
cat ./success
