@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Starting Project Containers [Docker Compose]
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

:: 1. Check if Docker is installed and running
echo [1/4] Checking Docker status...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker is not running or Docker Desktop is not started!
    echo.
    echo Solution:
    echo   1. Open "Docker Desktop" from your Windows Start Menu.
    echo   2. Wait until Docker Desktop displays "Engine running" in green.
    echo   3. Re-run this start.bat script.
    echo.
    pause
    exit /b 1
)
echo [OK] Docker daemon is running.

:: 2. Ensure PostgreSQL JDBC driver is present
echo.
echo [2/4] Verifying PostgreSQL JDBC driver...
if not exist "lib\postgresql-42.7.3.jar" (
    echo Downloading PostgreSQL JDBC Driver jar into lib...
    if not exist "lib" mkdir "lib"
    powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar' -OutFile 'lib\postgresql-42.7.3.jar'"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to download postgresql-42.7.3.jar. Check your internet connection.
        pause
        exit /b 1
    )
    echo [OK] Driver downloaded successfully.
) else (
    echo [OK] PostgreSQL JDBC Driver found: lib\postgresql-42.7.3.jar
)

:: 3. Start containers using docker compose up -d
echo.
echo [3/4] Launching PostgreSQL and Apache Hive containers...
docker compose up -d
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] "docker compose up -d" failed.
    echo Check the error message above or see README.md for troubleshooting.
    pause
    exit /b 1
)

:: 4. Display container status
echo.
echo [4/4] Current container status:
echo -------------------------------------------------------------------------------
docker ps --filter "name=hive-"
echo -------------------------------------------------------------------------------
echo.
echo [SUCCESS] Containers started!
echo.
echo NOTE: HiveServer2 takes approximately 30-60 seconds to initialize the Metastore
echo       schema in PostgreSQL on its very first run.
echo.
echo Next Steps:
echo   1. Wait 30 seconds for HiveServer2 to be fully ready.
echo   2. Run "scripts\create_table.bat" to create the database and table.
echo   3. Run "scripts\load_data.bat" to load the dataset.
echo   4. Run "scripts\run_analysis.bat" to execute analysis queries.
echo.
pause
