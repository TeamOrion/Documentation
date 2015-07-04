We are glad that you're looking into this! If you've compiled before, you won't really need to have a look into this. However, let's do this:

Make a directory for OrionLP:

mkdir orion

Enter into the folder:

cd orion

Initiate the Orion repo:

repo init -u git://github.com/TeamOrion/platform_manifest.git -b lp5.1

To add device specifics, do the following:

cd .repo && mkdir local_manifests
nano .repo/local_manifests/roomservice.xml

Add you device tree, kernel source, proprietory vendor and whatever you want to add/remove.

Sync the project:

repo sync -j#
For exp. repo sync -j16

Make device tree compatible with orion. Have a look at other Orion device trees to get some idea.

Time to compile! 

. build/envsetup.sh 
breakfast *device name*
export USE_PREBUILT_CHROMIUM=1 
brunch *device name*

Good luck! May the force be with you! 
