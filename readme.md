# Debesium - Pipeline de Dados MySQL → Kafka

## 📋 Descrição

Este projeto implementa um pipeline completo de replicação de dados usando **Apache Kafka**, **Debezium** e **JDBC Sink Connector**. O sistema captura mudanças (Change Data Capture - CDC) do banco **MySQL Source** (`ArcosbridgeSQL`) e replica automaticamente para o banco **MySQL Sink** (`arcos_db`), garantindo sincronização em tempo real entre os dois bancos de dados.

## 🏗️ Arquitetura

```
MySQL Source (195.200.6.202:3310/ArcosbridgeSQL) → Debezium → Kafka → JDBC Sink → MySQL Sink (195.200.6.202:3396/arcos_db)
```

### Componentes

- **Zookeeper**: Coordenação e gerenciamento de cluster
- **Apache Kafka**: Plataforma de streaming de dados
- **Debezium Connect**: Serviço de conectores Kafka com drivers MySQL e JDBC
- **MySQL Source**: Banco de dados origem (`195.200.6.202:3310/ArcosbridgeSQL`)
- **MySQL Sink**: Banco de dados destino (`195.200.6.202:3396/arcos_db`)

## 🚀 Como Executar

### Pré-requisitos

- Docker Desktop
- Docker Compose
- Acesso de rede ao banco MySQL externo

### Passos para Execução

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd Debesium
   ```

2. **Teste as conexões MySQL (recomendado)**
   ```bash
   # Testar MySQL Source (Linux/Mac)
   ./test-mysql-connection.sh
   ./test-mysql-sink-connection.sh
   
   # Testar MySQL Source (Windows PowerShell)
   .\test-mysql-connection.ps1
   .\test-mysql-sink-connection.ps1
   ```

3. **Construa e execute o projeto**
   ```bash
   docker-compose up -d --build
   ```

4. **Verifique se todos os serviços estão rodando**
   ```bash
   docker-compose ps
   ```

5. **Monitore os logs**
   ```bash
   docker-compose logs -f connect
   ```

6. **Verifique os conectores**
   ```bash
   # Listar conectores
   curl http://localhost:8083/connectors
   
   # Verificar status
   curl http://localhost:8083/connectors/mysql-source-connector/status
   ```

## 📁 Estrutura do Projeto

```
Debesium/
├── docker-compose.yml             # Configuração dos serviços Docker
├── Dockerfile                     # Imagem personalizada com drivers MySQL
├── init-connector.sh             # Script de inicialização do conector
├── mysql-source-connector.json   # Configuração do conector MySQL
├── test-mysql-connection.sh      # Teste de conexão MySQL (Linux/Mac)
├── test-mysql-connection.ps1     # Teste de conexão MySQL (Windows)
├── monitor.sh                    # Script de monitoramento
└── readme.md                     # Este arquivo
```

## ⚙️ Configuração

### Conector MySQL (Source)

O conector MySQL está configurado para:
- **Servidor**: `195.200.6.202:3310`
- **Banco**: `ArcosbridgeSQL`
- **Usuário**: `root`
- **Senha**: `6x{u!bl}N2x46W7@@@`
- **Modo**: Snapshot inicial + captura contínua
- **Tabelas**: Todas as tabelas do banco `ArcosbridgeSQL`
- **Tópico base**: `dbserver1`

### Tópicos Kafka Gerados

Os tópicos serão criados automaticamente no formato:
```
dbserver1.ArcosbridgeSQL.<nome_da_tabela>
```

## 🔍 Monitoramento

### Verificar Status dos Conectores

```bash
# Listar conectores
curl http://localhost:8083/connectors

# Verificar status específico
curl http://localhost:8083/connectors/mysql-source-connector/status

# Verificar configuração
curl http://localhost:8083/connectors/mysql-source-connector/config

# Verificar tópicos Kafka
docker-compose exec kafka kafka-topics --bootstrap-server localhost:9092 --list
```

### Logs dos Serviços

```bash
# Logs do Kafka Connect
docker-compose logs connect

# Logs do Kafka
docker-compose logs kafka

# Logs em tempo real
docker-compose logs -f connect
```

### Consumir Mensagens de um Tópico

```bash
# Exemplo: consumir mensagens de uma tabela específica
docker-compose exec kafka kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic dbserver1.ArcosbridgeSQL.sua_tabela \
  --from-beginning \
  --property print.key=true
```

## 🛠️ Desenvolvimento

### Reiniciar Conectores

```bash
# Reiniciar conector específico
curl -X POST http://localhost:8083/connectors/mysql-source-connector/restart

# Pausar conector
curl -X PUT http://localhost:8083/connectors/mysql-source-connector/pause

# Retomar conector
curl -X PUT http://localhost:8083/connectors/mysql-source-connector/resume

# Deletar conector
curl -X DELETE http://localhost:8083/connectors/mysql-source-connector
```

### Modificar Configurações

1. **MySQL**: Edite `mysql-source-connector.json`
2. **Reconstruir**: `docker-compose down && docker-compose up -d --build`

## 🔧 Troubleshooting

### Problemas Comuns

1. **Conector não inicia**
   - Verifique conectividade com o banco MySQL externo
   - Confirme credenciais no arquivo `mysql-source-connector.json`
   - Verifique logs: `docker-compose logs connect`

2. **Erro de conexão MySQL**
   - Execute: `./test-mysql-connection.sh` ou `.\test-mysql-connection.ps1`
   - Verifique se o MySQL está rodando na porta 3310
   - Confirme usuário e senha
   - Verifique se o banco `ArcosbridgeSQL` existe

3. **Erro "binlog not enabled"**
   - O MySQL precisa ter binary logging habilitado
   - Verifique: `SHOW VARIABLES LIKE 'log_bin';`
   - Configure: `log-bin=mysql-bin` no my.cnf

4. **Problemas de rede**
   - Verifique firewall e portas
   - Confirme se o IP 195.200.6.202:3310 está acessível

### Comandos Úteis

```bash
# Reiniciar todos os serviços
docker-compose restart

# Parar e remover containers
docker-compose down

# Reconstruir imagens
docker-compose build --no-cache

# Ver logs específicos
docker-compose logs -f connect

# Verificar saúde dos serviços
docker-compose ps

# Testar conectividade
telnet 195.200.6.202 3310
```

## 📊 Portas Utilizadas

- **8083**: Kafka Connect REST API
- **9092**: Apache Kafka
- **2181**: Zookeeper
- **3310**: MySQL Externo

## 🔒 Segurança

⚠️ **Importante**: Este projeto contém credenciais hardcoded nos arquivos de configuração. Em ambiente de produção, considere:

- Usar variáveis de ambiente para credenciais
- Implementar SSL/TLS para conexões
- Usar secrets management (Docker Secrets, Kubernetes Secrets)
- Configurar rede isolada para bancos de dados

## 📝 Notas Importantes

- O MySQL precisa ter binary logging habilitado para CDC
- O usuário MySQL precisa ter privilégios de REPLICATION
- As tabelas precisam ter PRIMARY KEY para funcionar corretamente
- O snapshot inicial pode demorar dependendo do tamanho das tabelas

## 🎯 Próximos Passos

Após configurar o pipeline, você pode:

1. **Criar consumidores** para processar os dados do Kafka
2. **Implementar transformações** usando Kafka Streams
3. **Configurar conectores de destino** (ElasticSearch, S3, etc.)
4. **Adicionar monitoramento** com Prometheus/Grafana
5. **Implementar schema registry** para controle de schemas
