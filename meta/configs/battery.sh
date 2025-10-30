is_laptop() {

  # Linux battery check
  if ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
    return 0
  fi

  # DMI fallback
  if [ -r /sys/class/dmi/id/chassis_type ]; then
    case "$(cat /sys/class/dmi/id/chassis_type)" in
      8|9|10|14|30) return 0 ;;
    esac
  fi

  return 1
}

# Example usage
if is_laptop; then
  echo "Laptop detected"
else
  echo "Desktop detected"
fi
