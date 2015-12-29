We are glad that you're looking into this! If you've compiled before, you won't really need to have a look into this. However, let's do this:
Pre reqs -
follow this guide http://forum.xda-developers.com/chef-central/android/guide-android-rom-development-t2814763
Thanks jack

Open Linux terminal

Make a directory for OrionOS. This folder will contain the whole source code. The ~/ is to make the folder in home:

mkdir ~/orion

Enter into the folder:

cd orion

Initiate the Orion repo. this will set up repo tool :

repo init -u git://github.com/TeamOrion/platform_manifest.git -b mm6.0

To add device specifics, do the following:

cd .repo && mkdir local_manifests
nano .repo/local_manifests/roomservice.xml

Add your device tree, kernel source, proprietory vendor and whatever you want to add/remove. Look at the existing local_manifest in the Documentation for a general idea.

Sync the project:

repo sync -j#
For exp. repo sync -j16

Make device tree compatible with orion. Have a look at other Orion device trees to get some idea.

Time to compile! 
Check the script orion.sh in the main directory

Compile using - 

./orion.sh -[s][f][r][c][p][d] [device name]
 s = sync | f= force sync | r=repair sync
 c = clean 
 d = default (dirty)
 p = clear prebuilt chromium
 
the zip will be ready for you in out/target/product/<device>

Good luck! May the source be with you! 
