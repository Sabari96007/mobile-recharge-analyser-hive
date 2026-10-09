@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo   Mobile Recharge Data Analysis using Apache Hive
echo   Launching Interactive Beeline CLI
echo ===============================================================================
echo.
echo Connecting to HiveServer2 at jdbc:hive2://localhost:10000 ...
echo Type '!quit' to exit the Beeline session.
echo.

docker exec -it hive-server beeline -u "jdbc:hive2://localhost:10000/mobile_recharge_db" -n hive -p ""

pause
