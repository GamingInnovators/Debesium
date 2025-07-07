#!/bin/sh

echo "Aguardando Connect API estar disponível..."
until curl -f http://connect:8083/; do
  echo "Connect API não está pronta ainda. Aguardando 10 segundos..."
  sleep 10
done

echo "Connect API está pronta! Registrando conector MySQL..."

# Registrar conector MySQL Source
echo "Registrando conector MySQL Source..."
curl -X POST -H "Content-Type: application/json" \
  --data @/tmp/mysql-source-connector.json \
  http://connect:8083/connectors

echo -e "\n"

# Aguardar um pouco antes de registrar o sink
sleep 5

# Registrar conector MySQL Sink
echo "Registrando conector MySQL Sink..."
curl -X POST -H "Content-Type: application/json" \
  --data @/tmp/mysql-sink-connector.json \
  http://connect:8083/connectors

echo -e "\n"

# Verificar status dos conectores
echo "Verificando status dos conectores..."
sleep 10

echo "Status do conector MySQL Source:"
curl -X GET http://connect:8083/connectors/mysql-source-connector/status

echo -e "\n"

echo "Status do conector MySQL Sink:"
curl -X GET http://connect:8083/connectors/mysql-sink-connector/status

echo -e "\n\nConectores MySQL registrados com sucesso!"

# Listar todos os conectores
echo "Conectores disponíveis:"
curl -X GET http://connect:8083/connectors

echo -e "\n"
