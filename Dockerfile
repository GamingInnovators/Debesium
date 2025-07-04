FROM debezium/connect:2.5

# Instalar o driver MySQL JDBC
USER root
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.33.tar.gz | tar -xz -C /tmp \
    && cp /tmp/mysql-connector-java-8.0.33/mysql-connector-java-8.0.33.jar /kafka/libs/ \
    && rm -rf /tmp/mysql-connector-java-8.0.33

# Instalar o conector JDBC da Confluent
RUN curl -L https://packages.confluent.io/maven/io/confluent/kafka-connect-jdbc/10.7.4/kafka-connect-jdbc-10.7.4.jar -o /kafka/libs/kafka-connect-jdbc-10.7.4.jar

USER kafka

# Copia o script de inicialização para dentro do container
COPY init-connector.sh /docker-entrypoint-initdb.d/init-connector.sh

EXPOSE 8083 