# Script PowerShell para testar conexão MySQL

Write-Host "🔍 Testando conexão MySQL..." -ForegroundColor Cyan

# Teste de conectividade básica
Write-Host "📡 Testando conectividade de rede..." -ForegroundColor Yellow
try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect("195.200.6.202", 3310)
    $tcpClient.Close()
    Write-Host "✅ Porta 3310 está acessível" -ForegroundColor Green
} catch {
    Write-Host "❌ Porta 3310 não está acessível" -ForegroundColor Red
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Teste usando Docker MySQL client
Write-Host "🔐 Testando autenticação..." -ForegroundColor Yellow
$mysqlCommand = @"
SELECT 'MySQL Connection Test' AS message;
SHOW DATABASES;
USE ArcosbridgeSQL;
SHOW TABLES;
SELECT '✅ Conexão bem-sucedida!' AS status;
"@

try {
    $result = docker run --rm mysql:8.0 mysql -h195.200.6.202 -P3310 -uroot -p"6x{u!bl}N2x46W7@@@" -e $mysqlCommand 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conexão MySQL funcionando corretamente!" -ForegroundColor Green
        Write-Host $result -ForegroundColor White
    } else {
        Write-Host "❌ Erro na conexão MySQL" -ForegroundColor Red
        Write-Host "🔧 Verificações necessárias:" -ForegroundColor Yellow
        Write-Host "   - Servidor MySQL está ativo na porta 3310?" -ForegroundColor White
        Write-Host "   - Usuário root tem permissões?" -ForegroundColor White
        Write-Host "   - Banco ArcosbridgeSQL existe?" -ForegroundColor White
        Write-Host "   - Senha está correta?" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erro ao executar teste: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎯 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Se conexão OK: docker-compose up -d --build" -ForegroundColor White
Write-Host "   2. Monitorar logs: docker-compose logs -f connect" -ForegroundColor White
Write-Host "   3. Verificar conectores: curl http://localhost:8083/connectors" -ForegroundColor White 