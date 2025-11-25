# Script de Build: Imagen Docker 1080 TIC

Write-Host "=== Build de Imagen Docker - 1080 TIC ===" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Verificar archivos necesarios
Write-Host "1. Verificando archivos..." -ForegroundColor Yellow

$requiredFiles = @(
    "Dockerfile.1080tic",
    "docker-compose.1080tic.yaml",
    "theme/colors.js",
    "app/javascript/dashboard/assets/scss/_1080tic-gradients.scss"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $file NO ENCONTRADO" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Paso 2: Ejecutar script de reemplazo de textos
Write-Host "2. Ejecutando reemplazo de textos..." -ForegroundColor Yellow
if (Test-Path "replace-branding.ps1") {
    .\replace-branding.ps1
    Write-Host "   ✓ Textos reemplazados" -ForegroundColor Green
} else {
    Write-Host "   ⚠ replace-branding.ps1 no encontrado. Continuando..." -ForegroundColor Yellow
}

Write-Host ""

# Paso 3: Actualizar .env para producción
Write-Host "3. Configurando variables de entorno..." -ForegroundColor Yellow

$envContent = @"
# Configuración de producción 1080 TIC
RAILS_ENV=production
NODE_ENV=production
INSTALLATION_ENV=docker

# Rails debe servir archivos estáticos
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

# Brand configuration
INSTALLATION_NAME=1080 TIC
BRAND_NAME=1080 TIC

# Base de datos
POSTGRES_HOST=postgres
POSTGRES_DB=chatwoot_prod
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=chatwoot_db_pass_2024

# Redis
REDIS_URL=redis://redis:6379
REDIS_PASSWORD=chatwoot_redis_pass_2024

# Email (configurar según necesites)
MAILER_SENDER_EMAIL=1080 TIC <soporte@1080tic.com>
SMTP_DOMAIN=1080tic.com
SMTP_ADDRESS=
SMTP_PORT=587
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true

# Secret key (generar uno nuevo para producción)
SECRET_KEY_BASE=
"@

if (-not (Test-Path ".env")) {
    $envContent | Out-File -FilePath ".env"
    Write-Host "   ✓ Archivo .env creado" -ForegroundColor Green
    Write-Host "   ⚠ IMPORTANTE: Genera SECRET_KEY_BASE con: rails secret" -ForegroundColor Yellow
} else {
    Write-Host "   ℹ Archivo .env ya existe. Verifica las variables." -ForegroundColor Cyan
}

Write-Host ""

# Paso 4: Build de la imagen
Write-Host "4. Construyendo imagen Docker..." -ForegroundColor Yellow
Write-Host "   (Esto puede tardar 10-15 minutos)" -ForegroundColor Gray

$buildCommand = "docker build -f Dockerfile.1080tic -t 1080tic/chatwoot:latest -t 1080tic/chatwoot:v1.0.0 ."

try {
    Invoke-Expression $buildCommand
    Write-Host ""
    Write-Host "   ✓ Imagen construida exitosamente" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "   ✗ Error en build de imagen" -ForegroundColor Red
    Write-Host "   Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Paso 5: Verificar imagen
Write-Host "5. Verificando imagen creada..." -ForegroundColor Yellow
docker images | Select-String "1080tic/chatwoot"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "✓ Build completado!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Testear localmente:" -ForegroundColor Yellow
Write-Host "   docker-compose -f docker-compose.1080tic.yaml up -d" -ForegroundColor White
Write-Host ""
Write-Host "2. Crear base de datos (primera vez):" -ForegroundColor Yellow
Write-Host "   docker-compose -f docker-compose.1080tic.yaml exec rails bundle exec rails db:chatwoot_prepare" -ForegroundColor White
Write-Host ""
Write-Host "3. Crear Super Admin:" -ForegroundColor Yellow
Write-Host "   docker-compose -f docker-compose.1080tic.yaml exec rails bundle exec rails console" -ForegroundColor White
Write-Host ""
Write-Host "4. Acceder a la aplicación:" -ForegroundColor Yellow
Write-Host "   http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "5. Push a Docker Hub (opcional):" -ForegroundColor Yellow
Write-Host "   docker login" -ForegroundColor White
Write-Host "   docker push 1080tic/chatwoot:latest" -ForegroundColor White
Write-Host "   docker push 1080tic/chatwoot:v1.0.0" -ForegroundColor White
Write-Host ""
