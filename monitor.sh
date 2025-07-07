#!/bin/bash

echo "🔍 Monitoramento Debezium MySQL Pipeline"
echo "========================================"

# Verificar se o Connect está funcionando
echo "📡 Verificando Connect API..."
if curl -s http://localhost:8083/ > /dev/null; then
    echo "✅ Connect API está rodando"
else
    echo "❌ Connect API não está acessível"
    echo "💡 Execute: docker-compose up -d --build"
    exit 1
fi

echo ""

# Listar conectores
echo "📋 Conectores registrados:"
curl -s http://localhost:8083/connectors | jq -r '.[]' 2>/dev/null || curl -s http://localhost:8083/connectors

echo ""

# Status dos conectores MySQL
echo "🔍 Status do conector MySQL Source:"
mysql_source_status=$(curl -s http://localhost:8083/connectors/mysql-source-connector/status)
echo $mysql_source_status | jq . 2>/dev/null || echo $mysql_source_status

echo ""

echo "🔍 Status do conector MySQL Sink:"
mysql_sink_status=$(curl -s http://localhost:8083/connectors/mysql-sink-connector/status)
echo $mysql_sink_status | jq . 2>/dev/null || echo $mysql_sink_status

echo ""

# Verificar tópicos Kafka
echo "📊 Tópicos Kafka disponíveis:"
docker-compose exec -T kafka kafka-topics --bootstrap-server localhost:9092 --list 2>/dev/null | grep dbserver1 || echo "Nenhum tópico dbserver1 encontrado"

echo ""

# Estatísticas dos conectores
echo "📈 Estatísticas detalhadas:"
echo "MySQL Source Connector:"
mysql_source_metrics=$(curl -s http://localhost:8083/connectors/mysql-source-connector/status)
echo $mysql_source_metrics | jq '.tasks[0].trace' 2>/dev/null || echo "Sem traces disponíveis"

echo "MySQL Sink Connector:"
mysql_sink_metrics=$(curl -s http://localhost:8083/connectors/mysql-sink-connector/status)
echo $mysql_sink_metrics | jq '.tasks[0].trace' 2>/dev/null || echo "Sem traces disponíveis"

echo ""

# Verificar logs recentes
echo "📝 Logs recentes do Connect:"
docker-compose logs --tail=5 connect | grep -E "(ERROR|WARN|mysql-source-connector)" || echo "Nenhum log recente encontrado"

echo ""

# Comandos úteis
echo "🛠️  Comandos úteis:"
echo "  Reiniciar Source:   curl -X POST http://localhost:8083/connectors/mysql-source-connector/restart"
echo "  Reiniciar Sink:     curl -X POST http://localhost:8083/connectors/mysql-sink-connector/restart"
echo "  Pausar Source:      curl -X PUT http://localhost:8083/connectors/mysql-source-connector/pause"
echo "  Pausar Sink:        curl -X PUT http://localhost:8083/connectors/mysql-sink-connector/pause"
echo "  Retomar Source:     curl -X PUT http://localhost:8083/connectors/mysql-source-connector/resume"
echo "  Retomar Sink:       curl -X PUT http://localhost:8083/connectors/mysql-sink-connector/resume"
echo "  Logs em tempo real: docker-compose logs -f connect"
echo "  Testar MySQL:       ./test-mysql-connection.sh"

echo ""
echo "✅ Monitoramento concluído!" 