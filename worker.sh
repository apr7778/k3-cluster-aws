#! /bin/bash
sudo ufw disable
sudo swapoff -a
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl
sleep 150
curl http://${master_node_private_ip}:8000/node_token.txt -o /tmp/node_token.txt
sleep 150
sudo curl -sfL https://get.k3s.io | K3S_URL=https://${master_node_private_ip}:6443 K3S_TOKEN=$(cat /tmp/node_token.txt) sh -
