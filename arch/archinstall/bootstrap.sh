#!/bin/env bash

# Run archinstall with included configuration/credential file. Disk input is still manual
archinstall --config /root/user_configuration.json --creds /root/user_credentials.json

# If archinstall completes successfully (exit code 0), proceed
if [ $? -eq 0 ]; then
  echo -e "\n\n--- Archinstall completed successfully. Chrooting into new system to continue installation. --- \n\n"
else
  echo "Archinstall failed. Please check the logs."
  exit 1
fi
