@echo off
echo 🛑 Stopping Velocity Proxy...

tasklist /fi "imagename eq java.exe" /fo csv | findstr /i "velocity" >nul
if errorlevel 1 (
    echo ✅ Velocity is not running
    pause
    exit /b 0
)

echo 📝 Sending graceful shutdown...
taskkill /f /im java.exe >nul 2>&1

timeout /t 3 >nul
tasklist /fi "imagename eq java.exe" /fo csv | findstr /i "velocity" >nul
if errorlevel 1 (
    echo ✅ Velocity stopped successfully
) else (
    echo ❌ Failed to stop Velocity
)

pause