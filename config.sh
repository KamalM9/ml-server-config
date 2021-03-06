#!/bin/sh

# add opendns DNS (else the ppa's sometimes can't be resolved)
sudo apt update -y
sudo apt install resolvconf -y
echo "nameserver 208.67.222.222" | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo add-apt-repository ppa:deadsnakes/ppa -y

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

sudo apt install unattended-upgrades zsh git-core keychain tmux mosh gcc gparted ubuntu-drivers-common python3.8 python3.8-dev python3.8-distutils python3-pip ncdu x11-apps xclip xsel build-essential devscripts debhelper fakeroot -y
sudo snap install micro --classic

sudo ubuntu-drivers autoinstall

sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
sudo apt install cuda-11-0 libcudnn8 libnccl2 -y

printf "APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Download-Upgradeable-Packages "1";\nAPT::Periodic::AutocleanInterval "7";\nAPT::Periodic::Unattended-Upgrade "7";\n" | sudo tee /etc/apt/apt.conf.d/20auto-upgrades

sudo update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.8 1

export PATH=~/.local/bin:$PATH
sudo python3 -m pip install --upgrade pip
python3 -m pip install joblib boost statsmodels wget pyhive psutil isort plotly natsort pandas matplotlib scikit-learn jupyter notebook jupyter_contrib_nbextensions imtools wandb cachetools tensorboard tensorboardX opencv-python pyarrow fastai mypy flake8 pydocstyle pycodestyle autopep8 autoflake
python3 -m pip install torch===1.7.0+cu110 torchvision===0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s --unattended

LINE='export PATH=~/.local/bin:$PATH'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

LINE='if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then tmux attach-session -t s || tmux new-session -s s; fi'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

LINE='DISABLE_UPDATE_PROMPT="true"'
grep -xqF -- "$LINE" ~/.zshrc || sed  -i "1i $LINE" ~/.zshrc

LINE='tmux resize-window -A'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

sed -i 's/ZSH_THEME=.*/ZSH_THEME="gallois"/' ~/.zshrc

cp .tmux.conf ~/
cp .ssh/* ~/.ssh/

tmux
~/.tmux/plugins/tpm/scripts/install_plugins.sh
~/.tmux/plugins/tpm/bin/install_plugins
