# 📚 Documentação da API Kafka Connect - Debesium Pipeline

Esta documentação Swagger/OpenAPI descreve a API REST do Kafka Connect utilizada para gerenciar conectores Debezium e JDBC Sink no pipeline de replicação MySQL-to-MySQL.

## 🗂️ Arquivos da Documentação

- **`swagger.yml`** - Especificação OpenAPI 3.0.3 completa
- **`swagger-ui.html`** - Interface web para visualizar e testar a API
- **`API-README.md`** - Este arquivo de documentação

## 🌐 Como Visualizar a Documentação

### Opção 1: Interface Web Local (Recomendado)
1. Abra o arquivo `swagger-ui.html` no seu navegador
2. A interface Swagger UI será carregada automaticamente
3. Você pode testar os endpoints diretamente na interface

### Opção 2: Swagger Editor Online
1. Acesse [editor.swagger.io](https://editor.swagger.io)
2. Copie o conteúdo do arquivo `swagger.yml`
3. Cole no editor online

### Opção 3: Ferramentas CLI
```bash
# Usando swagger-codegen
swagger-codegen generate -i swagger.yml -l html2 -o docs/

# Usando redoc-cli
redoc-cli build swagger.yml --output api-docs.html
```

## 🔌 Conectores Documentados

### 📤 MySQL Source Connector (Debezium)
- **Classe**: `io.debezium.connector.mysql.MySqlConnector`
- **Função**: Captura mudanças (CDC) do MySQL de origem
- **Servidor**: 195.200.6.202:3310 (ArcosbridgeSQL)

### 📥 MySQL Sink Connector (JDBC)
- **Classe**: `io.confluent.connect.jdbc.JdbcSinkConnector`
- **Função**: Replica dados para MySQL de destino
- **Servidor**: 195.200.6.202:3396 (arcos_db)

## 🎯 Principais Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/connectors` | Listar todos os conectores |
| `POST` | `/connectors` | Criar novo conector |
| `GET` | `/connectors/{name}/status` | Verificar status do conector |
| `DELETE` | `/connectors/{name}` | Remover conector |
| `PUT` | `/connectors/{name}/pause` | Pausar conector |
| `PUT` | `/connectors/{name}/resume` | Resumir conector |
| `POST` | `/connectors/{name}/restart` | Reiniciar conector |

## 🧪 Exemplos de Uso

### Listar Conectores
```bash
curl -X GET http://localhost:8083/connectors
```

### Verificar Status
```bash
curl -X GET http://localhost:8083/connectors/mysql-source-connector/status
```

### Criar Source Connector
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "mysql-source-connector",
    "config": {
      "connector.class": "io.debezium.connector.mysql.MySqlConnector",
      "database.hostname": "195.200.6.202",
      "database.port": "3310",
      "database.user": "root",
      "database.password": "6x{u!bl}N2x46W7@@@",
      "database.server.id": "184054",
      "topic.prefix": "dbserver1",
      "database.include.list": "ArcosbridgeSQL",
      "table.include.list": "ArcosbridgeSQL.*",
      "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
      "schema.history.internal.kafka.topic": "dbhistory.arcos",
      "snapshot.mode": "initial"
    }
  }' \
  http://localhost:8083/connectors
```

### Pausar Conector
```bash
curl -X PUT http://localhost:8083/connectors/mysql-source-connector/pause
```

## 🏗️ Arquitetura da Pipeline

```
MySQL Source (3310) → Debezium → Kafka Topics → JDBC Sink → MySQL Sink (3396)
                      ↓            ↓             ↓
              mysql-source-  dbserver1.*   mysql-sink-
               connector                   connector
```

## 🔧 Estados dos Conectores

- **`UNASSIGNED`** - Não atribuído a nenhum worker
- **`RUNNING`** - Funcionando normalmente
- **`PAUSED`** - Pausado manualmente
- **`FAILED`** - Falhou (verificar logs para detalhes)

## 📊 Monitoramento

### Verificar Saúde da Pipeline
```bash
# Status de ambos os conectores
curl -s http://localhost:8083/connectors/mysql-source-connector/status | jq .
curl -s http://localhost:8083/connectors/mysql-sink-connector/status | jq .

# Usar script de monitoramento
./monitor.sh
```

### Logs dos Conectores
```bash
# Ver logs do container Connect
docker logs -f connect

# Ver logs específicos de um conector
docker exec connect tail -f /kafka/logs/connect.log | grep mysql-source-connector
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Conector FAILED**
   - Verificar credenciais do banco
   - Verificar conectividade de rede
   - Verificar logs: `docker logs connect`

2. **Task FAILED**
   - Verificar configuração do schema history
   - Verificar se o Kafka está rodando
   - Reiniciar o conector: `POST /connectors/{name}/restart`

3. **Conectividade**
   - Testar conexão MySQL: `./test-mysql-connection.sh`
   - Verificar se portas estão abertas

### Comandos Úteis
```bash
# Reiniciar conector específico
curl -X POST http://localhost:8083/connectors/mysql-source-connector/restart

# Ver plugins disponíveis
curl -X GET http://localhost:8083/connector-plugins

# Deletar e recriar conector
curl -X DELETE http://localhost:8083/connectors/mysql-source-connector
# ... depois criar novamente com POST
```

## 📖 Referências

- [Debezium MySQL Connector](https://debezium.io/documentation/reference/connectors/mysql.html)
- [Confluent JDBC Sink Connector](https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/index.html)
- [Kafka Connect REST API](https://docs.confluent.io/platform/current/connect/references/restapi.html)
- [OpenAPI 3.0 Specification](https://swagger.io/specification/)

---

**Versão da API**: 1.0.0  
**Última Atualização**: $(date +'%Y-%m-%d')  
**Equipe**: Debesium Team 