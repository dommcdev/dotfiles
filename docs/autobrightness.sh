#!/bin/bash
# Bash script to automatically control the backlight brightness using the illumination sensor
# Written because the Gnome 45.4 auto brightness is not smooth unlike my previous MacOS laptop
# which was driving me insane.
#
# Features:
#  * smooth, flicker-free ramping
#  * sensitivity and delay to prevent constant adjustments
#  * manual adjustment though backlight keys or software(*)
#  * should work on all Framework 13 AMD and Intel laptops (**)
#
#  (*) manual adjustment can be a bit glitchy at times
#  (**) Intel has not yet been tested
#
#  Michiel Toneman 2024, Modified by Donovan
#  Released under the Apache License V2.0

# Define the appropriate devices for Intel and AMD systems
if [ -f /sys/class/backlight/intel_backlight/brightness ]
then
  screen_brightness=/sys/class/backlight/intel_backlight/brightness
  screen_actual_brightness=/sys/class/backlight/intel_backlight/brightness
  screen_max_brightness=/sys/class/backlight/intel_backlight/max_brightness
else
  screen_brightness=/sys/class/backlight/amdgpu_bl1/brightness
  screen_actual_brightness=/sys/class/backlight/amdgpu_bl1/actual_brightness
  screen_max_brightness=/sys/class/backlight/amdgpu_bl1/max_brightness
fi

# Set some constants
max=$(cat $screen_max_brightness)
min=0
sensitivity=$((max/10))
manual_sensitivity=$((max/5))
delay=5 # Check every 5 seconds
manual_delay=20 # wait 20 minutes before auto adjusting
debug=0 # Set to 1 for debug output

# Variables
last_target=$(cat $screen_brightness) # Start the target brightness at the current screen brightness

# Loop
while [ 1 ]
do
    doupdate=0

    # Get the current state of the backlight and illuminance sensor
    target=$(cat /sys/bus/iio/devices/iio:device0/in_illuminance_raw)
    backlight=$(cat $screen_brightness)

    # If the backlight has been manually changed since the last
    # change by the script, then the script will not adjust the brightness
    # again until the time (in minutes) specified manual_delay has elapsed,
    # OR if the difference between the new sensor reading and the sensor reading on the
    # last script change exceeds the manual_sensitivity
    if [ $((backlight - last_target)) -ne 0 ]
    then
        manual_delay_seconds=$((manual_delay*60))
        for (( i=0 ; i<$manual_delay_seconds ; i+=$delay ));
        do
            if [ $debug -eq 1 ]
            then
                echo “manual delay left: $((manual_delay-$((i/60)))) minutes“
            fi
            # update target to match the current sensor reading
            target=$(cat /sys/bus/iio/devices/iio:device0/in_illuminance_raw)

            # check if the lighting has changed enough to warrant auto brightness taking effect again
            if [ $last_target -gt $target ]
            then
                if [ $((last_target - target)) -gt $manual_sensitivity ]
                then
                    if [ $debug -eq 1 ]
                    then
                        echo “stopping manual delay due to low target“
                    fi
                    i=$manual_delay_seconds
                fi
            fi
            if [ $last_target -lt $target ]
            then
                if [ $((target - last_target)) -gt $manual_sensitivity ]
                then
                    if [ $debug -eq 1 ]
                        then
                        echo “stopping manual delay due to high target“
                    fi
                    i=$manual_delay_seconds
                fi
            fi
            sleep $delay
        done
    fi

    backlight=$(cat $screen_brightness)
    # so that we don't keep changing brightness all the time
    if [ $backlight -gt $target ]
    then
        if [ $((backlight - target)) -gt $sensitivity ]
        then
          doupdate=1
        fi
    fi
    if [ $backlight -lt $target ]
    then
        if [ $((target - backlight)) -gt $sensitivity ]
        then
          doupdate=1
        fi
    fi

    # Check that we don't exceed the min and max brightness values
    if [ $target -gt $max ]
    then
      target=$max
    fi
    if [ $target -lt $min ]
    then
      target=$min
    fi

    if [ $doupdate -eq 1 ]
    then
      # Debug logging
      if [ $debug -eq 1 ]
      then
        echo “Starting brightness: $backlight”
        echo “Brightness: $(cat $screen_brightness)“
        echo “Adjusted brightness: $target”
        echo “-------------------------------”
        echo “Sensitivity: $sensitivity”
        echo “Min: $min Max: $max”
        echo
      fi

      # Now change the brightness smoothly in single value in/decrements per 20ms
      intermediate=$backlight

      while [ $intermediate -ne $target ]
      do
        if [ $intermediate -lt $target ]
        then
          ((intermediate++))
        else
          ((intermediate--))
        fi
        echo $intermediate > $screen_brightness
        sleep 0.02
      done

      # Remember what the target brightness was
      # If the next time round the last target brightness differs from the current backlight value
      # then the assumption is that someone has manually adjusted the brightness and we can use that delta
      last_target=$target
    fi
  sleep $delay
done
