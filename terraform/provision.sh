#!/bin/bash

DEVICE=/dev/xvdb
FS_TYPE=$(file -s $DEVICE | awk '{print $2}')
MOUNT_POINT=/home/ubuntu/.ag-chain-cosmos

# If no FS, then this output contains "data"
if [ "$FS_TYPE" = "no" ]
then
    echo "Creating file system on $DEVICE"
    sudo mkfs -t ext4 $DEVICE
fi

mkdir $MOUNT_POINT
sudo chown -R ubuntu:ubuntu $MOUNT_POINT
sudo mount $DEVICE $MOUNT_POINT

curl https://deb.nodesource.com/setup_12.x | sudo bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update -y
sudo apt-get install nginx git zip curl wget -y
sudo apt install nodejs=12.* yarn build-essential jq -y

sudo rm -rf /usr/local/go
curl https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile

git clone https://github.com/Agoric/agoric-sdk -b  @agoric/sdk@2.15.1
cd agoric-sdk
yarn install
yarn build

cd packages/cosmic-swingset && make
sudo cp -r /home/ubuntu/go/bin/ag-* /usr/local/bin/

curl https://testnet.agoric.net/network-config > $HOME/chain.json
chainName=`jq -r .chainName < $HOME/chain.json`
ag-chain-cosmos init --chain-id $chainName validator
curl https://testnet.agoric.net/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json 
ag-chain-cosmos unsafe-reset-all

peers=$(jq '.peers | join(",")' < $HOME/chain.json)
seeds=$(jq '.seeds | join(",")' < $HOME/chain.json)
sed -i.bak 's/^log_level/# log_level/' $HOME/.ag-chain-cosmos/config/config.toml
sed -i.bak -e "s/^seeds *=.*/seeds = $seeds/; s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml

sudo tee <<EOF >/dev/null /etc/systemd/system/ag-chain-cosmos.service
[Unit]
Description=Agoric Cosmos daemon
After=network-online.target

[Service]
User=ubuntu
ExecStart=/usr/local/bin/ag-chain-cosmos start --log_level=warn
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable ag-chain-cosmos
sudo systemctl daemon-reload
sudo systemctl start ag-chain-cosmos
