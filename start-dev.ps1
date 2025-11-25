# Script para iniciar el servidor de desarrollo
# Ejecuta Rails, Vite y Sidekiq en ventanas separadas

Write-Host "=== Iniciando Servidor de Desarrollo ===" -ForegroundColor Green
Write-Host ""

# Verificar que servicios Docker estén corriendo
Write-Host "Verificando servicios Docker..." -ForegroundColor Yellow
$postgresRunning = docker ps --filter "name=postgres" --filter "status=running" -q
$redisRunning = docker ps --filter "name=redis" --filter "status=running" -q

if (-not $postgresRunning -or -not $redisRunning) {
    Write-Host "Iniciando servicios Docker..." -ForegroundColor Yellow
    docker-compose -f docker-compose.dev.yaml up -d
    Start-Sleep -Seconds 3
}

Write-Host "✓ Servicios Docker corriendo" -ForegroundColor Green
Write-Host ""

Write-Host "Iniciando servidores en ventanas separadas..." -ForegroundColor Yellow
Write-Host ""

# Iniciar Rails en nueva ventana
Write-Host "1. Iniciando Rails (puerto 3000)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; Write-Host '=== Rails Server ===' -ForegroundColor Green; bundle exec rails s -p 3000"

Start-Sleep -Seconds 2

# Iniciar Vite en nueva ventana
Write-Host "2. Iniciando Vite dev server (puerto 3036)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; Write-Host '=== Vite Dev Server ===' -ForegroundColor Green; bin/vite dev"

Start-Sleep -Seconds 2

# Iniciar Sidekiq en nueva ventana
Write-Host "3. Iniciando Sidekiq (workers)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; Write-Host '=== Sidekiq Workers ===' -ForegroundColor Green; bundle exec sidekiq -C config/sidekiq.yml"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "✓ Servidores iniciados!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Accede a la aplicación en:" -ForegroundColor Yellow
Write-Host "  • http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Otros servicios:" -ForegroundColor Yellow
Write-Host "  • Vite HMR: http://localhost:3036" -ForegroundColor White
Write-Host "  • Mailhog: http://localhost:8025" -ForegroundColor White
Write-Host ""
Write-Host "NOTA: Hot-reload (HMR) está activo!" -ForegroundColor Green
Write-Host "Los cambios en archivos .vue, .js y .css se reflejarán automáticamente" -ForegroundColor Green
Write-Host ""
Write-Host "Para detener todos los servicios:" -ForegroundColor Yellow
Write-Host "  - Cierra las ventanas de PowerShell de Rails/Vite/Sidekiq" -ForegroundColor White
Write-Host "  - Ejecuta: docker-compose -f docker-compose.dev.yaml down" -ForegroundColor White
Write-Host ""
