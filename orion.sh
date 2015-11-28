#!/bin/bash
#=========================================
#Build script for OrionOS

#Give command line argument for the device :  ./orion.sh <flags> <device>. 

#=========================================
#FLAGS - 
# s = sync | f= force sync | r=repair sync
# c = clean 
# d = default (dirty)
# p = clear prebuilt chromium
#=========================================

#COLORS -
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
end=$'\e[0m'

#=========================================

#SET THE HOME DIRECTORY
if  [ -d ".repo" ] && [ -d "vendor/orion" ] ; then
	printf "\n$blu Setting ORION_HOME to `pwd` $end\n"
	ORION_HOME=pwd
else
	printf "\n$red execute the script from home directory $end"
	exit 1
fi
#=========================================


if [ "$2" == "" ]; then			#No device name
	
	printf "\n$red No device name entered.$end $grn Select from the foll:\n$end"
	cat  `pwd`/vendor/orion/orion.devices
	
elif [ "$2" != "" ]; then		#Device name given. Check flags

	while getopts "s:f:r:c:p:d" opt; do
		case $opt in 
			s)					# sync
				printf "\n$blu Syncing repo$end\n"
				eval "repo sync -c --force-sync --force-broken --no-clone-bundle"
				printf "\n$blu Repo sync done$end\n"
				;;
				
			f)					# force sync 
				printf "\n$blu Force syncing repo$end\n"
				eval "repo sync -c --force-sync --force-broken --no-clone-bundle"
				printf "\n$blu Repo sync done$end\n"
				;;
			
			r)				#Fixed force sync 
				printf "\n$blu Fixing broken sync and syncing\n$end"
				printf " $red This step will remove your .repo/repo folder and resync repo projects. Continue (y/n)?$end"
				read ch
				if [ "$ch" == "y" ]; then
					printf "$blu removing .repo/repo\n$end"
					rm -rf ".repo/repo"
					eval "repo init -u git://github.com/TeamOrion/platform_manifest.git -b mm6.0"
					eval "repo sync -c --force-sync --force-broken --no-clone-bundle"


	
				elif [ "$ch" == "n" ]; then
					printf "$yel Aborted$end"
				else
					echo "$red Wrong option. Aborted$end"
				fi
				;;
			
			c)				#clean
				make clean
				;;
			
			p)				#clean prebuilt
				printf "\n$blu clearing prebuilt/chromium$end\n"
				rm -rf  prebuilts/chromium/$2
				;;
				
			d)				#default
				printf "$blu building dirty (default)$end\n"
				if [ -f "`$ORION_HOME`/out/target/product/$2/system/build.prop" ]; then
					printf "$yel removing build.prop of older build\n$end"
					rm  `$ORION_HOME`/out/target/product/$2/system/build.prop				
					rm  `$ORION_HOME`/out/target/product/$2/*.zip
					rm  `$ORION_HOME`/out/target/product/$2/*.zip.md5sum
				fi
				;;
			
			\?) 
				echo "$yel Usage ./orion.sh -[s][f][r][c][p][d] [device name]$end"
				exit 1
				;;
				
		esac
	done
	
	eval ". build/envsetup.sh"
	export USE_PREBUILT_CHROMIUM=1
	#Check official support
		if grep -Fxq $2 `pwd`/vendor/orion/orion.devices
			then
				
				printf "\n$blu $2 is officially supported$end\n"
				export ORION_RELEASE=true
			else
				printf "$grn\ndevice is not supported officially; building unofficially$end\n"
		fi
		
	# compile
	eval "brunch $2"
			
else 
	echo "$red Error$end"
fi
