FROM debezium/connect:2.5

# Instalar o conector MySQL JDBC
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4

# Copia o script de inicialização para dentro do container
COPY init-connector.sh /docker-entrypoint-initdb.d/init-connector.sh

EXPOSE 8083 