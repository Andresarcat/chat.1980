# Comandos para continuar después de bundle install

## Estado Actual ✓
- [x] Ruby 3.4.7 funcional con path completo
- [x] Bundler instalado
- [x] pnpm instalado  
- [x] Servicios Docker corriendo (PostgreSQL, Redis, Mailhog)
- [ ] bundle install ejecutándose... (puede tardar 10-15 min)

## Cuando bundle install termine, ejecutar:

### 1. Instalar dependencias Node.js
```powershell
pnpm install
```
Tiempo estimado: 3-5 minutos

### 2. Crear base de datos
```powershell
C:\Ruby34-x64\bin\bundle.bat exec rails db:create
```

### 3. Ejecutar migraciones
```powershell
C:\Ruby34-x64\bin\bundle.bat exec rails db:migrate
```

### 4. Crear cuenta Super Admin

Opción A - Script interactivo:
```powershell
.\create-admin.ps1
```

Opción B - Manual con consola Rails:
```powershell
C:\Ruby34-x64\bin\bundle.bat exec rails console
```

Luego dentro de la consola:
```ruby
account = Account.create!(name: 'Mi Empresa')
user = User.create!(
  email: 'admin@miempresa.com',
  password: 'TuPasswordSeguro123!',
  password_confirmation: 'TuPasswordSeguro123!',
  name: 'Super Admin',
  account: account,
  role: :administrator
)
AgentBot.create_default(account: account)
puts "✓ Cuenta creada: #{user.email}"
exit
```

### 5. Iniciar servidores de desarrollo

Terminal 1 - Rails:
```powershell
C:\Ruby34-x64\bin\bundle.bat exec rails s -p 3000
```

Terminal 2 - Vite (HMR):
```powershell
C:\Ruby34-x64\bin\bundle.bat exec vite dev
```

Terminal 3 - Sidekiq:
```powershell
C:\Ruby34-x64\bin\bundle.bat exec sidekiq -C config/sidekiq.yml
```

### 6. Acceder a la aplicación
- http://localhost:3000
- Login con las credenciales creadas
- Click en avatar → "Super Admin"
- Settings → Custom Branding

## Servicios Docker (ya corriendo)
```powershell
# Ver estado
docker ps

# Ver logs si hay problemas
docker-compose -f docker-compose.dev.yaml logs

# Reiniciar si es necesario
docker-compose -f docker-compose.dev.yaml restart
```

## Solución de Problemas

### Si bundle install falla
- Verifica que tienes MSYS2 DevKit instalado (viene con RubyInstaller)
- Puede ser necesario instalar Visual Studio Build Tools

### Si Rails no encuentra pg (PostgreSQL)
```powershell
# Verificar que PostgreSQL está corriendo
docker ps | findstr postgres

# Si no está, iniciarlo
docker-compose -f docker-compose.dev.yaml up -d postgres
```

### Si hay error de conexión a Redis
```powershell
# Verificar password en .env coincide con docker-compose.dev.yaml
# REDIS_PASSWORD debe ser: chatwoot_redis_pass_2024
```
