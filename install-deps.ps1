# Simple Dependency Installation Script
# Run this if start.ps1 fails to install dependencies

Write-Host "Installing dependencies for School Management System..." -ForegroundColor Cyan
Write-Host ""

# Remove existing node_modules if corrupted
if (Test-Path "node_modules") {
    Write-Host "Removing existing node_modules..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force node_modules
}

# Remove package-lock if exists
if (Test-Path "package-lock.json") {
    Write-Host "Removing package-lock.json..." -ForegroundColor Yellow
    Remove-Item package-lock.json
}

Write-Host ""
Write-Host "Installing packages (this may take 3-5 minutes)..." -ForegroundColor Yellow
Write-Host ""

# Install with legacy peer deps to avoid conflicts
npm install --legacy-peer-deps --verbose

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ SUCCESS! Dependencies installed." -ForegroundColor Green
    Write-Host ""
    Write-Host "Now run: npm run dev" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Installation failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try these steps:" -ForegroundColor Yellow
    Write-Host "1. Make sure you have Node.js 18+ installed" -ForegroundColor White
    Write-Host "2. Close and reopen PowerShell as Administrator" -ForegroundColor White
    Write-Host "3. Run: npm cache clean --force" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
}

Write-Host ""
Read-Host "Press Enter to exit"
