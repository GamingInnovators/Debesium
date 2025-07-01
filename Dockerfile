FROM debezium/connect:2.5

# Copia o script de inicialização para dentro do container
COPY init-connector.sh /docker-entrypoint-initdb.d/init-connector.sh

EXPOSE 8083 