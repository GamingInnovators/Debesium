# 📬 Guia da Collection Postman - Kafka Connect API

Este guia explica como importar e usar a collection do Postman para gerenciar a API do Kafka Connect no projeto Debesium.

## 📁 Arquivos da Collection

- **`Kafka-Connect-API.postman_collection.json`** - Collection principal com todos os endpoints
- **`Debesium-Environment.postman_environment.json`** - Environment com variáveis pré-configuradas
- **`POSTMAN-COLLECTION-GUIDE.md`** - Este guia

## 🚀 Como Importar no Postman

### 1. **Importar a Collection**

1. Abra o Postman
2. Clique em **"Import"** (canto superior esquerdo)
3. Selecione **"Upload Files"**
4. Escolha o arquivo `Kafka-Connect-API.postman_collection.json`
5. Clique em **"Import"**

### 2. **Importar o Environment**

1. No Postman, clique no ícone de **"Environments"** (⚙️)
2. Clique em **"Import"**
3. Selecione o arquivo `Debesium-Environment.postman_environment.json`
4. Clique em **"Import"**

### 3. **Ativar o Environment**

1. No canto superior direito, onde aparece "No Environment"
2. Selecione **"Debesium - Local Environment"**
3. ✅ Agora todas as variáveis estão ativas!

## 📂 Estrutura da Collection

### 🔧 **System Info**
- **Get Server Info** - Informações básicas do Kafka Connect
- **List Available Plugins** - Plugins de conectores disponíveis

### 📋 **Connector Management**
- **List All Connectors** - Lista todos os conectores
- **Create MySQL Source Connector** - Cria o conector Debezium
- **Create MySQL Sink Connector** - Cria o conector JDBC Sink
- **Get Connector Config** - Obtém configuração de um conector
- **Delete Connector** - Remove um conector

### 📊 **Status & Monitoring**
- **Get MySQL Source Connector Status** - Status do source connector
- **Get MySQL Sink Connector Status** - Status do sink connector
- **Get Connector Status (Generic)** - Status de qualquer conector

### 🎛️ **Connector Control**
- **Pause Connector** - Pausa um conector
- **Resume Connector** - Resume um conector pausado
- **Restart Connector** - Reinicia um conector
- **Restart MySQL Source Connector** - Reinicia source específico
- **Restart MySQL Sink Connector** - Reinicia sink específico

### ⚙️ **Task Management**
- **List Connector Tasks** - Lista tasks de um conector
- **Get Task Status** - Status de uma task específica
- **Restart Task** - Reinicia uma task específica

### 🧪 **Quick Tests**
- **Health Check - All Connectors** - Teste rápido da API
- **Quick Status Check** - Verificação do source connector
- **Pipeline Health Check** - Status geral do sistema

## 🎯 Fluxo de Uso Recomendado

### **1. Verificação Inicial**
```
1. Pipeline Health Check (verifica se API está rodando)
2. List All Connectors (vê conectores existentes)
3. Get Server Info (informações do servidor)
```

### **2. Criar Conectores (se não existirem)**
```
1. Create MySQL Source Connector
2. Create MySQL Sink Connector
```

### **3. Monitoramento**
```
1. Get MySQL Source Connector Status
2. Get MySQL Sink Connector Status
```

### **4. Controle (se necessário)**
```
1. Restart MySQL Source Connector (se FAILED)
2. Pause Connector (para manutenção)
3. Resume Connector (após manutenção)
```

## 🔧 Variáveis de Environment

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `base_url` | `http://localhost:8083` | URL da API Kafka Connect |
| `connector_name` | `mysql-source-connector` | Nome padrão do conector |
| `task_id` | `0` | ID da task (padrão) |
| `mysql_source_host` | `195.200.6.202` | Host MySQL Source |
| `mysql_source_port` | `3310` | Porta MySQL Source |
| `mysql_source_db` | `ArcosbridgeSQL` | Database Source |
| `mysql_sink_host` | `195.200.6.202` | Host MySQL Sink |
| `mysql_sink_port` | `3396` | Porta MySQL Sink |
| `mysql_sink_db` | `arcos_db` | Database Sink |
| `topic_prefix` | `dbserver1` | Prefixo dos tópicos Kafka |
| `kafka_bootstrap_servers` | `kafka:9092` | Servidores Kafka |

## 🧪 Como Testar

### **Teste Básico - Pipeline Funcionando**
1. Execute **"Pipeline Health Check"**
   - ✅ Status 200 = API funcionando
   - ❌ Erro de conexão = Docker não está rodando

2. Execute **"List All Connectors"**
   - ✅ `["mysql-source-connector", "mysql-sink-connector"]` = Conectores criados
   - ✅ `[]` = Nenhum conector (pode criar)

