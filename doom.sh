#!/bin/bash 
#https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip


# Função para verificar se o último comando executado foi bem-sucedido
check_success() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1"
        exit 1
    fi
}

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root ou com sudo."
    exit 1
fi

# Atualiza a lista de pacotes
apt update
check_success "Falha ao atualizar a lista de pacotes."

# Instala o sudo, caso ainda não esteja instalado
apt install -y sudo
check_success "Falha ao instalar sudo."

# Instala unzip
sudo apt-get install -y unzip
check_success "Falha ao instalar unzip."

# Instala as dependências necessárias para rodar o Doom
sudo apt-get install -y \
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
check_success "Falha ao instalar as dependências."

# Cria o diretório onde o Doom será instalado
mkdir -p /home/doom
check_success "Falha ao criar o diretório /home/doom."

# Faz o download do arquivo doom.zip (substitua pela URL correta do arquivo .zip)
wget -P /home/doom https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip
check_success "Falha ao fazer o download do arquivo doom.zip."

# Descompacta o arquivo doom.zip no diretório /home/doom
unzip /home/doom/doom.zip -d /home/doom
check_success "Falha ao descompactar o arquivo doom.zip."

# Instala o gzdoom.deb (substitua pela URL correta do arquivo .deb, ou garanta que ele já está em /home/doom)
sudo dpkg -i /home/doom/gzdoom.deb
check_success "Falha ao instalar o gzdoom."

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
check_success "Falha ao criar o atalho doom."

# Verifica se o link foi criado com sucesso
if [ -L /usr/local/bin/doom ]; then
    echo "Atalho 'doom' criado com sucesso! Agora você pode executar o Doom digitando 'doom' no terminal."
else
    echo "Houve um problema ao criar o atalho."
    exit 1
fi

echo "Todas as dependências foram instaladas e o atalho foi criado com sucesso!"
