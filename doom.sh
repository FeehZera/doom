#!/bin/bash 
#https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip


# Função para verificar se o último comando executado foi bem-sucedido
check_success() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1. Continuando a execução do script."
    fi
}

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root."
    exit 1
fi

# Verifica se o sudo já está instalado
if ! command -v sudo &> /dev/null; then
    echo "Sudo não está instalado, tentando instalar sudo..."
    apt update
    if apt install -y sudo; then
        echo "Sudo instalado com sucesso."
    else
        echo "Falha ao instalar sudo. Continuando a execução do script."
    fi
else
    echo "Sudo já está instalado."
fi

# Verifica se o unzip já está instalado
if ! command -v unzip &> /dev/null; then
    echo "Unzip não está instalado, instalando unzip..."
    if sudo apt-get install -y unzip; then
        echo "Unzip instalado com sucesso."
    else
        echo "Falha ao instalar unzip. Continuando a execução do script."
    fi
else
    echo "Unzip já está instalado."
fi

# Verifica se as dependências necessárias já estão instaladas
dependencies=("libgl1-mesa-glx" "libgl1-mesa-dri" "libsdl2-2.0-0" "libsdl2-image-2.0-0" "libsdl2-mixer-2.0-0" "libsdl2-ttf-2.0-0" "libopenal1" "libpulse0" "libasound2" "libvulkan1" "mesa-utils" "vulkan-utils")

for dep in "${dependencies[@]}"; do
    if dpkg -l | grep -q "$dep"; then
        echo "$dep já está instalado."
    else
        echo "$dep não está instalado, instalando..."
        if sudo apt-get install -y "$dep"; then
            echo "$dep instalado com sucesso."
        else
            echo "Falha ao instalar $dep. Continuando a execução do script."
        fi
    fi
done

# Cria o diretório onde o Doom será instalado
if [ ! -d "/home/doom" ]; then
    echo "Criando o diretório /home/doom..."
    if mkdir -p /home/doom; then
        echo "Diretório /home/doom criado com sucesso."
    else
        echo "Falha ao criar o diretório /home/doom. Continuando a execução do script."
    fi
else
    echo "O diretório /home/doom já existe."
fi

# Faz o download do arquivo doom.zip (substitua pela URL correta do arquivo .zip)
if [ ! -f "/home/doom/doom.zip" ]; then
    echo "Fazendo o download do arquivo doom.zip..."
    if wget -P /home/doom https://github.com/FeehZera/doom/raw/refs/heads/main/doom.zip; then
        echo "Arquivo doom.zip baixado com sucesso."
    else
        echo "Falha ao baixar o arquivo doom.zip. Continuando a execução do script."
    fi
else
    echo "O arquivo doom.zip já existe."
fi

# Descompacta o arquivo doom.zip no diretório /home/doom
if [ ! -d "/home/doom/doom" ]; then
    echo "Descompactando o arquivo doom.zip..."
    if unzip /home/doom/doom.zip -d /home/doom; then
        echo "Arquivo doom.zip descompactado com sucesso."
    else
        echo "Falha ao descompactar o arquivo doom.zip. Continuando a execução do script."
    fi
else
    echo "O arquivo já foi descompactado."
fi

# Instala o gzdoom.deb (substitua pela URL correta do arquivo .deb, ou garanta que ele já está em /home/doom)
if ! dpkg -l | grep -q "gzdoom"; then
    echo "gzdoom não está instalado, instalando gzdoom..."
    if sudo dpkg -i /home/doom/gzdoom.deb; then
        echo "gzdoom instalado com sucesso."
    else
        echo "Falha ao instalar gzdoom. Continuando a execução do script."
    fi
else
    echo "gzdoom já está instalado."
fi

# Procura o caminho do executável gzdoom
gzdoom_path=$(which gzdoom)

# Verifica se o gzdoom foi encontrado
if [ -z "$gzdoom_path" ]; then
    echo "O executável gzdoom não foi encontrado no sistema. Continuando a execução do script."
else
    echo "Executável gzdoom encontrado em: $gzdoom_path."
fi

# Cria um atalho chamado 'doom' no PATH para rodar o Doom
if [ ! -L /usr/local/bin/doom ]; then
    echo "Criando atalho 'doom' para executar o jogo..."
    if sudo ln -sf "$gzdoom_path" /usr/local/bin/doom; then
        echo "Atalho 'doom' criado com sucesso."
    else
        echo "Falha ao criar o atalho doom. Continuando a execução do script."
    fi
else
    echo "Atalho 'doom' já existe."
fi

# Verifica se o link foi criado com sucesso
if [ -L /usr/local/bin/doom ]; then
    echo "Atalho 'doom' criado com sucesso! Agora você pode executar o Doom digitando 'doom' no terminal."
else
    echo "Houve um problema ao criar o atalho."
    exit 1
fi

echo "Script executado com sucesso, mesmo que alguns erros tenham ocorrido."
