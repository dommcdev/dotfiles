#!/bin/bash
# Rescaled Smooth Auto-Brightness Script for ThinkPad X9-15

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

# Set constants based on system values
max=$(cat $screen_max_brightness) # This is 496
min=10                             # Don't drop to pitch black 0
sensitivity=$((max/12))            # Step change sensitivity threshold
manual_sensitivity=$((max/5))
delay=4
manual_delay=15
debug=0

# Define the highest lux value you expect in normal indoor/outdoor use
# Anything over this max_sensor_lux cap will clip cleanly to max screen brightness (496)
max_sensor_lux=25000

get_ambient_lux() {
  # Grab raw lux reading from device2
  local raw_lux=$(cat /sys/bus/iio/devices/iio:device2/in_illuminance_raw 2>/dev/null)
  [ -z "$raw_lux" ] && return

  # Map raw lux scale (0-25000) proportionally onto the screen scale (0-496)
  if [ $raw_lux -gt $max_sensor_lux ]; then
    raw_lux=$max_sensor_lux
  fi

  # Linear scaling equation: (raw * max_backlight) / max_sensor_lux
  echo $(( (raw_lux * max) / max_sensor_lux ))
}

last_target=$(cat $screen_brightness)

while [ 1 ]
do
    doupdate=0

    target=$(get_ambient_lux)
    [ -z "$target" ] && target=$last_target

    backlight=$(cat $screen_brightness)

    # Manual override tracking
    if [ $((backlight - last_target)) -ne 0 ]
    then
        manual_delay_seconds=$((manual_delay*60))
        for (( i=0 ; i<$manual_delay_seconds ; i+=$delay ));
        do
            if [ $debug -eq 1 ]; then echo "manual delay left: $((manual_delay-$((i/60)))) minutes"; fi

            target=$(get_ambient_lux)
            [ -z "$target" ] && target=$last_target

            if [ $last_target -gt $target ]
            then
                if [ $((last_target - target)) -gt $manual_sensitivity ]
                then
                    i=$manual_delay_seconds
                fi
            fi
            if [ $last_target -lt $target ]
            then
                if [ $((target - last_target)) -gt $manual_sensitivity ]
                then
                    i=$manual_delay_seconds
                fi
            fi
            sleep $delay
        done
    fi

    backlight=$(cat $screen_brightness)
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

    if [ $target -gt $max ]; then target=$max; fi
    if [ $target -lt $min ]; then target=$min; fi

    if [ $doupdate -eq 1 ]
    then
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

      last_target=$target
    fi
  sleep $delay
done
