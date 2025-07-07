#!/bin/bash

# Script para testar conexão MySQL

echo "🔍 Testando conexão MySQL..."

# Teste de conectividade básica
echo "📡 Testando conectividade de rede..."
if timeout 5 bash -c "</dev/tcp/195.200.6.202/3310"; then
    echo "✅ Porta 3310 está acessível"
else
    echo "❌ Porta 3310 não está acessível"
    exit 1
fi

# Teste usando Docker MySQL client
echo "🔐 Testando autenticação..."
docker run --rm mysql:8.0 mysql -h195.200.6.202 -P3310 -uroot -p'6x{u!bl}N2x46W7@@@' -e "
    SELECT 'MySQL Connection Test' AS message;
    SHOW DATABASES;
    USE ArcosbridgeSQL;
    SHOW TABLES;
    SELECT '✅ Conexão bem-sucedida!' AS status;
" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Conexão MySQL funcionando corretamente!"
else
    echo "❌ Erro na conexão MySQL"
    echo "🔧 Verificações necessárias:"
    echo "   - Servidor MySQL está ativo na porta 3310?"
    echo "   - Usuário root tem permissões?"
    echo "   - Banco ArcosbridgeSQL existe?"
    echo "   - Senha está correta?"
fi

echo "🎯 Próximos passos:"
echo "   1. Se conexão OK: docker-compose up -d --build"
echo "   2. Monitorar logs: docker-compose logs -f connect"
echo "   3. Verificar conectores: curl http://localhost:8083/connectors" 