# 🚗 Car Performance & Fuel Efficiency Analysis using SQL

## 📌 Project Overview
This project is an end-to-end data analysis using **SQL (MySQL 8.0)** to explore **car performance and fuel efficiency**.  
The main objective is to demonstrate how raw automotive data can be **cleaned, normalized, and transformed into meaningful insights** that support business and analytical decision-making.

This repository focuses on:
- Data cleaning and normalization
- Handling inconsistent data types
- Exploratory analysis using SQL aggregation
- Translating technical results into business-relevant insights

---

## Tools & Environment
- Database: MySQL 8.0
- Language: SQL
- Data Source: CSV file
- Execution Environment: Local MySQL Server (MySQL Workbench)
- OS: Windows 

---

## 🧠 Business Questions
This analysis is designed to answer questions such as:
- Which cars are the most fuel-efficient?
- How does the number of cylinders relate to fuel consumption?
- Do transmission types affect fuel efficiency?
- How does fuel efficiency vary by brand, class, and drive type?
- How has fuel efficiency evolved over time?

---

## 🗂 Dataset Description
The dataset contains automotive specifications and fuel consumption data, including:
- City MPG
- Highway MPG
- Combined MPG
- Number of cylinders
- Engine displacement
- Drive type
- Fuel type
- Transmission
- Vehicle brand, model, and year

> **Note:** The raw dataset contains inconsistent data types (numeric values stored as strings), requiring data cleaning before analysis.

---

## 🏗 Data Processing Workflow

### 1️⃣ Raw Table Creation
The raw table is created to mirror the original dataset structure without transformations.  
This allows full traceability between raw and cleaned data.

```sql
-- ================ --
-- Create Raw Table --
-- ================ --

create table if not exists
	portofolio.car_performance_raw
(
city_mpg int,
class varchar (30),
combination_mpg int,
cylinders varchar (20),
displacement varchar (20),
drive varchar (20),
fuel_type varchar (20),
highway_mpg int,
brand varchar (30),
model varchar (100),
transmission char (1),
year int
)
;

```


### 2️⃣ Data Loading
Data is imported from a CSV file using `LOAD DATA INFILE`.

```sql
-- ======================= --
-- Loading Data Into Table --
-- ======================= --

load data infile
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/car_data.csv'
into table
	portofolio.car_performance_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
;

```


### 3️⃣ Data Cleaning & Normalization
Key cleaning steps include:
- Converting MPG values to numeric types
- Normalizing `cylinders` from VARCHAR to INTEGER
- Normalizing `displacement` from VARCHAR to DECIMAL
- Using **regular expressions (REGEXP)** to validate numeric patterns
- Handling invalid or inconsistent values by converting them to `NULL`

```sql
-- =========================== --
-- Cleaning and Normalize Data --
-- =========================== --

create table portofolio.car_performance_clean as
select
	cast(city_mpg as unsigned) as city_mpg,
	class,
    cast(combination_mpg as unsigned) as combination_mpg,
case
	when trim(cylinders) regexp '^[0-9]+(\\.0+)?$'
    then cast(cast(trim(cylinders) as decimal(3,1)) as unsigned) else null
end as cylinders,
case
	when displacement regexp '^[0-9]+(\\.[0-9]+)?$'
    then cast(trim(displacement) as decimal(4,1)) else null
end as displacement,
drive,
fuel_type,
cast(highway_mpg as unsigned) as highway_mpg,
brand,
model,
transmission,
cast(year as unsigned) as year
from 
	portofolio.car_performance_raw
;

```

Example logic:
- `"4.0"` → `4`
- `"2.5"` → `2.5`
- Non-numeric or malformed values → `NULL`

This ensures analytical accuracy and prevents silent data truncation.

---

## 🔍 Data Validation & Anomaly Checks
Several validation queries are executed to:
- Compare total rows vs valid numeric values
- Identify potential data loss after cleaning
- Inspect distinct values for cylinders and fuel types

This step ensures data reliability before analysis.

```sql
-- ============================= --
-- data validation and anomalies --
-- ============================= --

select
	count(*) as total_rows,
    count(cylinders) as non_null_cylinders,
    count(displacement) as non_null_displacement
from
	portofolio.car_performance_clean
;

```

---

## 📊 Key Analyses & Insights

### 🚘 Most Fuel-Efficient Cars
Identifies vehicles with the highest combined MPG.

