@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Stopping Project Containers
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

echo Stopping Apache Hive and PostgreSQL containers...
docker compose stop

if %errorlevel% equ 0 (
    echo.
    echo [OK] Containers stopped successfully.
    echo.
    echo Container status:
    docker ps -a --filter "name=hive-"
    echo.
    echo To restart later, run "scripts\start.bat".
) else (
    echo.
    echo [ERROR] Failed to stop containers cleanly.
)

echo.
pause
