# Debesium - Pipeline de Dados com Apache Kafka

## 📋 Descrição

Este projeto implementa um pipeline de dados usando **Apache Kafka** e **Debezium** para capturar mudanças (Change Data Capture - CDC) de um banco de dados **MongoDB** e sincronizá-las com um banco **MySQL**. O sistema utiliza a arquitetura de conectores Kafka para garantir uma sincronização em tempo real entre os bancos de dados.

## 🏗️ Arquitetura

```
MongoDB → Debezium Connector → Apache Kafka → JDBC Sink Connector → MySQL
```

### Componentes

- **Zookeeper**: Coordenação e gerenciamento de cluster
- **Apache Kafka**: Plataforma de streaming de dados
- **MongoDB**: Banco de dados fonte (com replicação)
- **Debezium Connect**: Serviço de conectores Kafka
- **MySQL**: Banco de dados de destino

## 🚀 Como Executar

### Pré-requisitos

- Docker
- Docker Compose

### Passos para Execução

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd Debesium
   ```

2. **Execute o projeto**
   ```bash
   docker-compose up -d
   ```

3. **Verifique se todos os serviços estão rodando**
   ```bash
   docker-compose ps
   ```

## 📁 Estrutura do Projeto

```
Debesium/
├── docker-compose.yml          # Configuração dos serviços Docker
├── Dockerfile                  # Imagem personalizada do Debezium Connect
├── init-connector.sh          # Script de inicialização dos conectores
├── mongo-connector.json       # Configuração do conector MongoDB
├── mysql-sink-connector.json  # Configuração do conector MySQL
└── readme.md                  # Este arquivo
```

## ⚙️ Configuração

### Conector MongoDB (Fonte)

O conector MongoDB está configurado para:
- Conectar ao MongoDB em `195.200.6.202:27032`
- Capturar mudanças do banco `arcos-bridge`
- Incluir todas as coleções (`.*`)
- Extrair apenas o novo estado do documento

### Conector MySQL (Destino)

O conector MySQL está configurado para:
- Conectar ao MySQL local em `mysql:3306`
- Banco de dados: `api_gateway_db`
- Criar automaticamente tabelas e esquemas
- Usar modo upsert com chave primária baseada no campo `id`
- Habilitar operações de delete

## 🔍 Monitoramento

### Verificar Status dos Conectores

```bash
# Listar conectores
curl -X GET http://localhost:8083/connectors

# Verificar status de um conector específico
curl -X GET http://localhost:8083/connectors/mongo-connector/status
curl -X GET http://localhost:8083/connectors/mysql-sink-connector/status
```

### Logs dos Serviços

```bash
# Logs do Kafka Connect
docker-compose logs connect

# Logs do MongoDB
docker-compose logs mongo

# Logs do MySQL
docker-compose logs mysql

# Logs do Kafka
docker-compose logs kafka
```

## 🛠️ Desenvolvimento

### Adicionar Novos Conectores

1. Crie um arquivo JSON com a configuração do conector
2. Adicione o comando curl no script `init-connector.sh`
3. Reinicie os serviços

### Modificar Configurações

- **MongoDB**: Edite `mongo-connector.json`
- **MySQL**: Edite `mysql-sink-connector.json`
- **Docker**: Edite `docker-compose.yml`

## 🔧 Troubleshooting

### Problemas Comuns

1. **Conectores não iniciam**
   - Verifique se o MongoDB está acessível
   - Confirme as credenciais no arquivo de configuração
   - Verifique os logs do serviço connect

2. **Erro de conexão com banco**
   - Valide endereços IP e portas
   - Confirme usuário e senha
   - Verifique se o banco está rodando

3. **Problemas de rede**
   - Verifique se as portas não estão em uso
   - Confirme configurações de firewall

### Comandos Úteis

```bash
# Reiniciar todos os serviços
docker-compose restart

# Parar e remover containers
docker-compose down

# Remover volumes (cuidado: apaga dados)
docker-compose down -v

# Ver logs em tempo real
docker-compose logs -f
```

## 📊 Portas Utilizadas

- **8083**: Kafka Connect REST API
- **9092**: Apache Kafka
- **2181**: Zookeeper
- **27017**: MongoDB
- **3306**: MySQL

## 🔒 Segurança

⚠️ **Importante**: Este projeto contém credenciais hardcoded nos arquivos de configuração. Em ambiente de produção, considere:

- Usar variáveis de ambiente
- Implementar secrets management
- Usar Docker secrets ou Kubernetes secrets
- Criptografar senhas

## 📝 Licença

Este projeto é de uso interno. Consulte a documentação oficial do Debezium para mais informações sobre licenciamento.

## 🤝 Contribuição

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

## 📚 Referências

- [Debezium Documentation](https://debezium.io/documentation/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [MongoDB Change Streams](https://docs.mongodb.com/manual/changeStreams/)
- [Confluent JDBC Sink Connector](https://docs.confluent.io/kafka-connect-jdbc/current/)
