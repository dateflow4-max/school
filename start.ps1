# School Management Demo - Quick Start Script
# Run this script to set up and start the application

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  School Management System - Quick Start" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
Write-Host "Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Node.js not found"
    }
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "npm not found"
    }
    Write-Host "npm version: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: npm is not available!" -ForegroundColor Red
    Write-Host "Please reinstall Node.js from https://nodejs.org/" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Check if .env.local exists
if (-Not (Test-Path ".env.local")) {
    Write-Host "WARNING: .env.local file not found!" -ForegroundColor Yellow
    Write-Host "Creating from example..." -ForegroundColor Yellow
    Copy-Item ".env.local.example" ".env.local"
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Edit .env.local and add your Supabase credentials!" -ForegroundColor Red
    Write-Host "See SUPABASE_SETUP.md for instructions." -ForegroundColor Red
    Write-Host ""
}

# Check if node_modules exists
if (-Not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    Write-Host "This will take 2-5 minutes on first run..." -ForegroundColor Yellow
    Write-Host ""
    
    # Use --legacy-peer-deps to avoid conflicts
    npm install --legacy-peer-deps
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "ERROR: Failed to install dependencies!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Try manually:" -ForegroundColor Yellow
        Write-Host "  1. Delete node_modules folder (if it exists)" -ForegroundColor White
        Write-Host "  2. Run: npm install --legacy-peer-deps" -ForegroundColor White
        Write-Host "  3. Run: npm run dev" -ForegroundColor White
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "✅ Dependencies already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Starting Development Server..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The application will open at: http://localhost:3000" -ForegroundColor Green
Write-Host ""
Write-Host "📧 EMAIL-BASED LOGIN (Recommended):" -ForegroundColor Yellow
Write-Host "  Parent Portal:" -ForegroundColor White
Write-Host "    Email: parent1@demo.school" -ForegroundColor Cyan
Write-Host "    Password: parent123" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Staff Portal:" -ForegroundColor White
Write-Host "    Email: teacher@demo.school" -ForegroundColor Cyan
Write-Host "    Password: teacher123" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔑 CODE-BASED LOGIN (Legacy):" -ForegroundColor Yellow
Write-Host "    Parent Code: PAR2024001" -ForegroundColor White
Write-Host "    Student Code: STU2024001" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""

# Start the development server
npm run dev
