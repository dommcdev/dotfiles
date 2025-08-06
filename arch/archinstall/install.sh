#!/bin/env bash
set -e

echo "This script will install Arch Linux on the specified drive (via archinstall), as well as clone a dotfiles repo to ~/dev/dotfiles."

# Read in git username and password securely
read -p "Please enter your git username: " GIT_USER
read -s -p "Please enter your git password: " GIT_PASS

# Run archinstall with included configuration/credential file. Disk input is still manual.
archinstall --config /root/user_configuration.json --creds /root/user_credentials.json
echo -e "\n\n--- Archinstall completed successfully. Cloning dotfiles via arch-chroot ... ---\n\n"

# Clone dotfiles repo and install dotfiles
cat << 'EOF' > /mnt/home/dominic/bootstrap-dotfiles.sh
#!/bin/env bash
mkdir -p ~/dev/
git clone http://$GIT_USER:$GIT_PASS@developermcd.com:8080/dominic/dotfiles.git ~/dev/dotfiles
cd dotfiles && ./install_profile arch-main
EOF
arch-chroot /mnt sudo -u dominic bash /home/dominic/bootstrap_dotfiles.sh
arch-chroot /mnt rm /home/dominic/bootstrap_dotfiles.sh


#arch-chroot /mnt su -l dominic -c 'mkdir -p ~/dev/'
#arch-chroot /mnt su -l dominic -c 'git clone http://$GIT_USER:$GIT_PASS@developermcd.com:8080/dominic/dotfiles.git ~/dev/dotfiles'