3. Execute **"Get MySQL Source Connector Status"**
   - ✅ `"state": "RUNNING"` = Funcionando
   - ⚠️ `"state": "FAILED"` = Precisa investigar

### **Teste de Criação de Conectores**
1. Execute **"Create MySQL Source Connector"**
   - ✅ Status 201 = Criado com sucesso
   - ❌ Status 409 = Já existe
   - ❌ Status 400 = Configuração inválida

2. Execute **"Create MySQL Sink Connector"**
   - ✅ Status 201 = Criado com sucesso

### **Teste de Status**
1. Execute **"Get MySQL Source Connector Status"**
2. Execute **"Get MySQL Sink Connector Status"**

**Estados Esperados:**
- ✅ `RUNNING` = Funcionando normalmente
- ⚠️ `PAUSED` = Pausado (pode resumir)
- ❌ `FAILED` = Erro (verificar logs, reiniciar)

## 🚨 Troubleshooting com a Collection

### **Problema: API não responde**
- Execute: **"Pipeline Health Check"**
- Se falhar: Verificar se Docker está rodando

### **Problema: Conector FAILED**
1. Execute: **"Get [Connector] Status"**
2. Veja o campo `trace` para detalhes do erro
3. Execute: **"Restart [Connector]"**

### **Problema: Conector não existe**
1. Execute: **"List All Connectors"**
2. Se vazio, execute: **"Create MySQL Source/Sink Connector"**

### **Problema: Task FAILED**
1. Execute: **"List Connector Tasks"**
2. Execute: **"Get Task Status"**
3. Execute: **"Restart Task"**

## 📊 Responses Esperados

### **List All Connectors - Sucesso**
```json
[
    "mysql-source-connector",
    "mysql-sink-connector"
]
```

### **Connector Status - RUNNING**
```json
{
    "name": "mysql-source-connector",
    "connector": {
        "state": "RUNNING",
        "worker_id": "172.19.0.4:8083"
    },
    "tasks": [
        {
            "id": 0,
            "state": "RUNNING",
            "worker_id": "172.19.0.4:8083"
        }
    ],
    "type": "source"
}
```

### **Connector Status - FAILED**
```json
{
    "name": "mysql-source-connector",
    "connector": {
        "state": "RUNNING",
        "worker_id": "172.19.0.4:8083"
    },
    "tasks": [
        {
            "id": 0,
            "state": "FAILED",
            "worker_id": "172.19.0.4:8083",
            "trace": "org.apache.kafka.connect.errors.ConnectException: ..."
        }
    ],
    "type": "source"
}
```

## 🔄 Workflows Úteis

### **Workflow 1: Setup Inicial**
```
1. Pipeline Health Check
2. List All Connectors
3. Create MySQL Source Connector (se necessário)
4. Create MySQL Sink Connector (se necessário)
5. Get MySQL Source Connector Status
6. Get MySQL Sink Connector Status
```

### **Workflow 2: Monitoramento Diário**
```
1. List All Connectors
2. Get MySQL Source Connector Status
3. Get MySQL Sink Connector Status
```

### **Workflow 3: Resolução de Problemas**
```
1. Get [Connector] Status
2. Se FAILED: Restart [Connector]
3. Get [Connector] Status (verificar se resolveu)
4. Se ainda FAILED: Verificar logs Docker
```

### **Workflow 4: Manutenção**
```
1. Pause Connector
2. [Fazer manutenção]
3. Resume Connector
4. Get [Connector] Status (verificar se voltou)
```

## 🎨 Dicas de Uso

### **1. Organização**
- Use as **pastas** para organizar os testes
- Favorite os requests mais usados (⭐)

### **2. Variáveis**
- Edite `connector_name` para testar diferentes conectores
- Modifique `base_url` para ambientes diferentes

### **3. Testes em Lote**
- Use o **Collection Runner** para executar múltiplos requests
- Configure **Tests** para automação

### **4. Documentação**
- Cada request tem uma **descrição** explicando seu uso
- Use **Comments** para adicionar notas específicas

## 📝 Customização

### **Adicionar Novo Environment**
1. Duplique o environment existente
2. Modifique as variáveis (ex: `base_url` para produção)
3. Rename para "Debesium - Production"

### **Adicionar Novos Requests**
1. Duplique um request similar
2. Modifique URL e parâmetros
3. Adicione à pasta apropriada

### **Automação com Tests**
```javascript
// Exemplo de teste para verificar status RUNNING
pm.test("Connector is running", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.connector.state).to.eql("RUNNING");
});
```

## 🚀 Próximos Passos

1. **Importe** a collection e environment
2. **Ative** o environment
3. **Execute** o workflow de setup inicial
4. **Monitore** regularmente o status dos conectores
5. **Customize** conforme suas necessidades

---

**Versão**: 1.0.0  
**Compatível com**: Postman v8.0+  
**Última Atualização**: 2025-01-07 