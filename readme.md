# Debesium - Pipeline de Dados MongoDB → MySQL

## 📋 Descrição

Este projeto implementa um pipeline de dados usando **Apache Kafka** e **Debezium** para capturar mudanças (Change Data Capture - CDC) do banco de dados **MongoDB externo** (`arcos-bridge`) e sincronizá-las com o banco **MySQL externo** (`arcos_db`). O sistema utiliza a arquitetura de conectores Kafka para garantir uma sincronização em tempo real entre os bancos de dados.

## 🏗️ Arquitetura

```
MongoDB (195.200.6.202:27032) → Debezium Connector → Apache Kafka → JDBC Sink Connector → MySQL (195.200.6.202:3396)
```

### Componentes

- **Zookeeper**: Coordenação e gerenciamento de cluster
- **Apache Kafka**: Plataforma de streaming de dados
- **Debezium Connect**: Serviço de conectores Kafka com drivers personalizados
- **MongoDB Externo**: Banco de dados fonte (`arcos-bridge`)
- **MySQL Externo**: Banco de dados de destino (`arcos_db`)

## 🚀 Como Executar

### Pré-requisitos

- Docker Desktop
- Docker Compose
- Acesso de rede aos bancos externos

### Passos para Execução

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd Debesium
   ```

2. **Construa e execute o projeto**
   ```bash
   docker-compose up -d --build
   ```

3. **Verifique se todos os serviços estão rodando**
   ```bash
   docker-compose ps
   ```

4. **Monitore os logs**
   ```bash
   docker-compose logs -f connect
   ```

5. **Execute o script de monitoramento (Linux/Mac)**
   ```bash
   ./monitor.sh
   ```

   **No Windows PowerShell:**
   ```powershell
   # Verificar conectores
   curl http://localhost:8083/connectors
   
   # Verificar status
   curl http://localhost:8083/connectors/mongo-connector/status
   curl http://localhost:8083/connectors/mysql-sink-connector/status
   ```

## 📁 Estrutura do Projeto

```
Debesium/
├── docker-compose.yml          # Configuração dos serviços Docker
├── Dockerfile                  # Imagem personalizada com drivers MySQL
├── init-connector.sh          # Script de inicialização dos conectores
├── mongo-connector.json       # Configuração do conector MongoDB
├── mysql-sink-connector.json  # Configuração do conector MySQL
├── monitor.sh                 # Script de monitoramento
└── readme.md                  # Este arquivo
```

## ⚙️ Configuração

### Conector MongoDB (Fonte)

O conector MongoDB está configurado para:
- **Servidor**: `195.200.6.202:27032`
- **Banco**: `arcos-bridge`
- **Usuário**: `arcos-bridge-db`
- **Modo**: Change Streams com snapshot inicial
- **Coleções**: Todas as coleções do banco `arcos-bridge`

### Conector MySQL (Destino)

O conector MySQL está configurado para:
- **Servidor**: `195.200.6.202:3396`
- **Banco**: `arcos_db`
- **Usuário**: `arcos_db`
- **Modo**: Upsert com chave primária `_id`
- **Tabelas**: Criadas automaticamente baseadas nos tópicos Kafka

## 🔍 Monitoramento

### Verificar Status dos Conectores

```bash
# Listar conectores
curl http://localhost:8083/connectors

# Verificar status específico
curl http://localhost:8083/connectors/mongo-connector/status
curl http://localhost:8083/connectors/mysql-sink-connector/status

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

## 🛠️ Desenvolvimento

### Reiniciar Conectores

```bash
# Reiniciar conector específico
curl -X POST http://localhost:8083/connectors/mongo-connector/restart

# Pausar conector
curl -X PUT http://localhost:8083/connectors/mongo-connector/pause

# Retomar conector
curl -X PUT http://localhost:8083/connectors/mongo-connector/resume
```

### Modificar Configurações

1. **MongoDB**: Edite `mongo-connector.json`
2. **MySQL**: Edite `mysql-sink-connector.json`
3. **Reconstroir**: `docker-compose down && docker-compose up -d --build`

## 🔧 Troubleshooting

### Problemas Comuns

1. **Conectores não iniciam**
   - Verifique conectividade com os bancos externos
   - Confirme credenciais nos arquivos JSON
   - Verifique logs: `docker-compose logs connect`

2. **Erro de conexão MongoDB**
   - Teste conexão: `telnet 195.200.6.202 27032`
   - Verifique se o MongoDB tem replica set configurado
   - Confirme usuário e senha

3. **Erro de conexão MySQL**
   - Teste conexão: `telnet 195.200.6.202 3396`
   - Verifique permissões do usuário MySQL
   - Confirme se o banco `arcos_db` existe

4. **Problemas de rede**
   - Verifique firewall e portas
   - Confirme se os IPs externos estão acessíveis

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
```

## 📊 Portas Utilizadas

- **8083**: Kafka Connect REST API
- **9092**: Apache Kafka
- **2181**: Zookeeper

## 🔒 Segurança

⚠️ **Importante**: Este projeto contém credenciais hardcoded nos arquivos de configuração. Em ambiente de produção, considere:

- Usar variáveis de ambiente
- Implementar secrets management
- Usar Docker secrets
- Criptografar senhas

## 🎯 Fluxo de Dados

1. **Captura**: Debezium monitora mudanças no MongoDB via Change Streams
2. **Streaming**: Eventos são enviados para tópicos Kafka (`dbserver1.arcos-bridge.collection_name`)
3. **Transformação**: Dados são transformados e roteados pelo Connect
4. **Sink**: JDBC Sink Connector escreve dados no MySQL

## 📝 Notas Importantes

- O MongoDB deve ter replica set configurado para Change Streams
- O MySQL deve permitir conexões externas
- Tabelas são criadas automaticamente no MySQL
- Chave primária baseada no `_id` do MongoDB
- Suporte a operações INSERT, UPDATE e DELETE

## 🤝 Contribuição

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

## 📚 Referências

- [Debezium MongoDB Connector](https://debezium.io/documentation/reference/connectors/mongodb.html)
- [Confluent JDBC Sink Connector](https://docs.confluent.io/kafka-connect-jdbc/current/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [MongoDB Change Streams](https://docs.mongodb.com/manual/changeStreams/)
