@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Loading CSV Dataset into Hive Table
echo ===============================================================================
echo.

:: Navigate to project root directory
cd /d "%~dp0\.."

:: 1. Check if CSV file exists locally
if not exist "data\mobile_recharge.csv" (
    echo [ERROR] Dataset file "data\mobile_recharge.csv" not found!
    echo Please make sure mobile_recharge.csv exists in the data directory.
    pause
    exit /b 1
)

:: 2. Check if container is running
docker ps --filter "name=hive-server" --filter "status=running" | findstr /i "hive-server" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Container "hive-server" is not running!
    echo Please start the project first by executing "scripts\start.bat".
    pause
    exit /b 1
)

:: 3. Copy CSV into container /tmp directory for reliable local load
echo [1/3] Copying mobile_recharge.csv into hive-server container...
docker cp data\mobile_recharge.csv hive-server:/tmp/mobile_recharge.csv
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy CSV file into container.
    pause
    exit /b 1
)
echo [OK] File copied to /tmp/mobile_recharge.csv inside container.

:: 4. Load data into Hive table via Beeline
echo.
echo [2/3] Loading data into table "mobile_recharge_db.mobile_recharge"...
docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -e "USE mobile_recharge_db; LOAD DATA LOCAL INPATH '/tmp/mobile_recharge.csv' OVERWRITE INTO TABLE mobile_recharge;"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to load data into Hive table.
    pause
    exit /b 1
)

:: 5. Verify loaded records
echo.
echo [3/3] Verifying loaded records in Hive:
echo -------------------------------------------------------------------------------
docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -e "USE mobile_recharge_db; SELECT COUNT(*) AS total_loaded_records FROM mobile_recharge; SELECT * FROM mobile_recharge LIMIT 5;"

echo.
echo ===============================================================================
echo [SUCCESS] Mobile recharge dataset loaded successfully into Apache Hive!
echo ===============================================================================
echo.
echo Next Step:
echo   Run "scripts\run_analysis.bat" to execute all 20 HiveQL analysis queries.
echo.
pause
