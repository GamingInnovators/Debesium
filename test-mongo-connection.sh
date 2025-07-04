#!/bin/bash

# Script para testar conexão MongoDB com replica set

echo "🔍 Testando conexão MongoDB com replica set..."

# Teste de conectividade básica
echo "📡 Testando conectividade de rede..."
if timeout 5 bash -c "</dev/tcp/195.200.6.202/27032"; then
    echo "✅ Porta 27032 está acessível"
else
    echo "❌ Porta 27032 não está acessível"
    exit 1
fi

# Teste usando mongosh (se disponível)
echo "🔐 Testando autenticação..."
docker run --rm mongo:6 mongosh "mongodb://admin:admin123@195.200.6.202:27032/admin?authSource=admin&replicaSet=rs0" --eval "
    print('🔍 Verificando replica set...');
    rs.status();
    print('📊 Verificando banco arcos-bridge...');
    use('arcos-bridge');
    db.runCommand({listCollections: 1});
    print('✅ Conexão bem-sucedida!');
" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Conexão MongoDB funcionando corretamente!"
else
    echo "❌ Erro na conexão MongoDB"
    echo "🔧 Verificações necessárias:"
    echo "   - Replica set rs0 está ativo?"
    echo "   - Usuário admin tem permissões?"
    echo "   - Banco arcos-bridge existe?"
fi

echo "🎯 Próximos passos:"
echo "   1. Se conexão OK: docker-compose up -d --build"
echo "   2. Monitorar logs: docker-compose logs -f connect"
echo "   3. Verificar conectores: curl http://localhost:8083/connectors" 