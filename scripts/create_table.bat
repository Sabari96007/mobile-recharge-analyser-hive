@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Creating Hive Database and Table via Beeline
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

:: 1. Verify container is running
docker ps --filter "name=hive-server" --filter "status=running" | findstr /i "hive-server" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Container "hive-server" is not running!
    echo Please start the project first by executing "scripts\start.bat".
    echo.
    pause
    exit /b 1
)

:: 2. Wait for HiveServer2 to be ready (port 10000)
echo Waiting for HiveServer2 to become ready on port 10000...
set MAX_RETRIES=20
set RETRY_COUNT=0

:check_hive
set /a RETRY_COUNT+=1
echo [Attempt !RETRY_COUNT!/%MAX_RETRIES%] Checking HiveServer2 connection...
docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -e "SHOW DATABASES;" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] HiveServer2 is ready and accepting Beeline connections!
    goto hive_ready
)

if !RETRY_COUNT! geq %MAX_RETRIES% (
    echo.
    echo [ERROR] HiveServer2 did not become ready in time.
    echo Please check container logs using:
    echo   docker logs hive-server
    echo.
    pause
    exit /b 1
)

echo HiveServer2 is still initializing schema... waiting 6 seconds...
timeout /t 6 /nobreak >nul
goto check_hive

:hive_ready
echo.
echo Executing init.hql to create database and table...
echo -------------------------------------------------------------------------------
docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -f /opt/hive/scripts/init.hql

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to execute init.hql via Beeline.
    pause
    exit /b 1
)

echo.
echo ===============================================================================
echo [SUCCESS] Database "mobile_recharge_db" and Table "mobile_recharge" created!
echo ===============================================================================
echo.
echo Next Step:
echo   Run "scripts\load_data.bat" to load the CSV dataset into Hive.
echo.
pause
