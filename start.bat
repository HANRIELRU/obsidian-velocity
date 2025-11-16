@echo off
chcp 65001 >nul
title Velocity Proxy Starter

:: Конфигурация
set SERVER_JAR=velocity.jar
set JAVA_MEMORY=-Xms512M -Xmx1G
set JAVA_OPTS=-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch
set VELOCITY_VERSION=3.4.0
set VELOCITY_BUILD=557

echo 🚀 Starting Velocity Proxy...
echo ==========================================

:: Проверяем Java
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Java is not installed or not in PATH
    echo Please install Java 17 or higher
    echo Download from: https://adoptium.net/
    pause
    exit /b 1
)

for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVA_VER=%%i
)

set JAVA_VER=%JAVA_VER:"=%
for /f "tokens=1,2 delims=." %%a in ("%JAVA_VER%") do (
    set MAJOR=%%a
    set MINOR=%%b
)

set MAJOR=%MAJOR:~-2%
if %MAJOR% LSS 17 (
    echo ❌ Java version %JAVA_VER% is too old. Velocity requires Java 17 or higher.
    pause
    exit /b 1
)

echo ✅ Java %JAVA_VER% detected

if not exist "%SERVER_JAR%" (
    echo 📥 Downloading Velocity %VELOCITY_VERSION% (build %VELOCITY_BUILD%)...
    powershell -Command "Invoke-WebRequest -Uri 'https://api.papermc.io/v2/projects/velocity/versions/%VELOCITY_VERSION%/builds/%VELOCITY_BUILD%/downloads/velocity-%VELOCITY_VERSION%-%VELOCITY_BUILD%.jar' -OutFile '%SERVER_JAR%'"
    if errorlevel 1 (
        echo ❌ Failed to download Velocity
        pause
        exit /b 1
    )
    echo ✅ Velocity downloaded successfully
) else (
    echo ✅ Velocity JAR found
)

echo 🎯 Starting Velocity with %JAVA_MEMORY%
echo 📝 Logs: logs\latest.log
echo 🛑 Stop with: Ctrl+C
echo ==========================================

:: Запускаем Velocity
java %JAVA_MEMORY% %JAVA_OPTS% -jar "%SERVER_JAR%"

if errorlevel 1 (
    echo.
    echo ❌ Velocity crashed. Check logs for details.
    pause
)