#!/bin/bash

echo "===================================="
echo "Download windows files"
echo "===================================="
curl -L -o w10x64.img https://bit.ly/akuhnetW10x64

echo "===================================="
echo "Download ngrok"
echo "===================================="
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O ngrok.zip
unzip ngrok.zip
read -p "Enter your ngrok token: " NGROK_TOKEN
./ngrok authtoken $NGROK_TOKEN
nohup ./ngrok tcp 3388 &>/dev/null &

echo "===================================="
echo "Downloading File From akuh.net"
echo "===================================="
apt-get update
apt-get install -y qemu-kvm

echo "===================================="
echo "Starting Windows"
echo "===================================="
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'

echo "===================================="
echo "Username: akuh"
echo "Password: Akuh.Net"
echo "===================================="

qemu-system-x86_64 -hda w10x64.img -m 8G -smp cores=4 -net user,hostfwd=tcp::3388-:3389 -net nic -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 -vga vmware -nographic &

# Keep it running for 24 hours
sleep 86400
