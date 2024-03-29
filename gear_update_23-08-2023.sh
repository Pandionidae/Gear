source $HOME/.profile
sudo systemctl stop gear
/root/gear purge-chain -y

wget https://get.gear.rs/gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz
sudo tar -xvf gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz -C /root
rm gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz

sudo systemctl start gear

sleep 15

NODE_GEAR=$(grep -Po '(?<=--name\s)\S+(?=\s*--execution)' /etc/systemd/system/gear.service)

sudo tee <<EOF >/dev/null /etc/systemd/system/gear.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/gear \
        --name $NODE_GEAR \
        --execution wasm \
	--port 31333 \
        --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0' \

Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl restart gear
