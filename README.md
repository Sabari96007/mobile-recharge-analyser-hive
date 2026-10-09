# Mobile Recharge Data Analysis using Apache Hive

A complete, beginner-friendly Big Data mini-project designed to be executed and managed entirely from **Windows Command Prompt (CMD)** using **Docker Desktop**, **Docker Compose**, **Apache Hive 4.0.0**, and **PostgreSQL 15**.

No complex GUI installations (Jupyter Notebook, Hadoop Web UI, or Database GUI) are required. Everything runs reliably via automated Windows batch scripts and standard Command Prompt commands.

---

## Table of Contents
1. [Project Title & Overview](#1-project-title--overview)
2. [Project Objective](#2-project-objective)
3. [Problem Statement](#3-problem-statement)
4. [Technologies Used](#4-technologies-used)
5. [System Requirements](#5-system-requirements)
6. [Project Architecture](#6-project-architecture)
7. [Folder Structure](#7-folder-structure)
8. [Docker Installation & Setup](#8-docker-installation--setup)
9. [Docker Compose Configuration](#9-docker-compose-configuration)
10. [How to Start the Project](#10-how-to-start-the-project)
11. [How to Check Container Status](#11-how-to-check-container-status)
12. [How to Enter Hive via Beeline CLI](#12-how-to-enter-hive-via-beeline-cli)
13. [How to Create the Database](#13-how-to-create-the-database)
14. [How to Create the Hive Table](#14-how-to-create-the-hive-table)
15. [How to Load the CSV Dataset](#15-how-to-load-the-csv-dataset)
16. [How to Execute HiveQL Queries](#16-how-to-execute-hiveql-queries)
17. [All 20 HiveQL Analysis Queries & Expected Outputs](#17-all-20-hiveql-analysis-queries--expected-outputs)
18. [How to Stop the Project](#18-how-to-stop-the-project)
19. [Common Errors and Solutions](#19-common-errors-and-solutions)
20. [College Mini-Project Viva Questions & Answers](#20-college-mini-project-viva-questions--answers)

---

## 1. Project Title & Overview
**Project Title:** Mobile Recharge Data Analysis using Apache Hive  
**Domain:** Telecommunications & Big Data Analytics  
**Platform:** Windows 10/11 Command Prompt (CMD) with Docker Desktop  

This project simulates a telecom analytics platform (covering major Indian telecom operators like Jio, Airtel, Vi, and BSNL). It processes customer transaction records, tracks revenue and data usage patterns, identifies failed recharges, and determines high-value customers using Apache Hive's SQL-like query language (HiveQL).

---

## 2. Project Objective
1. **Data Ingestion:** Ingest structured CSV transaction records into an Apache Hive table backed by an HDFS-compatible storage architecture.
2. **Metastore Management:** Store Hive metadata (table schema, column types, file locations) in an external, production-ready PostgreSQL relational database.
3. **Data Analysis:** Execute 20 real-world analytical queries using HiveQL to extract actionable business insights.
4. **Command-Line Automation:** Provide plug-and-play `.bat` scripts so anyone with Windows CMD can set up, initialize, load, query, and clean the project without typing error-prone Docker commands manually.

---

## 3. Problem Statement
Telecom providers process millions of mobile recharge transactions every day through diverse digital channels (UPI, Net Banking, Debit/Credit Cards, Wallets). Telecom management requires fast answers to critical questions:
- Which telecom operator generates the highest recharge revenue?
- What is the failure rate across different payment methods?
- Which recharge plans (Daily Unlimited vs. Annual) are favored in different cities?
- Who are the highest-spending customers?

Relational databases face performance bottlenecks when scaling to massive distributed transaction logs. Apache Hive solves this by providing SQL-on-Hadoop abstractions, enabling large-scale batch analytics over structured data.

---

## 4. Technologies Used

| Technology | Version | Purpose in this Project |
| :--- | :--- | :--- |
| **Windows OS** | 10 or 11 | Host operating system and execution environment via CMD |
| **Docker Desktop** | 20.x+ | Container runtime platform on Windows |
| **Docker Compose** | 2.x+ | Multi-container orchestration tool |
| **Apache Hive** | 4.0.0 | Distributed data warehouse system for data summarization and querying |
| **PostgreSQL** | 15 | External persistent Hive Metastore database |
| **HiveServer2** | 4.0.0 | Thrift-based server service that processes queries from JDBC/ODBC clients |
| **Apache Beeline** | 4.0.0 | Command-line interface used to submit HiveQL queries over JDBC |
| **PostgreSQL JDBC** | 42.7.3 | Driver enabling Hive to communicate with PostgreSQL |
| **CSV Dataset** | RFC 4180 | Structured raw dataset containing 60 realistic recharge transactions |

---

## 5. System Requirements
- **Operating System:** Windows 10 (64-bit: Pro, Enterprise, or Education) or Windows 11 (Home, Pro).
- **Virtualization:** Hardware virtualization (VT-x/AMD-V) enabled in BIOS/UEFI.
- **RAM:** Minimum 8 GB (16 GB recommended for smooth Docker execution).
- **Disk Space:** Minimum 10 GB free space for Docker images and volumes.
- **Software:** Docker Desktop with WSL 2 backend enabled.

---

## 6. Project Architecture

The architecture flow of the project is illustrated below:

```text
                  +-----------------------------------+
                  |            Windows CMD            |
                  |     (Batch Scripts / Commands)    |
                  +-----------------------------------+
                                    |
                                    v
                  +-----------------------------------+
                  |           Docker Desktop          |
                  |          (Docker Compose)         |
                  +-----------------------------------+
                                    |
            +-----------------------+-----------------------+
            |                                               |
            v                                               v
+-----------------------+                       +-----------------------+
|  Container:           |   Metastore JDBC      |  Container:           |
|  hive-server          |---------------------->|  hive-postgres        |
|  (HiveServer2)        |   (Port 5432)         |  (PostgreSQL 15)      |
|  (Exposed: Port 10000)|                       |  (DB: metastore)      |
+-----------------------+                       +-----------------------+
            |
            v
+-----------------------+
|     Hive Database     |
|  (mobile_recharge_db) |
+-----------------------+
            |
            v
+-----------------------+
|      Hive Table       |
|    mobile_recharge    |
+-----------------------+
            |
            v
+-----------------------+
|    HiveQL Queries     |
|   (Executed Beeline)  |
+-----------------------+
            |
            v
+-----------------------+
|   Analysis Results    |
|   (Displayed in CMD)  |
+-----------------------+
```

---

## 7. Folder Structure

```text
mobile-recharge-hive/
│
├── docker-compose.yml              # Docker multi-service configuration
├── README.md                       # Complete documentation & project guide
│
├── data/
│   └── mobile_recharge.csv         # 60 realistic mobile recharge transactions
│
├── hive/
│   ├── init.hql                    # Database & table creation DDL script
│   └── analysis_queries.hql        # All 20 HiveQL analytical queries
│
├── lib/
│   └── postgresql-42.7.3.jar       # PostgreSQL JDBC driver for Hive Metastore
│
└── scripts/
    ├── start.bat                   # Checks Docker, starts containers & displays status
    ├── stop.bat                    # Stops containers cleanly
    ├── create_table.bat            # Waits for HiveServer2, creates DB & table
    ├── load_data.bat               # Copies CSV and loads data into Hive
    ├── run_analysis.bat            # Runs all 20 HiveQL queries with output
    ├── beeline_shell.bat           # Opens interactive Beeline CLI in Windows CMD
    └── clean.bat                   # Removes containers and volumes completely
```

---

## 8. Docker Installation & Setup

1. **Download Docker Desktop:**
   Download the installer from the official website: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/).
2. **Install with WSL 2:**
   During installation, ensure the option **"Use WSL 2 instead of Hyper-V"** is checked.
3. **Start Docker Desktop:**
   Launch Docker Desktop from the Start Menu. Wait until the status bar in the bottom left shows **"Engine running"** with a green icon.
4. **Verify from Windows CMD:**
   Open CMD (`Win + R`, type `cmd`, press Enter) and run:
   ```cmd
   docker --version
   docker compose version
   ```
   **Expected Output:**
   ```text
   Docker version 29.x.x, build ...
   Docker Compose version v2.x.x
   ```

---

## 9. Docker Compose Configuration
The [`docker-compose.yml`](file:///c:/Moblie%20recharge%20analyser/mobile-recharge-hive/docker-compose.yml) file sets up two interconnected services:
1. `hive-postgres`: PostgreSQL 15 database instance storing the Hive Metastore catalog.
2. `hive-server`: Apache Hive 4.0.0 running HiveServer2, equipped with the PostgreSQL JDBC driver and persistent warehouse volume.

---

## 10. How to Start the Project

### Option A: Using the Automated Batch Script (Recommended)
1. Open Windows CMD.
2. Navigate to the project directory:
   ```cmd
   cd "C:\Moblie recharge analyser\mobile-recharge-hive"
   ```
3. Run the start script:
   ```cmd
   scripts\start.bat
   ```

### Option B: Using Direct CMD Commands
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker compose up -d
```

**Expected Output:**
```text
[+] Running 3/3
 ✔ Network hive-network         Created
 ✔ Container hive-postgres      Healthy
 ✔ Container hive-server        Started
```

> **Note for First Launch:** Apache Hive initializes its Metastore schema inside PostgreSQL on the first run. Allow **30 to 45 seconds** before running queries.

---

## 11. How to Check Container Status

**Where to execute:** Windows CMD  
**Command:**
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker ps
```

**Expected Output:**
```text
CONTAINER ID   IMAGE               COMMAND                  STATUS                    PORTS                                            NAMES
b8f3e21a49c1   apache/hive:4.0.0   "sh -c /entrypoint.sh"   Up 1 minute               0.0.0.0:10000->10000/tcp, 0.0.0.0:10002->10002   hive-server
f91a27e38cb2   postgres:15         "docker-entrypoint.s…"   Up 1 minute (healthy)     0.0.0.0:5432->5432/tcp                           hive-postgres
```

---

## 12. How to Enter Hive via Beeline CLI

To enter the interactive HiveQL prompt directly from Windows CMD:

### Option A: Using the Script
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> scripts\beeline_shell.bat
```

### Option B: Using Direct Docker CMD Command
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker exec -it hive-server beeline -u "jdbc:hive2://localhost:10000/mobile_recharge_db" -n hive -p ""
```

**What it does:** Connects Apache Beeline to HiveServer2 via JDBC protocol over port 10000.  
**Beeline Prompt:**
```text
Connected to: Apache Hive (version 4.0.0)
Driver: Hive JDBC (version 4.0.0)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 4.0.0 by Apache Hive
0: jdbc:hive2://localhost:10000/mobile_rechar> 
```
*To exit Beeline, type `!quit` and press Enter.*

---

## 13. How to Create the Database & 14. How to Create the Hive Table

### Option A: Using the Automated Script
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> scripts\create_table.bat
```

### Option B: Using Direct CMD Command
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -f /opt/hive/scripts/init.hql
```

### HiveQL Code Executed:
```sql
CREATE DATABASE IF NOT EXISTS mobile_recharge_db;

USE mobile_recharge_db;

CREATE EXTERNAL TABLE IF NOT EXISTS mobile_recharge (
    recharge_id INT COMMENT 'Unique Recharge Transaction Identifier',
    customer_id INT COMMENT 'Customer Identifier',
    customer_name STRING COMMENT 'Customer Full Name',
    mobile_number STRING COMMENT '10-digit Mobile Number',
    operator STRING COMMENT 'Telecom Operator (Jio, Airtel, Vi, BSNL)',
    plan_type STRING COMMENT 'Recharge Plan Category',
    recharge_amount DECIMAL(10,2) COMMENT 'Transaction Amount in INR',
    data_gb DECIMAL(5,2) COMMENT 'Data Quota in GB',
    validity_days INT COMMENT 'Validity Period in Days',
    recharge_date DATE COMMENT 'Date of Transaction (YYYY-MM-DD)',
    payment_method STRING COMMENT 'Payment Mode (UPI, Card, Wallet)',
    location STRING COMMENT 'City / Telecom Circle',
    status STRING COMMENT 'Status (Success, Failed, Pending)'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/opt/hive/data/warehouse/mobile_recharge_db.db/mobile_recharge'
TBLPROPERTIES ("skip.header.line.count"="1");
```

**Expected Output:**
```text
+-------------------+
|     tab_name      |
+-------------------+
| mobile_recharge   |
+-------------------+
1 row selected
```

---

## 15. How to Load the CSV Dataset

### Option A: Using the Automated Script
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> scripts\load_data.bat
```

### Option B: Using Direct CMD Commands
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker cp data\mobile_recharge.csv hive-server:/tmp/mobile_recharge.csv
C:\Moblie recharge analyser\mobile-recharge-hive> docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -e "USE mobile_recharge_db; LOAD DATA LOCAL INPATH '/tmp/mobile_recharge.csv' OVERWRITE INTO TABLE mobile_recharge;"
```

**Verification Command:**
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000" -e "USE mobile_recharge_db; SELECT COUNT(*) FROM mobile_recharge;"
```

**Expected Output:**
```text
+------+
| _c0  |
+------+
| 60   |
+------+
1 row selected
```

---

## 16. How to Execute HiveQL Queries

You can execute queries in two ways:
1. **Run All Queries Automatically:**
   ```cmd
   C:\Moblie recharge analyser\mobile-recharge-hive> scripts\run_analysis.bat
   ```
2. **Execute Single Query via Beeline Command:**
   ```cmd
   C:\Moblie recharge analyser\mobile-recharge-hive> docker exec -i hive-server beeline -u "jdbc:hive2://localhost:10000/mobile_recharge_db" -e "SELECT operator, COUNT(*) FROM mobile_recharge GROUP BY operator;"
   ```

---

## 17. All 20 HiveQL Analysis Queries & Expected Outputs

### Query 1: Display all recharge records (Preview)
```sql
SELECT recharge_id, customer_name, mobile_number, operator, recharge_amount, status
FROM mobile_recharge
LIMIT 5;
```
**Expected Output:**
```text
+--------------+----------------+----------------+-----------+------------------+----------+
| recharge_id  | customer_name  | mobile_number  | operator  | recharge_amount  |  status  |
+--------------+----------------+----------------+-----------+------------------+----------+
| 1001         | Aarav Sharma   | 9820114521     | Jio       | 239.00           | Success  |
| 1002         | Priya Patel    | 9811023847     | Airtel    | 299.00           | Success  |
| 1003         | Rohit Verma    | 9845039281     | Vi        | 19.00            | Success  |
| 1004         | Ananya Iyer    | 9840149201     | BSNL      | 147.00           | Success  |
| 1005         | Vikram Singh   | 9830159384     | Jio       | 2999.00          | Success  |
+--------------+----------------+----------------+-----------+------------------+----------+
```

---

### Query 2: Count total recharge transactions
```sql
SELECT COUNT(*) AS total_transactions 
FROM mobile_recharge;
```
**Expected Output:**
```text
+---------------------+
| total_transactions  |
+---------------------+
| 60                  |
+---------------------+
```

---

### Query 3: Calculate total recharge revenue (Successful transactions)
```sql
SELECT SUM(recharge_amount) AS total_revenue 
FROM mobile_recharge 
WHERE status = 'Success';
```
**Expected Output:**
```text
+----------------+
| total_revenue  |
+----------------+
| 31828.00       |
+----------------+
```

---

### Query 4: Calculate average recharge amount
```sql
SELECT ROUND(AVG(recharge_amount), 2) AS avg_recharge_amount 
FROM mobile_recharge;
```
**Expected Output:**
```text
+----------------------+
| avg_recharge_amount  |
+----------------------+
| 557.43               |
+----------------------+
```

---

### Query 5: Find minimum recharge amount
```sql
SELECT MIN(recharge_amount) AS min_recharge_amount 
FROM mobile_recharge;
```
**Expected Output:**
```text
+----------------------+
| min_recharge_amount  |
+----------------------+
| 15.00                |
+----------------------+
```

---

### Query 6: Find maximum recharge amount
```sql
SELECT MAX(recharge_amount) AS max_recharge_amount 
FROM mobile_recharge;
```
**Expected Output:**
```text
+----------------------+
| max_recharge_amount  |
+----------------------+
| 2999.00              |
+----------------------+
```

---

### Query 7: Count recharges operator-wise
```sql
SELECT operator, COUNT(*) AS recharge_count 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY recharge_count DESC;
```
**Expected Output:**
```text
+-----------+-----------------+
| operator  | recharge_count  |
+-----------+-----------------+
| Jio       | 18              |
| Airtel    | 16              |
| Vi        | 14              |
| BSNL      | 12              |
+-----------+-----------------+
```

---

### Query 8: Calculate operator-wise revenue
```sql
SELECT operator, SUM(recharge_amount) AS total_revenue 
FROM mobile_recharge 
WHERE status = 'Success' 
GROUP BY operator 
ORDER BY total_revenue DESC;
```
**Expected Output:**
```text
+-----------+----------------+
| operator  | total_revenue  |
+-----------+----------------+
| Jio       | 12386.00       |
| Airtel    | 9832.00        |
| BSNL      | 5242.00        |
| Vi        | 4368.00        |
+-----------+----------------+
```

---

### Query 9: Find the most popular operator
```sql
SELECT operator, COUNT(*) AS total_recharges 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY total_recharges DESC 
LIMIT 1;
```
**Expected Output:**
```text
+-----------+------------------+
| operator  | total_recharges  |
+-----------+------------------+
| Jio       | 18               |
+-----------+------------------+
```

---

### Query 10: Find successful recharge transactions
```sql
SELECT recharge_id, customer_name, operator, recharge_amount, payment_method 
FROM mobile_recharge 
WHERE status = 'Success' 
LIMIT 5;
```
**Expected Output:**
```text
+--------------+----------------+-----------+------------------+-----------------+
| recharge_id  | customer_name  | operator  | recharge_amount  | payment_method  |
+--------------+----------------+-----------+------------------+-----------------+
| 1001         | Aarav Sharma   | Jio       | 239.00           | UPI             |
| 1002         | Priya Patel    | Airtel    | 299.00           | Credit Card     |
| 1003         | Rohit Verma    | Vi        | 19.00            | UPI             |
| 1004         | Ananya Iyer    | BSNL      | 147.00           | Debit Card      |
| 1005         | Vikram Singh   | Jio       | 2999.00          | UPI             |
+--------------+----------------+-----------+------------------+-----------------+
```

---

### Query 11: Count failed transactions
```sql
SELECT COUNT(*) AS failed_transactions 
FROM mobile_recharge 
WHERE status = 'Failed';
```
**Expected Output:**
```text
+----------------------+
| failed_transactions  |
+----------------------+
| 5                    |
+----------------------+
```

---

### Query 12: Count pending transactions
```sql
SELECT COUNT(*) AS pending_transactions 
FROM mobile_recharge 
WHERE status = 'Pending';
```
**Expected Output:**
```text
+-----------------------+
| pending_transactions  |
+-----------------------+
| 4                     |
+-----------------------+
```

---

### Query 13: Calculate payment-method-wise transactions
```sql
SELECT payment_method, COUNT(*) AS transaction_count, SUM(recharge_amount) AS total_amount 
FROM mobile_recharge 
GROUP BY payment_method 
ORDER BY transaction_count DESC;
```
**Expected Output:**
```text
+-----------------+--------------------+---------------+
| payment_method  | transaction_count  | total_amount  |
+-----------------+--------------------+---------------+
| UPI             | 24                 | 14828.00      |
| Credit Card     | 13                 | 9870.00       |
| Debit Card      | 12                 | 5828.00       |
| Wallet          | 11                 | 2920.00       |
+-----------------+--------------------+---------------+
```

---

### Query 14: Find highest recharge plan
```sql
SELECT recharge_id, customer_name, operator, plan_type, recharge_amount, validity_days 
FROM mobile_recharge 
ORDER BY recharge_amount DESC 
LIMIT 1;
```
**Expected Output:**
```text
+--------------+----------------+-----------+------------+------------------+----------------+
| recharge_id  | customer_name  | operator  | plan_type  | recharge_amount  | validity_days  |
+--------------+----------------+-----------+------------+------------------+----------------+
| 1005         | Vikram Singh   | Jio       | Annual     | 2999.00          | 365            |
+--------------+----------------+-----------+------------+------------------+----------------+
```

---

### Query 15: Find customers with recharge amount greater than 500
```sql
SELECT recharge_id, customer_name, operator, recharge_amount, plan_type, status 
FROM mobile_recharge 
WHERE recharge_amount > 500.00 
ORDER BY recharge_amount DESC 
LIMIT 5;
```
**Expected Output:**
```text
+--------------+----------------+-----------+------------------+------------+----------+
| recharge_id  | customer_name  | operator  | recharge_amount  | plan_type  |  status  |
+--------------+----------------+-----------+------------------+------------+----------+
| 1005         | Vikram Singh   | Jio       | 2999.00          | Annual     | Success  |
| 1048         | Abhishek Jha   | Jio       | 2999.00          | Annual     | Success  |
| 1019         | Manoj Tiwari   | BSNL      | 1999.00          | Annual     | Success  |
| 1013         | Deepak Mishra  | Airtel    | 1799.00          | Annual     | Success  |
| 1031         | Anita Mukherjee| Vi        | 1449.00          | Annual     | Success  |
+--------------+----------------+-----------+------------------+------------+----------+
```

---

### Query 16: Calculate location-wise recharge revenue
```sql
SELECT location, COUNT(*) AS successful_orders, SUM(recharge_amount) AS total_revenue 
FROM mobile_recharge 
WHERE status = 'Success' 
GROUP BY location 
ORDER BY total_revenue DESC 
LIMIT 5;
```
**Expected Output:**
```text
+------------+--------------------+----------------+
|  location  | successful_orders  | total_revenue  |
+------------+--------------------+----------------+
| Kolkata    | 6                  | 6573.00        |
| Patna      | 3                  | 5397.00        |
| Delhi      | 6                  | 3733.00        |
| Hyderabad  | 4                  | 2661.00        |
| Mumbai     | 5                  | 1353.00        |
+------------+--------------------+----------------+
```

---

### Query 17: Calculate average data offered by each operator
```sql
SELECT operator, ROUND(AVG(data_gb), 2) AS avg_data_gb 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY avg_data_gb DESC;
```
**Expected Output:**
```text
+-----------+--------------+
| operator  | avg_data_gb  |
+-----------+--------------+
| BSNL      | 52.04        |
| Airtel    | 2.94         |
| Vi        | 2.55         |
| Jio       | 2.22         |
+-----------+--------------+
```

---

### Query 18: Calculate average validity by operator
```sql
SELECT operator, ROUND(AVG(validity_days), 1) AS avg_validity_days 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY avg_validity_days DESC;
```
**Expected Output:**
```text
+-----------+--------------------+
| operator  | avg_validity_days  |
+-----------+--------------------+
| Jio       | 87.2               |
| Airtel    | 65.4               |
| BSNL      | 63.8               |
| Vi        | 35.6               |
+-----------+--------------------+
```

---

### Query 19: Find the number of successful recharges for each operator
```sql
SELECT operator, COUNT(*) AS successful_recharges 
FROM mobile_recharge 
WHERE status = 'Success' 
GROUP BY operator 
ORDER BY successful_recharges DESC;
```
**Expected Output:**
```text
+-----------+------------------------+
| operator  |  successful_recharges  |
+-----------+------------------------+
| Jio       | 16                     |
| Airtel    | 13                     |
| Vi        | 12                     |
| BSNL      | 10                     |
+-----------+------------------------+
```

---

### Query 20: Find top 5 customers based on total recharge amount
```sql
SELECT customer_id, customer_name, COUNT(*) AS recharges_done, SUM(recharge_amount) AS total_spent 
FROM mobile_recharge 
WHERE status = 'Success' 
GROUP BY customer_id, customer_name 
ORDER BY total_spent DESC 
LIMIT 5;
```
**Expected Output:**
```text
+--------------+----------------+------------------+--------------+
| customer_id  | customer_name  | recharges_done   | total_spent  |
+--------------+----------------+------------------+--------------+
| 205          | Vikram Singh   | 3                | 3359.00      |
| 245          | Abhishek Jha   | 1                | 2999.00      |
| 213          | Deepak Mishra  | 2                | 2158.00      |
| 219          | Manoj Tiwari   | 1                | 1999.00      |
| 230          | Anita Mukherjee| 1                | 1449.00      |
+--------------+----------------+------------------+--------------+
```

---

## 18. How to Stop the Project

### Option A: Using Stop Script
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> scripts\stop.bat
```

### Option B: Using Direct Docker Command
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> docker compose stop
```

### Clean Up Containers and Volumes Completely
If you want to wipe containers and data clean to start fresh:
```cmd
C:\Moblie recharge analyser\mobile-recharge-hive> scripts\clean.bat
```
*(or run `docker compose down -v`)*

---

## 19. Common Errors and Solutions

### Error 1: "Docker is not running" or "failed to connect to docker API"
- **Cause:** Docker Desktop service has not been started on Windows.
- **Solution:** Open Docker Desktop from the Start Menu, wait until the Docker icon turns steady green in the system tray, and run `scripts\start.bat` again.

### Error 2: "docker compose up -d fails" or "port 5432 or 10000 already in use"
- **Cause:** A local PostgreSQL or Hive process is already occupying port 5432 or 10000.
- **Solution:** Check port conflict using:
  ```cmd
  netstat -ano | findstr 5432
  netstat -ano | findstr 10000
  ```
  Stop the local service from Windows Services (`services.msc`), or change the host port in `docker-compose.yml` (e.g. `"5433:5432"`).

### Error 3: "Empty compose file"
- **Cause:** `docker-compose.yml` was created with 0 bytes or wrong filename.
- **Solution:** Verify `docker-compose.yml` exists in `mobile-recharge-hive/` and contains valid YAML syntax.

### Error 4: "HiveServer2 is not ready" or "Connection refused on port 10000"
- **Cause:** HiveServer2 is still warming up or initializing the Metastore tables in PostgreSQL.
- **Solution:** `scripts\create_table.bat` includes an automated retry loop that waits up to 2 minutes. You can also inspect logs using:
  ```cmd
  docker logs hive-server
  ```

### Error 5: "PostgreSQL connection error" / "org.postgresql.Driver not found"
- **Cause:** The PostgreSQL JDBC driver `.jar` is missing.
- **Solution:** Ensure `lib\postgresql-42.7.3.jar` is present. `scripts\start.bat` automatically downloads it if missing.

### Error 6: "Table does not exist: mobile_recharge"
- **Cause:** You attempted to run analysis queries before creating the table.
- **Solution:** Run `scripts\create_table.bat` first, followed by `scripts\load_data.bat`.

### Error 7: "Database does not exist: mobile_recharge_db"
- **Cause:** Database creation DDL was skipped.
- **Solution:** Ensure your query begins with `USE mobile_recharge_db;` or run `scripts\create_table.bat`.

### Error 8: "CSV file not found"
- **Cause:** `data\mobile_recharge.csv` was moved or deleted.
- **Solution:** Ensure `data\mobile_recharge.csv` is present before running `scripts\load_data.bat`.

### Error 9: "Permission problems"
- **Cause:** Windows file locking or Docker volume permission mismatch.
- **Solution:** The batch scripts use `docker cp` to copy files into `/tmp` inside the container where permissions are unrestricted.

### Error 10: "Container not found"
- **Cause:** Container was renamed or not created.
- **Solution:** Run `docker ps -a` to list all containers. Re-run `scripts\start.bat` to launch `hive-server` and `hive-postgres`.

### Error 11: "Beeline connection failure / User: hive is not allowed"
- **Cause:** Authentication configuration mismatch.
- **Solution:** Use the connection string `-u "jdbc:hive2://localhost:10000/mobile_recharge_db" -n hive -p ""` without setting complex passwords.

---

## 20. College Mini-Project Viva Questions & Answers

### Q1: What is Apache Hive?
**Answer:** Apache Hive is an open-source distributed data warehouse software built on top of Apache Hadoop. It provides data summarization, ad-hoc querying, and analysis of large datasets stored in HDFS and compatible storage using an SQL-like language called HiveQL.

### Q2: What is the difference between Hive and a Traditional RDBMS (like MySQL or Oracle)?
**Answer:**
- **Schema Validation:** RDBMS uses *Schema-on-Write* (validates schema when data is inserted). Hive uses *Schema-on-Read* (verifies schema only when reading/querying data).
- **Latency & Workload:** RDBMS is optimized for OLTP (real-time low-latency updates and transactions). Hive is designed for OLAP (batch processing and aggregations over massive data).
- **Updates:** Traditional RDBMS supports high-frequency updates and deletes; Hive is historically write-once, read-many (append-oriented).

### Q3: What is the role of the Hive Metastore?
**Answer:** The Hive Metastore stores metadata about Hive tables, partitions, columns, data types, and file locations. Instead of parsing the files every time, Hive queries the Metastore (in our case, PostgreSQL) to understand the table schema.

### Q4: Why did we use PostgreSQL for the Metastore instead of the default Derby database?
**Answer:** Apache Hive's default embedded Derby database is single-session only (only one user or process can access it at a time). PostgreSQL is a robust, multi-user relational database that supports concurrent client connections, making it the standard choice in production.

### Q5: What is the difference between an Internal (Managed) Table and an External Table in Hive?
**Answer:**
- **Managed Table:** Hive manages both the metadata and the actual data files. If you run `DROP TABLE`, Hive deletes the metadata **and** the actual data files from HDFS/disk.
- **External Table:** Hive only manages the metadata. If you run `DROP TABLE`, only the schema metadata is deleted; the underlying data files remain intact on storage.

### Q6: What is HiveServer2?
**Answer:** HiveServer2 (HS2) is a server interface that enables remote clients (like Beeline, Tableau, Python, Java) to execute queries against Apache Hive concurrently over Thrift and JDBC/ODBC protocols.

### Q7: What is Beeline?
**Answer:** Beeline is Hive’s command-line interface based on SQLLine. It communicates with HiveServer2 over JDBC. It replaced the legacy `hive` CLI because Beeline is secure, lightweight, and supports multi-user concurrent sessions.

### Q8: What does `TBLPROPERTIES ("skip.header.line.count"="1")` do?
**Answer:** It tells Hive's SerDe (Serializer/Deserializer) to ignore the first line of the input CSV file during query execution so the column headers are not parsed as actual data values.

### Q9: What happens behind the scenes when a HiveQL query is executed?
**Answer:**
1. Beeline sends the HiveQL query to HiveServer2 via JDBC.
2. The Hive Compiler checks syntax and consults the Metastore for schema details.
3. The query planner creates an Execution Plan (DAG of MapReduce or Tez stages).
4. The execution engine processes the data stored in HDFS/volumes.
5. The computed result is returned to HiveServer2 and displayed in Beeline.

### Q10: How does Hive handle partitioning?
**Answer:** Partitioning divides a large table into distinct directories based on the values of one or more partition columns (e.g., `location` or `operator`). When a query filters by the partition column, Hive prunes unnecessary partitions, dramatically reducing disk I/O and query time.

---

## Conclusion
This mini-project demonstrates an end-to-end Big Data workflow:
- Modern containerized deployment of Apache Hive and PostgreSQL on Windows.
- Schema creation with `skip.header` properties.
- Fast, automated data loading.
- 20 realistic analytical queries solving real telecom business questions.
- 100% command-line execution without GUI dependencies.
