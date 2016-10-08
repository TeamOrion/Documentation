#!/usr/bin/env bash
# Assumes source is in users home in a directory called "orion"
export ORIONPATH="${HOME}/orion"
export TAG="android-6.0.1_r72"

for repos in $(grep 'remote="orion"' ${ORIONPATH}/.repo/manifests/default.xml  | awk '{print $2}' | cut -d '"' -f2)
do
export path=$pwd;
cd $repos;
git fetch https://android.googlesource.com/platform/$repos && git merge $TAG;
if [ $? -ne 0 ];
then
echo "$repos" >> failed
else
echo "$repos" >> success
fi
cd $path ; done

