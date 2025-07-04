FROM debezium/connect:2.5

# Instalar dependências necessárias
USER root
RUN microdnf install -y wget

# Baixar e instalar o driver MySQL JDBC
RUN wget -O /tmp/mysql-connector.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar \
    && cp /tmp/mysql-connector.jar /kafka/libs/mysql-connector-java-8.0.33.jar \
    && rm /tmp/mysql-connector.jar

# Baixar e instalar o conector JDBC da Confluent
RUN wget -O /tmp/kafka-connect-jdbc.jar https://packages.confluent.io/maven/io/confluent/kafka-connect-jdbc/10.7.4/kafka-connect-jdbc-10.7.4.jar \
    && cp /tmp/kafka-connect-jdbc.jar /kafka/libs/kafka-connect-jdbc-10.7.4.jar \
    && rm /tmp/kafka-connect-jdbc.jar

# Verificar se os JARs foram instalados corretamente
RUN ls -la /kafka/libs/mysql-connector-java-8.0.33.jar /kafka/libs/kafka-connect-jdbc-10.7.4.jar

USER kafka

# Copia o script de inicialização para dentro do container
COPY init-connector.sh /docker-entrypoint-initdb.d/init-connector.sh

EXPOSE 8083 