# Gets options from zip name
BOOT=false; FONT=false; RING=false; APP=false
OIFS=$IFS; IFS=\|
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *boot*|*Boot*|*BOOT*) BOOT=true;;
  *font*|*Font*|*FONT*) FONT=true;;
  *ring*|*Ring*|*RING*) RING=true;;
  *app*|*App*|*APP*) APP=true;;
esac
IFS=$OIFS

if [ "$OOS" ]; then
  ui_print " "
  ui_print "   Oxy-ify is only for non-OOS devices!"
  ui_print "   Why would you need this stuff if you are already in Oxygen OS?"
  ui_print "   DO YOU WANT TO IGNORE OUR WARNINGS AND RISK A BOOTLOOP?"
  ui_print "   Vol Up = Yes, Vol Down = No"
  if $VKSEL; then
    ui_print " "
    ui_print "   Ignoring warnings..."
  else
    ui_print " "
    ui_print "   Exiting..."
    abort
  fi
fi

if [ "$BOOT" == false -a "$FONT" == false -a "$RING" == false -a "$APP" == false ]; then
  ui_print " "
  ui_print " - Boot Animation Option -"
  ui_print "   Do you want to enable Oxygen OS boot animation?"
  ui_print "   (boot animation may not work for some devices)"
  ui_print "   Vol Up = Yes, Vol Down = No"
  if $VKSEL; then
    BOOT=true
    ui_print " "
    ui_print " - Font Option -"
    ui_print "   Do you want OnePlus Slate font?"
    ui_print "   Vol Up = Yes, Vol Down = No"
    if $VKSEL; then
      FONT=true
      ui_print " "
      ui_print " - Ringtone Option -"
      ui_print "   Do you want Oxygen OS custom media sounds?"
      ui_print "   They include ringtones, alarms, notifications and UI sounds"
      ui_print "   Vol Up = Yes, Vol Down = No"
      if $VKSEL; then
        RING=true
        if [ $API -ge 24 ]; then
          ui_print " "
          ui_print " - App Option -"
          ui_print "   Do you want OnePlus apps (Camera, Gallery and Weather)?"
          ui_print "   Vol Up = Yes, Vol Down = No"
          if $VKSEL; then
            APP=true
          fi
        fi
      fi
    fi  
  fi          
else
  ui_print " Options specified in zip name!"
fi

if $BOOT; then
  ui_print " "
  ui_print "   Enabling boot animation..."
  mkdir -p $MAGISK_SIMPLE/$BFOLDER
  cp -f $INSTALLER/custom/bootanimation.zip $MAGISK_SIMPLE/$BFOLDER/$BZIP
else
  ui_print " "
  ui_print "   Disabling boot animation..."
fi

if $FONT; then
  ui_print " "
  ui_print "   Enabling font..."
else
  ui_print " "
  ui_print "   Disabling font..."
  rm -rf $INSTALLER/system/fonts
fi

if $RING; then
  ui_print " "
  ui_print "   Enabling custom media sounds..."
else
  ui_print " "
  ui_print "   Disabling custom media sounds..."
  rm -rf $INSTALLER/system/media/audio
fi

if [ $API -ge 24 ] && [ $APP ]; then
    ui_print " "
    ui_print "   Enabling OnePlus apps..."
    cp -rf $INSTALLER/custom/system $UNITY/system
fi