@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Clean Up Project Containers and Volumes
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

echo WARNING: This will stop and remove:
echo   1. Container: hive-server
echo   2. Container: hive-postgres
echo   3. Volume:    hive-warehouse-data
echo   4. Volume:    hive-postgres-data
echo   5. Network:   hive-network
echo.
set /p CONFIRM="Are you sure you want to clean up all containers and volumes? (Y/N): "
if /i not "!CONFIRM!"=="Y" (
    echo [INFO] Cleanup cancelled by user.
    pause
    exit /b 0
)

echo.
echo Stopping and removing containers, networks, and volumes...
docker compose down -v

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Project environment cleaned up completely.
) else (
    echo.
    echo [ERROR] Encountered an issue during cleanup.
)

echo.
pause
