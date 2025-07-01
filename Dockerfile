FROM debezium/connect:2.5

# Instalar o confluent-hub client
USER root
RUN apt-get update && apt-get install -y curl unzip && \
    curl -L --output /tmp/confluent-hub-client.tar.gz https://packages.confluent.io/confluent-hub-client/confluent-hub-client-latest.tar.gz && \
    mkdir -p /usr/local/confluent-hub-client && \
    tar -xzf /tmp/confluent-hub-client.tar.gz -C /usr/local/confluent-hub-client && \
    ln -s /usr/local/confluent-hub-client/bin/confluent-hub /usr/local/bin/confluent-hub && \
    rm /tmp/confluent-hub-client.tar.gz

# Instalar o conector MySQL JDBC
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4

# Copia o script de inicialização para dentro do container
COPY init-connector.sh /docker-entrypoint-initdb.d/init-connector.sh

EXPOSE 8083 