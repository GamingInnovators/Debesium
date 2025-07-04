#!/bin/sh

echo "Aguardando Connect API estar disponível..."
until curl -f http://connect:8083/; do
  echo "Connect API não está pronta ainda. Aguardando 10 segundos..."
  sleep 10
done

echo "Connect API está pronta! Registrando conectores..."

# Registrar conector MongoDB
echo "Registrando conector MongoDB..."
curl -X POST -H "Content-Type: application/json" \
  --data @/tmp/mongo-connector.json \
  http://connect:8083/connectors

echo -e "\n"

# Aguardar um pouco antes de registrar o próximo conector
sleep 5

# Registrar conector MySQL
echo "Registrando conector MySQL..."
curl -X POST -H "Content-Type: application/json" \
  --data @/tmp/mysql-sink-connector.json \
  http://connect:8083/connectors

echo -e "\n"

# Verificar status dos conectores
echo "Verificando status dos conectores..."
sleep 10

echo "Status do conector MongoDB:"
curl -X GET http://connect:8083/connectors/mongo-connector/status

echo -e "\n\nStatus do conector MySQL:"
curl -X GET http://connect:8083/connectors/mysql-sink-connector/status

echo -e "\n\nConectores registrados com sucesso!"
