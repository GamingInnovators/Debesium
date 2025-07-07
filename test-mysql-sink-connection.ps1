# Script PowerShell para testar conexão MySQL Sink (destino)

Write-Host "🔍 Testando conexão MySQL Sink (destino)..." -ForegroundColor Cyan

# Teste de conectividade básica
Write-Host "📡 Testando conectividade de rede (porta 3396)..." -ForegroundColor Yellow
try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect("195.200.6.202", 3396)
    $tcpClient.Close()
    Write-Host "✅ Porta 3396 está acessível" -ForegroundColor Green
} catch {
    Write-Host "❌ Porta 3396 não está acessível" -ForegroundColor Red
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Teste usando Docker MySQL client
Write-Host "🔐 Testando autenticação no banco arcos_db..." -ForegroundColor Yellow
$mysqlCommand = @"
SELECT 'MySQL Sink Connection Test' AS message;
SHOW DATABASES;
USE arcos_db;
SHOW TABLES;
SELECT '✅ Conexão Sink bem-sucedida!' AS status;
"@

try {
    $result = docker run --rm mysql:8.0 mysql -h195.200.6.202 -P3396 -uarcos_db -p"N7#vP9k$zL1@qXr!5TfG" -e $mysqlCommand 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conexão MySQL Sink funcionando corretamente!" -ForegroundColor Green
        Write-Host $result -ForegroundColor White
    } else {
        Write-Host "❌ Erro na conexão MySQL Sink" -ForegroundColor Red
        Write-Host "🔧 Verificações necessárias:" -ForegroundColor Yellow
        Write-Host "   - Servidor MySQL está ativo na porta 3396?" -ForegroundColor White
        Write-Host "   - Usuário arcos_db tem permissões?" -ForegroundColor White
        Write-Host "   - Banco arcos_db existe?" -ForegroundColor White
        Write-Host "   - Senha está correta?" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erro ao executar teste: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎯 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Se conexão OK: pipeline Source → Sink funcionará" -ForegroundColor White
Write-Host "   2. Verificar se ambos MySQL estão funcionando" -ForegroundColor White
Write-Host "   3. Executar: docker-compose up -d --build" -ForegroundColor White 