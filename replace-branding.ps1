# Script de Reemplazo de Textos: Chatwoot → 1080 TIC
# Este script reemplaza todas las referencias a "Chatwoot" con "1080 TIC"

Write-Host "=== Reemplazo de Marca: Chatwoot → 1080 TIC ===" -ForegroundColor Cyan
Write-Host ""

$replacements = @{
    'Chatwoot' = '1080 TIC'
    'chatwoot' = '1080tic'
    'CHATWOOT' = '1080TIC'
}

# Lista de archivos/directorios a modificar
$targetPaths = @(
    'app/views/**/*.erb',
    'app/javascript/dashboard/**/*.vue',
    'app/javascript/widget/**/*.vue',
    'app/mailers/**/*.rb',
    'config/initializers/devise.rb',
    'app/javascript/dashboard/i18n/**/*.js'
)

$modifiedFiles = @()
$totalReplacements = 0

foreach ($pattern in $targetPaths) {
    Write-Host "Procesando: $pattern" -ForegroundColor Yellow
   
    $files = Get-ChildItem -Path $pattern -Recurse -ErrorAction SilentlyContinue
   
    foreach ($file in $files) {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
       
        if ($null -eq $content) { continue }
       
        $originalContent = $content
        $fileModified = $false
       
        foreach ($old in $replacements.Keys) {
            $new = $replacements[$old]
            if ($content -cmatch $old) {
                $content = $content -creplace $old, $new
                $fileModified = $true
                $count = ([regex]::Matches($originalContent, [regex]::Escape($old))).Count
                $totalReplacements += $count
                Write-Host "  ✓ Reemplazado '$old' → '$new' ($count veces) en: $($file.Name)" -ForegroundColor Green
            }
        }
       
        if ($fileModified) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $modifiedFiles += $file.FullName
        }
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "Resumen de Cambios:" -ForegroundColor Green
Write-Host "  Archivos modificados: $($modifiedFiles.Count)" -ForegroundColor White
Write-Host "  Total de reemplazos: $totalReplacements" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Guardar lista de archivos modificados
$modifiedFiles | Out-File -FilePath "modified_files_log.txt"
Write-Host "Lista de archivos modificados guardada en: modified_files_log.txt" -ForegroundColor Cyan

Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Yellow
Write-Host "- Revisa los cambios antes de hacer commit" -ForegroundColor White
Write-Host "- Testea la aplicación para asegurar que todo funciona" -ForegroundColor White
Write-Host "- Algunos archivos de configuración pueden requerir ajustes manuales" -ForegroundColor White
