#!/bin/bash

# Settings
dirpic='/home/jeanbaptiste/Pictures/dynamic_wallpaper'
newimg='mapLargeNew.png'
rotimg1='mapLargeWLPPR_1.png'
rotimg2='mapLargeWLPPR_2.png'

# In fedora I have to update the environment variables to make sure cron updates the right:
PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
GSETTINGS_BACKEND=dconf

# Retrieve the image from NASA's website:
wget https://eyes.nasa.gov/refresh/dsn/mapLarge.png --output-document="$dirpic/$newimg"
OUT=$?

if [ $OUT -eq 0 ];then
	# For some reason gsettings doesn't update the background if the file uri doesn't effectively change, so I use the following trick to alternate between two pictures:
	if [ -f "$dirpic/$rotimg1" ]; then
		echo "Moving $newimg to $rotimg2..."
		mv "$dirpic/$newimg" "$dirpic/$rotimg2"
		echo "Setting new background picture to: $rotimg2..."
		# Here I use gsettings to change the desktop background in fedora w/ gnome shell, but for other distros/desktop this must be changed.
		gsettings set org.gnome.desktop.background picture-uri "file://$dirpic/$rotimg2"
		echo "Deleting old background picture $rotimg1..."
		rm "$dirpic/$rotimg1"
	else
		echo "Moving $newimg to $rotimg1..."
		mv "$dirpic/$newimg" "$dirpic/$rotimg1"
		echo "Setting new background picture to: $rotimg1..."
		# Here I use gsettings to change the desktop background in fedora w/ gnome shell, but for other distros/desktop this must be changed.
		gsettings set org.gnome.desktop.background picture-uri "file://$dirpic/$rotimg1"
		echo "Deleting old background picture $rotimg2..."
		rm "$dirpic/$rotimg2"
	fi

else
   echo "Wallpaper retrieval failed..."
fi