```sql
select
	distinct brand,
    model,
    max(combination_mpg) as best_combination_mpg
from
	portofolio.car_performance_clean
group by
	brand, model
order by
	best_combination_mpg desc
;


```

This query identifies the highest recorded combined MPG per vehicle model to account for potential duplicate entries across years or configurations.


### 🔧 Cylinder Count vs Fuel Efficiency
Analyzes how engine size (cylinders) impacts fuel efficiency.

```sql
select
	brand,
    model,
    cylinders,
    round(avg(combination_mpg),2) as avg_combination_mpg
from
	portofolio.car_performance_clean
group by
	brand,
    model,
    cylinders
order by
	avg_combination_mpg desc
;

```

### 🏷 Fuel Efficiency by Class
Compares average MPG across vehicle classes.

```sql
select
	class,
    avg(combination_mpg) as avg_mpg_fuel
from
	portofolio.car_performance_clean
group by
	class
order by
	avg_mpg_fuel desc
;

```

### ⚙ Transmission Type Distribution
Examines the distribution of transmission types.

```sql
select
    transmission,
    count(transmission) as total_transmission
from
	portofolio.car_performance_clean
group by
	transmission
order by
	total_transmission
;

```

### 🚙 Drive Type vs Efficiency
Analyzes average MPG by drive configuration (FWD, RWD, AWD).

```sql
select
	drive,
    avg(combination_mpg) as avg_mpg_fuel
from
	portofolio.car_performance_clean
group by
	drive
order by
	avg_mpg_fuel desc
;

```

### 🏭 Brand-Level Fuel Efficiency
Ranks brands based on average fuel efficiency (minimum data threshold applied).

```sql
select
	brand,
    round(avg(combination_mpg), 2) as avg_fuel
from
	portofolio.car_performance_clean
group by
	brand
having
	count(*) >= 5
order by
	avg_fuel desc
;

```

### 📈 Fuel Efficiency Over Time
Tracks fuel efficiency trends year by year.

```sql
select
	brand,
	model,
    year,
    round(avg(combination_mpg)) as avg_consumption_fuel_mpg
from
	portofolio.car_performance_clean
group by
	brand, model, year
order by
	avg_consumption_fuel_mpg desc
;

```

### 📦 Brand Model Distribution
Identifies brands with the largest number of models in the dataset.

```sql
select
	brand,
    count(brand) as total_models
from
	portofolio.car_performance_clean
group by
	brand
order by
	total_models desc
;

```

### ⚡ Fuel Type Comparison
Compares fuel efficiency across fuel types (e.g., gasoline vs electric).

```sql
select
	fuel_type,
    count(fuel_type) as total_cars,
    round(avg(combination_mpg), 2) as avg_mpg
from
	portofolio.car_performance_clean
group by
	fuel_type
;

```

---

## 📚 Key Skills Demonstrated
- SQL data cleaning and normalization
- Handling real-world messy data
- Regular expression validation
- Analytical thinking and business translation
- Writing structured, readable SQL queries

---

## 📎 Conclusion
This project demonstrates how SQL can be used not only to query data, but to:
- Clean and standardize real-world datasets
- Prevent analytical bias caused by improper data types
- Produce insights that are meaningful for both technical and non-technical stakeholders

---

## Project Structure

```text

car_performance/
│
├── data/
│    └── car_data.csv
├── sql/
│   ├── 1_Create_Raw_Table.sql
│   ├── 2_Loading_Data_Into_Existing_Table.sql
│   ├── 3_Cleaning_and_Normalize_Data.sql
│   ├── 4_Data_Validation.sql
│   └── 5_Analyze_Query.sql
│
└── README.md

```

## 🔎 Key Data Challenges Addressed
- Numeric values stored as VARCHAR (e.g., "4.0", "2.5")
- Risk of silent truncation during type conversion
- Inconsistent formatting across rows
- Potential analytical bias due to improper data types

---

## How to Run This Project
1. Create the raw and clean tables using the SQL script.
2. Place the CSV file in MySQL secure file directory.
3. Load data using `LOAD DATA INFILE and adjust the file path to your local directory`.
4. Execute cleaning and analysis queries sequentially.

---

## 📄 Data Source & Attribution
The dataset used in this project was originally compiled by **Arslaan Siddiqui** and obtained from a publicly available source.

This project uses the dataset strictly for educational and portfolio purposes. All analysis, data cleaning, and transformations are original work by the author.

---
