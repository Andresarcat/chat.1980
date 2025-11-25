# Script de setup para desarrollo nativo de Chatwoot
# Ejecutar: .\setup-dev.ps1

Write-Host "=== Chatwoot Development Setup ===" -ForegroundColor Green
Write-Host ""

# Verificar Ruby
Write-Host "1. Verificando Ruby..." -ForegroundColor Yellow
try {
    $rubyVersion = & ruby --version 2>&1
    Write-Host "   ✓ Ruby instalado: $rubyVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Ruby NO encontrado en PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "ACCIÓN REQUERIDA:" -ForegroundColor Yellow
    Write-Host "1. Cierra esta terminal PowerShell"
    Write-Host "2. Abre una NUEVA terminal PowerShell"
    Write-Host "3. Ejecuta este script de nuevo"
    Write-Host ""
    Write-Host "Si sigue sin funcionar, verifica que Ruby esté en PATH:"
    Write-Host "   - Busca 'Variables de entorno' en Windows"
    Write-Host "   - Agrega C:\RubyXX\bin al PATH (donde XX es la versión)"
    exit 1
}

# Verificar Node.js
Write-Host "2. Verificando Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = & node --version 2>&1
    Write-Host "   ✓ Node.js instalado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Node.js NO encontrado" -ForegroundColor Red
    Write-Host "   Descarga e instala desde: https://nodejs.org/"
    exit 1
}

# Verificar Docker
Write-Host "3. Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = & docker --version 2>&1
    Write-Host "   ✓ Docker instalado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker NO encontrado" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "4. Instalando Bundler..." -ForegroundColor Yellow
& gem install bundler
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Bundler instalado" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error instalando Bundler" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "5. Instalando dependencias Ruby (esto puede tomar varios minutos)..." -ForegroundColor Yellow
& bundle install
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Dependencias Ruby instaladas" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error instalando dependencias Ruby" -ForegroundColor Red
    Write-Host "   Revisa los errores arriba" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "6. Verificando pnpm..." -ForegroundColor Yellow
try {
    $pnpmVersion = & pnpm --version 2>&1
    Write-Host "   ✓ pnpm instalado: $pnpmVersion" -ForegroundColor Green
} catch {
    Write-Host "   Instalando pnpm..." -ForegroundColor Yellow
    & npm install -g pnpm
    Write-Host "   ✓ pnpm instalado" -ForegroundColor Green
}

Write-Host ""
Write-Host "7. Instalando dependencias Node.js (esto puede tomar varios minutos)..." -ForegroundColor Yellow
& pnpm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Dependencias Node.js instaladas" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error instalando dependencias Node.js" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "8. Iniciando servicios Docker (PostgreSQL, Redis, Mailhog)..." -ForegroundColor Yellow
& docker-compose -f docker-compose.dev.yaml up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Servicios Docker iniciados" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error iniciando servicios Docker" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "9. Esperando a que PostgreSQL esté listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "10. Creando base de datos..." -ForegroundColor Yellow
& bundle exec rails db:create
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Base de datos creada" -ForegroundColor Green
} else {
    Write-Host "   ⚠ La base de datos puede ya existir (esto es normal)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "11. Ejecutando migraciones..." -ForegroundColor Yellow
& bundle exec rails db:migrate
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Migraciones ejecutadas" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error en migraciones" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "✓ Setup completado exitosamente!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Crear cuenta Super Admin:" -ForegroundColor Cyan
Write-Host "   .\create-admin.ps1" -ForegroundColor White
Write-Host ""
Write-Host "2. Iniciar servidor de desarrollo:" -ForegroundColor Cyan
Write-Host "   .\start-dev.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Luego acceder a:" -ForegroundColor Yellow
Write-Host "   • Aplicación: http://localhost:3000" -ForegroundColor White
Write-Host "   • Mailhog: http://localhost:8025" -ForegroundColor White
Write-Host ""
