# Script para crear cuenta Super Admin
Write-Host "=== Creando Cuenta Super Admin ===" -ForegroundColor Green
Write-Host ""

$email = Read-Host "Email del Super Admin"
$nombre = Read-Host "Nombre completo"
$empresa = Read-Host "Nombre de la empresa"
$password = Read-Host "Password (mínimo 8 caracteres)" -AsSecureString

# Convertir SecureString a texto plano para el script Ruby
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "Creando cuenta..." -ForegroundColor Yellow

$rubyScript = @"
account = Account.create!(name: '$empresa')
user = User.create!(
  email: '$email',
  password: '$plainPassword',
  password_confirmation: '$plainPassword',
  name: '$nombre',
  account: account,
  role: :administrator
)
AgentBot.create_default(account: account)
puts ''
puts '✓ Cuenta creada exitosamente!'
puts ''
puts 'Detalles:'
puts '  Email: ' + user.email
puts '  Nombre: ' + user.name
puts '  Empresa: ' + account.name
puts ''
puts 'Ahora puedes iniciar sesión en http://localhost:3000'
"@

$rubyScript | & bundle exec rails console

Write-Host ""
Write-Host "Presiona Enter para continuar..."
Read-Host
