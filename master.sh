#! /bin/bash
sudo ufw disable
sudo swapoff -a
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl
sudo apt install python3
sudo apt install python3-pip
sudo curl -sfL https://get.k3s.io | sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/node_token.txt
cd /tmp
timeout 4m python3 -m http.server 8000




