#!/bin/bash

# Script para testar conexão MySQL Sink (destino)

echo "🔍 Testando conexão MySQL Sink (destino)..."

# Teste de conectividade básica
echo "📡 Testando conectividade de rede (porta 3396)..."
if timeout 5 bash -c "</dev/tcp/195.200.6.202/3396"; then
    echo "✅ Porta 3396 está acessível"
else
    echo "❌ Porta 3396 não está acessível"
    exit 1
fi

# Teste usando Docker MySQL client
echo "🔐 Testando autenticação no banco arcos_db..."
docker run --rm mysql:8.0 mysql -h195.200.6.202 -P3396 -uarcos_db -p'N7#vP9k$zL1@qXr!5TfG' -e "
    SELECT 'MySQL Sink Connection Test' AS message;
    SHOW DATABASES;
    USE arcos_db;
    SHOW TABLES;
    SELECT '✅ Conexão Sink bem-sucedida!' AS status;
" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Conexão MySQL Sink funcionando corretamente!"
else
    echo "❌ Erro na conexão MySQL Sink"
    echo "🔧 Verificações necessárias:"
    echo "   - Servidor MySQL está ativo na porta 3396?"
    echo "   - Usuário arcos_db tem permissões?"
    echo "   - Banco arcos_db existe?"
    echo "   - Senha está correta?"
fi

echo "🎯 Próximos passos:"
echo "   1. Se conexão OK: pipeline Source → Sink funcionará"
echo "   2. Verificar se ambos MySQL estão funcionando"
echo "   3. Executar: docker-compose up -d --build" 