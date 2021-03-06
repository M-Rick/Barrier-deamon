#!/bin/bash

while true; do
    read -p "Do you want to launch Barrier at startup? (Y,N) " yn
    case $yn in
        [Yy]* ) yn=Y; break;;
        [Nn]* ) yn=N; break;;
        * ) echo "Please answer yes (Y) or no (N) : ";;
    esac
done

## Answer is Yes - Barrier Configuration
if [ $yn = Y ]; then
    echo "Yes"

while true; do
    read -p "Do you want to launch Barrier as Server or Client? (S = Server | C = Client) : " sc
    case $sc in
        [Ss]* ) sc=S; break;;
        [Cc]* ) sc=C; break;;
        * ) echo"";echo "Please answer Server (S) or Client (C). CTRL C to Cancel ";;
    esac
done
## Setting-up Barrier
## Setting-up server
if [ $sc = S ]; then
    echo -n "Input the Barrier server name: "
    read -r bsname
    sudo echo \
"[Unit]
Description=Barrier Server mouse/keyboard share
Requires=display-manager.service
After=display-manager.service
StartLimitIntervalSec=0

[Service]
Type=forking
ExecStart=nice --5 /usr/bin/barriers --no-tray --no-restart --name $bsname --enable-crypto -c /tmp/Barrier.hlsSpA --address:24800
Restart=always
RestartSec=10
User=$USER
CPUSchedulingPriority=70

[Install]
WantedBy=multi-user.target" \
    > /etc/systemd/system/barriers.service
    echo ""
    echo "Barrier: Launching server"
    sudo systemctl daemon-reload
    sudo systemctl start barrierc.service
    sudo systemctl enable barrierc.service
    echo "Done"
## Setting-up client
elif [ $sc = C ]; then
    echo -n "Input the Barrier server computer name or the IP address (E.g Linux-Computer1.local or 192.168.1.1) : "
    read -r bsname
    echo -n "Input the Barrier client computer name : "
    read -r bcname
    sudo echo \
"[Unit]
Description=Barrier Client mouse/keyboard share
Requires=display-manager.service
After=display-manager.service
StartLimitIntervalSec=0

[Service]
Type=forking
ExecStart=nice --5 /usr/bin/barrierc --no-tray --no-restart --name $bcname --enable-crypto $bsname:24800
Restart=always
RestartSec=10
User=$USER
CPUSchedulingPriority=70

[Install]
WantedBy=multi-user.target" \
    > /etc/systemd/system/barrierc.service
    echo ""
    echo "Barrier: Launching client"
    sudo systemctl daemon-reload
    sudo systemctl start barrierc.service
    sudo systemctl enable barrierc.service
    echo "Done"
else
    echo "Please answer server (S) or client (C). CTRL C to Cancel : "
fi

## Answer is No - End
elif [ $yn = N ]; then
    echo ""
    echo "Installation of Barrier Deamon aborted"
    echo ""

else
    echo "Please answer yes (Y) or no (N). CTRL C to Cancel : "
fi
