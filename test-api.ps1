# Test Portfolio Backend API

Write-Host "`n╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🧪 TESTING PORTFOLIO BACKEND API - PORT 5001  ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Test Health Check
Write-Host "1. Testing /health endpoint..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5001/health" -Method Get
    Write-Host "✅ Health Check: OK" -ForegroundColor Green
    Write-Host "   Status: $($health.status)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "❌ Health Check: FAILED" -ForegroundColor Red
    Write-Host ""
}

# Test Sliders (public)
Write-Host "2. Testing GET /api/sliders (public)..." -ForegroundColor Yellow
try {
    $sliders = Invoke-RestMethod -Uri "http://localhost:5001/api/sliders" -Method Get
    Write-Host "✅ Sliders: OK ($($sliders.Count) sliders)" -ForegroundColor Green
    $sliders | ForEach-Object { Write-Host "   - $($_.title)" -ForegroundColor Gray }
    Write-Host ""
} catch {
    Write-Host "❌ Sliders: FAILED" -ForegroundColor Red
    Write-Host ""
}

# Test Portfolio Projects (public)
Write-Host "3. Testing GET /api/portfolio (public)..." -ForegroundColor Yellow
try {
    $projects = Invoke-RestMethod -Uri "http://localhost:5001/api/portfolio" -Method Get
    Write-Host "✅ Portfolio Projects: OK ($($projects.Count) projects)" -ForegroundColor Green
    $projects | ForEach-Object { Write-Host "   - $($_.title)" -ForegroundColor Gray }
    Write-Host ""
} catch {
    Write-Host "❌ Portfolio Projects: FAILED" -ForegroundColor Red
    Write-Host ""
}

# Test Login
Write-Host "4. Testing POST /api/auth/login..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@portfolio.com"
        password = "admin123"
    } | ConvertTo-Json

    $login = Invoke-RestMethod -Uri "http://localhost:5001/api/auth/login" -Method Post -Body $body -ContentType "application/json"
    $token = $login.token
    Write-Host "✅ Login: OK" -ForegroundColor Green
    Write-Host "   User: $($login.user.name) ($($login.user.email))" -ForegroundColor Gray
    Write-Host "   Token: $($token.Substring(0, 20))..." -ForegroundColor Gray
    Write-Host ""

    # Test Protected Endpoint
    Write-Host "5. Testing GET /api/contacts (protected)..." -ForegroundColor Yellow
    try {
        $headers = @{
            Authorization = "Bearer $token"
        }
        $contacts = Invoke-RestMethod -Uri "http://localhost:5001/api/contacts" -Method Get -Headers $headers
        Write-Host "✅ Contacts: OK ($($contacts.Count) contacts)" -ForegroundColor Green
        $contacts | ForEach-Object { Write-Host "   - $($_.name) ($($_.email))" -ForegroundColor Gray }
        Write-Host ""
    } catch {
        Write-Host "❌ Contacts: FAILED" -ForegroundColor Red
        Write-Host ""
    }

} catch {
    Write-Host "❌ Login: FAILED" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Write-Host "🎉 API Testing Complete!" -ForegroundColor Cyan
