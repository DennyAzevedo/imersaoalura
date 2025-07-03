# Etapa 1: Imagem base
# Usar uma imagem 'slim' é uma boa prática para manter o tamanho final menor.
# Recomendo usar uma versão estável do Python, como a 3.11.
FROM python:3.11-slim

# Definir o autor da imagem (opcional, mas bom para metadados)
LABEL authors="Denny Azevedo"

# Etapa 2: Configurar o ambiente
# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Variáveis de ambiente para Python
# Impede o Python de gerar arquivos .pyc
ENV PYTHONDONTWRITEBYTECODE 1
# Garante que a saída do Python seja enviada diretamente para o terminal
ENV PYTHONUNBUFFERED 1

# Etapa 3: Instalar dependências
# Copie primeiro o arquivo de dependências para aproveitar o cache de camadas do Docker.
# Se requirements.txt não mudar, o Docker não reinstalará as dependências.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 4: Copiar o código da aplicação
# Copia todos os arquivos do diretório atual para o diretório de trabalho no contêiner.
COPY . .

# Etapa 5: Expor a porta
# Informa ao Docker que o contêiner escutará na porta 8000.
EXPOSE 8000

# Etapa 6: Comando para executar a aplicação
# Inicia o servidor Uvicorn para servir a aplicação FastAPI.
# --host 0.0.0.0 é essencial para que a aplicação seja acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]