#!/bin/bash

#Instala Sudo
apt install -y sudo

#Instala unzip
apt-get install unzip

# Atualiza a lista de pacotes e instala as dependências
sudo apt update && sudo apt install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libsdl2-ttf-2.0-0 \
    libopenal1 \
    libpulse0 \
    libasound2 \
    libvulkan1 \
    mesa-utils \
    vulkan-utils

mkdir -p /home/doom
wget -p /home/doom https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip
unzip /home/doom/doom.zip -d /home/doom
sudo dpkg -i /home/doom/gzdoom.deb


echo "Todas as dependências foram instaladas com sucesso!"