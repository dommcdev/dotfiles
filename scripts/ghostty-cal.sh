#!/usr/bin/env bash

DIM='\033[38;2;108;112;134m'     # Weekday names
NC='\033[0m'

clear

cal -y

echo -e "${DIM}Press any key to close...${NC}"
read -n 1 -s
