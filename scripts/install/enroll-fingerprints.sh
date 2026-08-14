#!/usr/bin/env bash

set -e

RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error() {
  echo -e "${RED}$1${NC}"
}

print_info() {
  echo -e "${BLUE}$1${NC}"
}

check_fprintd() {
  if ! command -v fprintd-enroll &>/dev/null || ! command -v fprintd-list &>/dev/null; then
    print_error "fprintd is not installed. Install it before enrolling fingerprints."
    exit 1
  fi
}

check_fingerprint_hardware() {
  # Get fingerprint devices for the user
  # Suppress stderr to avoid confusion if service isn't ready immediately
  local devices
  devices=$(fprintd-list "$USER" 2>/dev/null || true)

  # Exit if no devices found
  if [[ -z "$devices" ]] || [[ "$devices" == *"No devices available"* ]]; then
    print_error "\nNo fingerprint sensor detected."
    return 1
  fi
  return 0
}

get_enrolled_fingers() {
  local output
  output=$(fprintd-list "$USER" 2>/dev/null || true)
  local enrolled_list=""

  if echo "$output" | grep -q "right-index-finger"; then enrolled_list+="Right Index, "; fi
  if echo "$output" | grep -q "right-middle-finger"; then enrolled_list+="Right Middle, "; fi
  if echo "$output" | grep -q "right-thumb"; then enrolled_list+="Right Thumb, "; fi
  if echo "$output" | grep -q "right-ring-finger"; then enrolled_list+="Right Ring, "; fi
  if echo "$output" | grep -q "right-little-finger"; then enrolled_list+="Right Little, "; fi
  if echo "$output" | grep -q "left-index-finger"; then enrolled_list+="Left Index, "; fi
  if echo "$output" | grep -q "left-middle-finger"; then enrolled_list+="Left Middle, "; fi
  if echo "$output" | grep -q "left-thumb"; then enrolled_list+="Left Thumb, "; fi
  if echo "$output" | grep -q "left-ring-finger"; then enrolled_list+="Left Ring, "; fi
  if echo "$output" | grep -q "left-little-finger"; then enrolled_list+="Left Little, "; fi

  enrolled_list=${enrolled_list%, }

  if [[ -z "$enrolled_list" ]]; then
      echo "None"
  else
      echo "$enrolled_list"
  fi
}

enroll_fingerprints() {
  print_info "\nStarting Fingerprint Enrollment"

  if ! command -v gum &>/dev/null; then
     print_error "Error: 'gum' is not installed. Please install gum to use the interactive enrollment."
     exit 1
  fi

  while true; do
    echo "" # Spacing

    local enrolled
    enrolled=$(get_enrolled_fingers)
    echo -e "${YELLOW}Enrolled: ${enrolled}${NC}"

    local choice
    if ! choice=$(gum choose --cursor.foreground="4" --header.foreground="4" --header "Select finger to enroll (Esc to finish)" \
      "Right Index" "Right Middle" "Right Thumb" "Right Ring" "Right Little" \
      "Left Index" "Left Middle" "Left Thumb" "Left Ring" "Left Little"); then
      break
    fi

    local finger_id=""
    case "$choice" in
      "Right Index")  finger_id="right-index-finger" ;;
      "Right Middle") finger_id="right-middle-finger" ;;
      "Right Thumb")  finger_id="right-thumb" ;;
      "Right Ring")   finger_id="right-ring-finger" ;;
      "Right Little") finger_id="right-little-finger" ;;
      "Left Index")   finger_id="left-index-finger" ;;
      "Left Middle")  finger_id="left-middle-finger" ;;
      "Left Thumb")   finger_id="left-thumb" ;;
      "Left Ring")    finger_id="left-ring-finger" ;;
      "Left Little")  finger_id="left-little-finger" ;;
    esac

    print_info "Enrolling $choice..."
    print_info "Please scan your finger repeatedly on the sensor until completion."

    # -f forces enrollment even if finger is already enrolled
    if sudo fprintd-enroll -f "$finger_id" "$USER"; then
      gum style --foreground "2" "Successfully enrolled $choice!"
      sleep 2
    else
      gum style --foreground "1" "Failed to enroll $choice!"
      if ! gum confirm --selected.background="4" --selected.foreground="0" "Try again?"; then
         continue
      fi
    fi
  done
}

main() {
  check_fprintd

  if ! check_fingerprint_hardware; then
    print_error "Hardware check failed."
    exit 1
  fi

  enroll_fingerprints
}

main "$@"
