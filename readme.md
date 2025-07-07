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
├── docker-compose.yml               # Configuração dos serviços Docker
├── Dockerfile                       # Imagem personalizada com drivers MySQL
├── init-connector.sh               # Script de inicialização dos conectores
├── mysql-source-connector.json     # Configuração do conector MySQL Source
├── mysql-sink-connector.json       # Configuração do conector MySQL Sink
├── test-mysql-connection.sh        # Teste conexão MySQL Source (Linux/Mac)
├── test-mysql-connection.ps1       # Teste conexão MySQL Source (Windows)
├── test-mysql-sink-connection.sh   # Teste conexão MySQL Sink (Linux/Mac)
├── test-mysql-sink-connection.ps1  # Teste conexão MySQL Sink (Windows)
├── monitor.sh                      # Script de monitoramento
├── swagger.yml                     # Documentação OpenAPI da API REST
├── swagger-ui.html                 # Interface web para visualizar a API
├── API-README.md                   # Guia de uso da documentação da API
├── Kafka-Connect-API.postman_collection.json # Collection Postman completa
├── Debesium-Environment.postman_environment.json # Environment Postman
├── POSTMAN-COLLECTION-GUIDE.md    # Guia de uso da collection Postman
└── readme.md                       # Este arquivo
```

## 📚 Documentação da API

O projeto inclui documentação completa da API REST do Kafka Connect:

- **`swagger.yml`** - Especificação OpenAPI 3.0.3 completa
- **`swagger-ui.html`** - Interface web interativa (requer servidor HTTP)
- **`swagger-ui-inline.html`** - Interface web que funciona diretamente no navegador
- **`API-README.md`** - Guia detalhado de uso da API

### 🌐 Como Usar a Documentação da API

1. **Visualização Local (Recomendada)**: Abra o arquivo `swagger-ui-inline.html` no navegador
   - ✅ Funciona diretamente sem problemas de CORS
   - Simples: clique duas vezes no arquivo ou use `start swagger-ui-inline.html`

2. **Visualização com servidor HTTP**: Use `swagger-ui.html` servindo através de um servidor local
   - Exemplo: `python -m http.server 8000` e acesse `http://localhost:8000/swagger-ui.html`

3. **Online**: Cole o conteúdo de `swagger.yml` em [editor.swagger.io](https://editor.swagger.io)

4. **Endpoints Principais**:
   - `GET /connectors` - Listar conectores
   - `POST /connectors` - Criar conector
   - `GET /connectors/{name}/status` - Status do conector
   - `DELETE /connectors/{name}` - Remover conector
   - `PUT /connectors/{name}/pause` - Pausar conector
   - `PUT /connectors/{name}/resume` - Resumir conector

💡 **Nota**: Se você encontrou o erro "Failed to load API definition" no `swagger-ui.html`, use o arquivo `swagger-ui-inline.html` que foi criado especificamente para resolver problemas de CORS quando arquivos são abertos diretamente no navegador.

### 📋 Exemplos de Uso da API

```bash
# Listar conectores
curl -X GET http://localhost:8083/connectors

# Verificar status
curl -X GET http://localhost:8083/connectors/mysql-source-connector/status

# Pausar conector
curl -X PUT http://localhost:8083/connectors/mysql-source-connector/pause

# Reiniciar conector
curl -X POST http://localhost:8083/connectors/mysql-source-connector/restart
```

### 📬 **Collection Postman**

Para facilitar o uso da API, incluímos uma collection completa do Postman:

- **`Kafka-Connect-API.postman_collection.json`** - Collection com todos os endpoints organizados
- **`Debesium-Environment.postman_environment.json`** - Environment com variáveis pré-configuradas
- **`POSTMAN-COLLECTION-GUIDE.md`** - Guia detalhado de importação e uso

#### 🚀 **Como Usar**
1. **Importe** os arquivos no Postman (Import → Upload Files)
2. **Ative** o environment "Debesium - Local Environment"
3. **Execute** os requests organizados por categoria:
   - 🔧 System Info
   - 📋 Connector Management
   - 📊 Status & Monitoring
   - 🎛️ Connector Control
   - ⚙️ Task Management
   - 🧪 Quick Tests

#### 🎯 **Workflows Prontos**
- **Setup Inicial**: Health Check → List Connectors → Create Connectors
- **Monitoramento**: Status checks de ambos os conectores
- **Troubleshooting**: Restart connectors, verificar tasks
- **Manutenção**: Pause/Resume connectors

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

4. **Erro 404 no MySQL Connector (CORRIGIDO)**
   - ✅ **Problema resolvido**: O MySQL Connector mudou de localização no Maven Central
   - **Antigo**: `mysql:mysql-connector-java` (não funciona mais)
   - **Novo**: `com.mysql:mysql-connector-j` (atualizado no Dockerfile)
   - Dockerfile corrigido para usar a nova URL

5. **Problemas de rede**
   - Verifique firewall e portas
   - Confirme se os IPs 195.200.6.202:3310 e 3396 estão acessíveis

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
