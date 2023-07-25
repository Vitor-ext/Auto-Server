#!/bin/bash 
#
# Instala Servidor - Automatização de Processos
#
# Vitor de Jesus
# CVS $Header$

shopt -s -o nounset 


# Variáveis de configuração do servidor
server_root="/var/www/html"  # Diretório raiz do servidor web
server_port="80"            # Porta na qual o servidor web será executado
index_page="index.html"     # Página de índice padrão


# Titulo 
printf "%s\n" "Iniciando o Servidor Web"
printf "\n"

# Verifica se o usuário é root (necessário para iniciar o servidor na porta 80)
if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser executado como root ou com privilégios de superusuário."
    exit 1
fi


# Verifica se o servidor Apache está instalado
if ! command -v apache2 >/dev/null 2>&1; then
    echo "O servidor Apache não está instalado. Vamos instalar antes de continuar."

    # Atualizar o apt-get 
    apt-get update && apt-get upgrade -y
    sleep 3

    apt-get install Apache2 -y
    sleep 3

    exit 1
fi

# Criação do diretório raiz do servidor, se não existir
if [ ! -d "$server_root" ]; then
    echo "Criando o diretório raiz do servidor..."
    mkdir -p "$server_root"
fi

# Criação da página de índice padrão, se não existir
if [ ! -f "$server_root/$index_page" ]; then
    echo "Criando a página de índice padrão..."
    echo "<html><body><h1>Bem-vindo ao meu servidor web! Prof° Vitor</h1></body></html>" > "$server_root/$index_page"
fi

# Inicia o servidor Apache
echo "Iniciando o servidor Apache na porta $server_port..."
apache2ctl start

# Exibe informações sobre o servidor web
echo "O servidor web está em execução."
echo "Diretório raiz do servidor: $server_root"
echo "Porta do servidor: $server_port"
echo "Página de índice padrão: $index_page"


# Finaliza o Script
exit 0