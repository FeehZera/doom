#!/bin/bash 
#https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip


# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root ou com sudo."
    exit 1
fi

# Instala o sudo, caso ainda não esteja instalado
apt update && apt install -y sudo

# Instala unzip
sudo apt-get install -y unzip

# Atualiza a lista de pacotes e instala as dependências necessárias para rodar o Doom
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

# Cria o diretório onde o Doom será instalado
mkdir -p /home/doom

# Faz o download do arquivo doom.zip (substitua pela URL correta do arquivo .zip)
wget -P /home/doom https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip

# Descompacta o arquivo doom.zip no diretório /home/doom
unzip /home/doom/doom.zip -d /home/doom

# Instala o gzdoom.deb (substitua pela URL correta do arquivo .deb, ou garanta que ele já está em /home/doom)
sudo dpkg -i /home/doom/gzdoom.deb

# Verifica se a instalação do gzdoom foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "gzdoom foi instalado com sucesso!"
else
    echo "Houve um problema na instalação do gzdoom."
    exit 1
fi

# Procura o caminho do executável gzdoom
gzdoom_path=$(which gzdoom)

# Verifica se o gzdoom foi encontrado
if [ -z "$gzdoom_path" ]; then
    echo "O executável gzdoom não foi encontrado no sistema."
    exit 1
fi

# Cria um atalho chamado 'doom' no PATH para rodar o Doom
echo "Criando atalho 'doom' para executar o jogo..."
sudo ln -sf "$gzdoom_path" /usr/local/bin/doom

# Verifica se o link foi criado com sucesso
if [ $? -eq 0 ]; then
    echo "Atalho 'doom' criado com sucesso! Agora você pode executar o Doom digitando 'doom' no terminal."
else
    echo "Houve um problema ao criar o atalho."
    exit 1
fi

echo "Todas as dependências foram instaladas com sucesso!"
