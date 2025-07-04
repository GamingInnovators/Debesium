# Script PowerShell para testar conexão MongoDB com replica set

Write-Host "🔍 Testando conexão MongoDB com replica set..." -ForegroundColor Cyan

# Teste de conectividade básica
Write-Host "📡 Testando conectividade de rede..." -ForegroundColor Yellow
try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect("195.200.6.202", 27032)
    $tcpClient.Close()
    Write-Host "✅ Porta 27032 está acessível" -ForegroundColor Green
} catch {
    Write-Host "❌ Porta 27032 não está acessível" -ForegroundColor Red
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Teste usando Docker MongoDB
Write-Host "🔐 Testando autenticação..." -ForegroundColor Yellow
$mongoCommand = @"
print('🔍 Verificando replica set...');
rs.status();
print('📊 Verificando banco arcos-bridge...');
use('arcos-bridge');
db.runCommand({listCollections: 1});
print('✅ Conexão bem-sucedida!');
"@

try {
    $result = docker run --rm mongo:6 mongosh "mongodb://admin:admin123@195.200.6.202:27032/admin?authSource=admin&replicaSet=rs0" --eval $mongoCommand 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conexão MongoDB funcionando corretamente!" -ForegroundColor Green
        Write-Host $result -ForegroundColor White
    } else {
        Write-Host "❌ Erro na conexão MongoDB" -ForegroundColor Red
        Write-Host "🔧 Verificações necessárias:" -ForegroundColor Yellow
        Write-Host "   - Replica set rs0 está ativo?" -ForegroundColor White
        Write-Host "   - Usuário admin tem permissões?" -ForegroundColor White
        Write-Host "   - Banco arcos-bridge existe?" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erro ao executar teste: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎯 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Se conexão OK: docker-compose up -d --build" -ForegroundColor White
Write-Host "   2. Monitorar logs: docker-compose logs -f connect" -ForegroundColor White
Write-Host "   3. Verificar conectores: curl http://localhost:8083/connectors" -ForegroundColor White 