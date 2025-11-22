# Test Portfolio Backend API
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TESTING PORTFOLIO BACKEND API" -ForegroundColor Cyan
Write-Host "  Puerto: 5001" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "[1/5] Testing /health..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5001/health" -Method Get
    Write-Host "  OK - Status: $($health.status)" -ForegroundColor Green
} catch {
    Write-Host "  FAILED" -ForegroundColor Red
}
Write-Host ""

# Test 2: Sliders (public)
Write-Host "[2/5] Testing GET /api/sliders (public)..." -ForegroundColor Yellow
try {
    $sliders = Invoke-RestMethod -Uri "http://localhost:5001/api/sliders" -Method Get
    Write-Host "  OK - Found $($sliders.Count) sliders" -ForegroundColor Green
} catch {
    Write-Host "  FAILED" -ForegroundColor Red
}
Write-Host ""

# Test 3: Portfolio Projects (public)
Write-Host "[3/5] Testing GET /api/portfolio (public)..." -ForegroundColor Yellow
try {
    $projects = Invoke-RestMethod -Uri "http://localhost:5001/api/portfolio" -Method Get
    Write-Host "  OK - Found $($projects.Count) projects" -ForegroundColor Green
} catch {
    Write-Host "  FAILED" -ForegroundColor Red
}
Write-Host ""

# Test 4: Login
Write-Host "[4/5] Testing POST /api/auth/login..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@portfolio.com"
        password = "admin123"
    } | ConvertTo-Json

    $login = Invoke-RestMethod -Uri "http://localhost:5001/api/auth/login" -Method Post -Body $body -ContentType "application/json"
    $token = $login.token
    Write-Host "  OK - Logged in as: $($login.user.name)" -ForegroundColor Green

    # Test 5: Protected Endpoint
    Write-Host ""
    Write-Host "[5/5] Testing GET /api/contacts (protected)..." -ForegroundColor Yellow
    try {
        $headers = @{
            Authorization = "Bearer $token"
        }
        $contacts = Invoke-RestMethod -Uri "http://localhost:5001/api/contacts" -Method Get -Headers $headers
        Write-Host "  OK - Found $($contacts.Count) contacts" -ForegroundColor Green
    } catch {
        Write-Host "  FAILED" -ForegroundColor Red
    }

} catch {
    Write-Host "  FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ALL TESTS COMPLETED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
