cd $HOME
source ~/.profile
if [ -z $NODENAME_GEAR ]; then
        read -p "Enter your node name: " NODENAME_GEAR
        echo 'export NODENAME='$NODENAME_GEAR >> $HOME/.profile
fi
echo 'your node name: ' $NODENAME_GEAR
sleep 1
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/rust.sh | bash 
sudo apt install --fix-broken -y 
sudo apt install git mc clang curl jq htop net-tools libssl-dev llvm libudev-dev -y 
source $HOME/.profile 
source $HOME/.bashrc 
source $HOME/.cargo/env 
sleep 1



wget https://get.gear.rs/gear-nightly-linux-x86_64.tar.xz 
tar xvf gear-nightly-linux-x86_64.tar.xz 
rm gear-nightly-linux-x86_64.tar.xz 
chmod +x $HOME/gear 


sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/gear.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/gear \
      --name $NODENAME_GEAR \
      --execution wasm \
    	--port 31333 \
      --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0' \
	

Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl restart systemd-journald 
sudo systemctl daemon-reload 
sudo systemctl enable gear 
sudo systemctl restart gear 
