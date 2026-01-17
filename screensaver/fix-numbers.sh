#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/phrases"
FONT="Delta Corps Priest 1"

# Numbers extracted from numbers.txt (8 lines each, padded to match figlet's 9 lines)
# Format: each number is stored as a single string with \n separators

NUM_0='   ▄████████  
  ███    ███ 
  ███    ███ 
  ███    ███ 
  ███    ███ 
  ███    ███ 
  ███    ███ 
   ▀████████ 
             '

NUM_1='       ▄█    
     ▄███    
    ▐████    
     ▀███    
      ███    
      ███    
      ███    
   ▄███████  
             '

NUM_2='   ▄████████ 
  ███    ███ 
  ▀▀     ███ 
   ▄████████ 
  ███        
  ███     ▄▄ 
  ██████████ 
   ▀▀▀▀▀▀▀▀▀ 
             '

NUM_3='   ▄████████ 
  ███    ███ 
        ███  
   ▄████████ 
        ███  
  ███    ███ 
   ▀████████ 
             
             '

NUM_4='       ▄██▄  
     ▄█████  
    ███ ███  
   ███  ███  
  ██████████ 
        ███  
        ███  
      ▄█████ 
             '

NUM_5='  ██████████ 
  ███        
  ████████▄  
       ███   
  ▄█    ███  
  █████████  
   ▀▀▀▀▀▀▀▀▀ 
             
             '

NUM_6='      ▄██████
     ███     
     ████████
     ███    ███
     ███    ███
      ▀████████
             
             
             '

NUM_7='  ██████████ 
  ▀▀▀    ███ 
        ███  
       ███   
      ███    
     ███     
    ▄███     
             
             '

NUM_8='   ▄██████▄  
  ███    ███ 
  ███    ███ 
   ▀██████▀  
  ▄██████▄   
  ███    ███ 
  ███    ███ 
   ▀██████▀  
             '

NUM_9='   ▄██████▄  
  ███    ███ 
  ███    ███ 
   ▀████████ 
        ███  
        ███  
   ▄██████▀  
             
             '

# Function to get a number's ASCII art as an array
get_number() {
    local num=$1
    case $num in
        0) echo "$NUM_0" ;;
        1) echo "$NUM_1" ;;
        2) echo "$NUM_2" ;;
        3) echo "$NUM_3" ;;
        4) echo "$NUM_4" ;;
        5) echo "$NUM_5" ;;
        6) echo "$NUM_6" ;;
        7) echo "$NUM_7" ;;
        8) echo "$NUM_8" ;;
        9) echo "$NUM_9" ;;
    esac
}

# Generate HAL 9000
echo "Generating HAL 9000..."
{
    paste -d'' \
        <(figlet -f "$FONT" "HAL " | head -9) \
        <(get_number 9) \
        <(get_number 0) \
        <(get_number 0) \
        <(get_number 0)
} > "${OUTPUT_DIR}/hal_9000.txt"

# Generate R2 D2
echo "Generating R2 D2..."
{
    paste -d'' \
        <(figlet -f "$FONT" "R" | head -9) \
        <(get_number 2) \
        <(figlet -f "$FONT" " D" | head -9) \
        <(get_number 2)
} > "${OUTPUT_DIR}/r2_d2.txt"

# Generate 512K RAM
echo "Generating 512K RAM..."
{
    paste -d'' \
        <(get_number 5) \
        <(get_number 1) \
        <(get_number 2) \
        <(figlet -f "$FONT" "K RAM" | head -9)
} > "${OUTPUT_DIR}/512k_ram.txt"

# Generate Error 404 Name Not Found
echo "Generating Error 404 Name Not Found..."
{
    paste -d'' \
        <(figlet -f "$FONT" "ERROR " | head -9) \
        <(get_number 4) \
        <(get_number 0) \
        <(get_number 4)
} > "${OUTPUT_DIR}/error_404_name_not_found.txt"
# Append the second line
figlet -f "$FONT" "NAME NOT FOUND" >> "${OUTPUT_DIR}/error_404_name_not_found.txt"

echo "Done!"
