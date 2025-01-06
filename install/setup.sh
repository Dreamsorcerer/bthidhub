cd $HOME

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git --no-install-recommends -y

git clone https://github.com/Dreamsorcerer/bthidhub --depth 1
cd $HOME/bthidhub/install/on_rpi
bash ./on_pi_setup.sh
