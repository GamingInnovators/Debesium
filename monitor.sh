#!/bin/bash

# Script para monitorar o status dos conectores Debezium

echo "=========================================="
echo "MONITORAMENTO DEBEZIUM - ARCOS BRIDGE"
echo "=========================================="

# Função para verificar se o Connect está rodando
check_connect() {
    echo "📡 Verificando Connect API..."
    if curl -s http://localhost:8083/ > /dev/null; then
        echo "✅ Connect API está rodando"
        return 0
    else
        echo "❌ Connect API não está acessível"
        return 1
    fi
}

# Função para listar conectores
list_connectors() {
    echo -e "\n📋 Conectores registrados:"
    curl -s http://localhost:8083/connectors | jq -r '.[]' 2>/dev/null || echo "Nenhum conector encontrado"
}

# Função para verificar status dos conectores
check_connector_status() {
    local connector_name=$1
    echo -e "\n🔍 Status do conector: $connector_name"
    
    status=$(curl -s http://localhost:8083/connectors/$connector_name/status 2>/dev/null)
    
    if [ $? -eq 0 ] && [ "$status" != "" ]; then
        echo "$status" | jq '.' 2>/dev/null || echo "$status"
    else
        echo "❌ Conector não encontrado ou erro na consulta"
    fi
}

# Função para verificar tópicos Kafka
check_kafka_topics() {
    echo -e "\n📊 Tópicos Kafka relacionados ao dbserver1:"
    docker-compose exec kafka kafka-topics --bootstrap-server localhost:9092 --list | grep dbserver1 || echo "Nenhum tópico encontrado"
}

# Função para mostrar logs dos serviços
show_logs() {
    echo -e "\n📝 Últimos logs do Connect:"
    docker-compose logs --tail=20 connect
}

# Executar verificações
if check_connect; then
    list_connectors
    check_connector_status "mongo-connector"
    check_connector_status "mysql-sink-connector"
    check_kafka_topics
else
    echo "⚠️  Verifique se os serviços estão rodando: docker-compose ps"
fi

echo -e "\n=========================================="
echo "Para ver logs em tempo real: docker-compose logs -f connect"
echo "Para reiniciar conectores: curl -X POST http://localhost:8083/connectors/NOME/restart"
echo "==========================================" 