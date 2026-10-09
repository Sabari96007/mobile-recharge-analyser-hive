@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Executing 20 HiveQL Analysis Queries
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

:: 1. Verify container is running
docker ps --filter "name=hive-server" --filter "status=running" | findstr /i "hive-server" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Container "hive-server" is not running!
    echo Please start the project first by executing "scripts\start.bat".
    pause
    exit /b 1
)

:: 2. Ensure analysis script is in container
docker cp hive\analysis_queries.hql hive-server:/tmp/analysis_queries.hql >nul 2>&1

echo Executing all 20 HiveQL queries via Beeline...
echo Please wait, Hive is processing the analytical queries...
echo -------------------------------------------------------------------------------
echo.

docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" --silent=false -f /tmp/analysis_queries.hql

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Error occurred while running HiveQL analysis queries.
    pause
    exit /b 1
)

echo.
echo ===============================================================================
echo [SUCCESS] All 20 HiveQL Analysis Queries executed successfully!
echo ===============================================================================
echo.
pause
