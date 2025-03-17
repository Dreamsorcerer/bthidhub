cd $HOME/bthidhub/install/on_rpi

sudo echo 0 | sudo tee /sys/class/leds/ACT/brightness > /dev/null

sudo apt-get update
sudo apt-get install git libcairo2-dev libdbus-1-dev libgirepository1.0-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev autoconf automake libtool python3-pip -y
sudo pip3 install -r $HOME/bthidhub/requirements.txt --break-system-packages

cd $HOME/bthidhub/install/on_rpi
git clone https://github.com/Dreamsorcerer/bluez.git --depth 1
cd $HOME/bthidhub/install/on_rpi/bluez
autoreconf -fvi

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-a2dp --disable-avrcp --disable-network --disable-manpages
automake
make -j4

sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
sudo make install
sudo python3 $HOME/bthidhub/install/on_rpi/config_replacer.py
sudo cp $HOME/bthidhub/sdp_record_template.xml /etc/bluetooth/sdp_record.xml
sudo sed -i 's/{}//' /etc/bluetooth/sdp_record.xml
sudo cp $HOME/bthidhub/install/on_rpi/input.conf /etc/bluetooth/input.conf
sudo cp $HOME/bthidhub/install/on_rpi/main.conf /etc/bluetooth/main.conf
sudo sed -i 's/^ProtectSystem/#ProtectSystem/' /lib/systemd/system/bluetooth.service
sudo sed -i 's/^PrivateTmp/#PrivateTmp/' /lib/systemd/system/bluetooth.service

sudo cp $HOME/bthidhub/install/on_rpi/remapper.service /lib/systemd/system/remapper.service
sudo sed -i "s|{}|${HOME}|" /lib/systemd/system/remapper.service
sudo chmod 644 /lib/systemd/system/remapper.service
sudo systemctl daemon-reload

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable remapper.service
sudo systemctl start remapper.service

sudo sed -Ei 's/^127\.0\.1\.1.*$/127.0.1.1\tbthidhub/' /etc/hosts
sudo hostnamectl set-hostname bthidhub

# Compile some Python modules to reduce lag.
# We do this at the end, as the project is already usable without this step.
cd $HOME/bthidhub/
mypyc

sudo reboot
