#!/bin/bash
set -e

USERS=$(cat /tmp/users | tr -d '\n')

for user in "${USERS[@]}"
do
sudo useradd -s /bin/bash -d /home/$user -m $user
sudo adduser $user sudo

echo "$user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$user > /dev/null
sudo chmod 0440 /etc/sudoers.d/$user

sudo mkdir /home/$user/.ssh
sudo wget -O /home/$user/.ssh/authorized_keys https://github.com/$user.keys
sudo chown -R $user:$user /home/$user/.ssh
sudo chmod 0700 /home/$user/.ssh
sudo chmod 0600 /home/$user/.ssh/authorized_keys
done