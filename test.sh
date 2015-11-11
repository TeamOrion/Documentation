#=========================================
#Build script for OrionOS
#Copy or link this file from Documentation to the root folder or run it from documentation for the first time
#To link, do ln -s Documentation/orion.sh . 
#Give command line argument for the device ./orion.sh <flags> <device>. 
#Kill the process using Control + C

#=========================================

#=========================================
#ENVIRONMENT VARIABLES
#Set your environment variables (some set by default)
alias ORION_HOME="cd /home/`whoami`/orion"
ORION_DEVICES="/home/`whoami`/orion/vendor/orion/orion.devices"
#=========================================

#=========================================
#FLAGS - 
# s = sync | f= force sync | r=repair sync
# c = clean 
# d = default (dirty)
# p = clear prebuilt chromium
#=========================================


$ORION_HOME

if [ "$2" == "" ]; then			#No device name
	
	echo "No device name entered. Select from the foll-"
	cat  $ORION_DEVICES
	
elif [ "$2" != "" ]; then		#Device name given. Check flags

	while getopts "s:f:r:c:p:d" opt; do
		case $opt in 
			s)					# sync
				echo "Syncing repo"
				eval "repo sync -c --force-sync --force-broken --no-clone-bundle"
				echo "Repo sync done"
				;;
				
			f)					# force sync 
				echo "Force syncing repo"
				eval "repo sync -c --force-sync --force-broken --no-clone-bundle"
				echo "Repo sync done"
				;;
			
			r)				#Fixed force sync 
				echo "Fixing broken sync and syncing"
				echo "this step will remove your .repo/repo folder and resync repo projects. Continue (y/n)?"
				read ch
				if [ "$ch" == "y" ]; then
					echo "removing .repo/repo"
					rm -rf ".repo/repo"
					eval "repo init -u git://github.com/TeamOrion/platform_manifest.git -b lp5.1"
					eval "repo sync -c --force-sync --force-broken --no-clone-bundle"


	
				elif [ "$ch" == "n" ]; then
					echo "Aborted"
				else
					echo "Wrong option. Aborted"
				fi
				;;
			
			c)				#clean
				make clean
				;;
			
			p)				#clean prebuilt
				echo "clearing prebuilt/chromium"
				rm -rf "$ORION_HOME/prebuilts/chromium/$2"
				;;
				
			d)				#default
				echo "building dirty (default)"
				echo "removing build.prop of older build"
				rm -rf "$ORION_HOME/out/target/product/$2/system/build.prop"
				rm -rf "$ORION_HOME/out/target/product/$2/system/*.zip"
				;;
			
			\?) 
				echo "Usage ./orion.sh -[s][f][r][c][p][d] [device name]"
				;;
				
		esac
	done
	
	eval ". build/envsetup.sh"
	export USE_PREBUILT_CHROMIUM=1
	#Check official support
		if grep -Fxq $2 $ORION_DEVICES
			then
				echo "====$2 is officially supported===="
				export ORION_RELEASE=true
			else
				echo "device is not supported officially; building unofficially"
		fi
		
	# compile
	eval "brunch $2"
			
else 
	echo "Error"
fi
