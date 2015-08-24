#! /bin/bash
# Author - Soham Jambhekar
# Copyrights OrionLP

# Give command line argument for the device ./orion.sh <device>

eval "cd ~/orion"


if [ "$1" != "" ]; then
	echo '1:repo sync and build, 2:build 3:fix repo sync'
	read choice

	#1. Repo sync

	if [ "$choice" == "1" ]; then
		eval "repo sync -j16"

	#2. Build

	elif [[ "$choice" == "1" || "$choice" == "2" ]]; then
		eval ". build/envsetup.sh"
		export USE_PREBUILT_CHROMIUM=1

		#Check official support
			if grep -Fxq $1 vendor/orion/orion.devices
			then
				echo "====$1 is officially supported===="
				export ORION_RELEASE=true
			else
				echo "device is not supported officially; building unofficially"
			fi
	
		#If prebuilt is cleaned, make sure to copy bootanimation there
			if [ ! -f "prebuilts/chromium/$1/media/bootanimation.zip" ]; then
				echo "let's copy bootanimation in the prebuilt directory"
				mkdir -p ~/orion/prebuilts/chromium/$1/media
				cp vendor/orion/config/media/bootanimation.zip prebuilts/chromium/$1/media/bootanimation.zip
				echo "Bootanimation copied"
			else
				echo "Bootanimation exists"
			fi

		# compile
			eval "brunch $1"

	#3. Fix repo sync

	elif [ "$choice" == "3" ]; then
		echo "this step will remove your .repo/repo folder and resync stuff. Continue (y/n)?"
		read r
		if [ "$r" == "y" ]; then
			echo "removing .repo/repo"
			
			rm -rf .repo/repo
			eval "repo init -u git://github.com/TeamOrion/platform_manifest.git -b lp5.1"
			eval "repo sync --force-sync -j4"
		elif [ "$r" == "n" ]; then
			echo "Aborted"
		else
			echo "Wrong option. Aborted"
		fi
	fi

# Wrong option

else
	echo "Error: enter proper device name. Select from -"
	cat "vendor/orion/orion.devices"
fi

