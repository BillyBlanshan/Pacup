#!/bin/bash

# Updater for ArcoLinux system

# Variables
RSS_FEED_URL='https://archlinux.org/feeds/news/'
LAST_UPDATE_FILE="/home/billy/scripts/pacup_last_update.txt"
last_update=$(cat $LAST_UPDATE_FILE)
current_date=$(date +"%Y-%m-%d")

# Splash screen
figlet PACUP

# Check Arch RSS feed for updates
echo "*******************************************
***   Check Arch RSS feed for updates   ***
*******************************************"

latest_publish_date=$(curl -s $RSS_FEED_URL | grep -m 1 "<lastBuildDate>" | sed -n 's/.*<lastBuildDate>\(.*\)<\/lastBuildDate>.*/\1/p')
formatted_date=$(date -d "$latest_publish_date" +"%Y-%m-%d")

if [[ "$formatted_date" > "$last_update" ]]; then
	echo "There is a new article available."
	echo "It is recommended that you abort Pacup and read the article."
	echo "$RSS_FEED_URL"
	echo "Last update: $last_update"
	echo "Latest publish date: $formatted_date"

else
	echo "No new articles available."
	echo "Last update: $last_update"
	echo "Latest publish date: $formatted_date"
fi

while true; do

read -p "Would you like to proceed with Pacup? [y/n] " yn

case $yn in
	[yY] ) echo Proceeding...;
		break;;
	[nN] ) echo Aborting...;
		exit;;
	* ) echo Invalid response;;
esac

done


# Update Pacman
echo "************************************
***   Updating Pacman packages   ***
************************************"

sudo pacman -Syyu

echo "***********************************************
***   Pacman packages updated succesfully   ***
***********************************************"


# Update AUR packages
echo "*********************************
***   Updating AUR packages   ***
*********************************"

yay -Syu

echo "********************************************
***   AUR packages updated succesfully   ***
********************************************"

# Final splashscreen

echo "*************************************
***   Your system is up to date   ***
***   Pacup script is finished    ***
*************************************"

echo $current_date > $LAST_UPDATE_FILE
