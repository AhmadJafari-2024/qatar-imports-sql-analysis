# Qatar Imports SQL Analysis

## Project Overview

This project analyzes Qatar import data for 2025–2026 using Microsoft SQL Server.

The main goal was to practice working with a real dataset and use SQL to explore import patterns, check data quality, identify major source countries and products, and analyze changes in import value over time.

The project was completed independently after finishing my SQL training and was designed to apply SQL concepts to real Qatar data.

---

## Dataset

The dataset was obtained from the State of Qatar Open Data Portal.

It contains information about imported products, their countries of origin, quantities, weight, and import value in Qatari Riyals.

The dataset contains approximately 252,000 records.

### Main Columns

- `Year` – Year of the import record
- `Quarter` – Quarter of the year
- `Month` – Month of the import
- `HS12` – HS product classification code
- `Details` – Product description
- `CountryOfOrigin` – Country where the imported product originated
- `Quantity` – Reported quantity of the imported product
- `Weight_kg` – Imported weight in kilograms
- `Value_qr` – Total import value in Qatari Riyals

The original dataset was provided as a semicolon-delimited CSV file and was imported into SQL Server for analysis.

---

## Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL
- CSV data from the State of Qatar Open Data Portal
- GitHub for project documentation and version control

---

## Database Structure

A SQL Server database called `QatarTrade` was created for the project.

The main table used for the analysis was:

`qatar_imports`

The table contains an automatically generated primary key called `import_id` together with the original fields from the dataset.

### Main Table Structure

| Column | Description |
|---|---|
| `import_id` | Unique ID generated for each row |
| `Year` | Import year |
| `Quarter` | Import quarter |
| `Month` | Import month |
| `HS12` | Product classification code |
| `Details` | Product description |
| `CountryOfOrigin` | Country of origin |
| `Quantity` | Imported quantity |
| `Weight_kg` | Imported weight in kilograms |
| `Value_qr` | Total import value in Qatari Riyals |

---

## Data Quality Checks

Before starting the analysis, I performed several checks to better understand the quality of the dataset.

The checks included:

- Checking the total number of records
- Checking which years, quarters, and months were included
- Identifying missing country values
- Checking for missing product codes and descriptions
- Checking for missing quantity, weight, and import value
- Checking for zero and negative numeric values
- Identifying exact duplicate records
- Handling division by zero when calculating value per unit

For calculations involving quantity, `NULLIF()` was used to prevent division-by-zero errors.

---

## Questions Explored

### Dataset Exploration

- How many records are included in the dataset?
- Which years, quarters, and months are represented?
- How many countries are represented?
- How many unique HS12 product codes are included?
- How many unique product descriptions are included?
- What is the total import value?
- What is the total imported quantity?
- What is the total imported weight?
- What is the average import value per record?
- What are the minimum and maximum import values?

### Business Analysis

- Which countries have the highest total import value?
- Which products have the highest total import value?
- Which country has the highest imported weight?
- What percentage of Qatar's total import value comes from each country?
- How does total import value change from month to month?
- How much did imports increase or decrease compared with the previous month?
- How do countries rank by total import value?
- Which five countries have the highest import value in each month?
- How do products rank within each country?
- How does each country's total import value compare with the average import value across all countries?
- What is the estimated import value per reported unit?

---

## SQL Techniques Used

This project applies several SQL concepts, including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `COUNT()`
- `COUNT(DISTINCT)`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `CASE`
- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- `ROW_NUMBER()`
- `DENSE_RANK()`
- `LAG()`
- `PARTITION BY`
- `NULLIF()`
- `CAST()`
- `ROUND()`
- `TRIM()`
- Top-N analysis
- Month-over-month analysis
- Percentage-of-total analysis
- Data quality and duplicate checks

---

## Key Findings

The main findings from the analysis were:

- **Top import source country:** 1.China, 2.US, 3.Italy, 4.Japan, 5.India, 6.UAE, 7.Germany, 8.UK, 9.Switzerland, 10.France.
- **Highest-value imported product:** Fixed platforms for drilling, boring and extracting oil and gas, Gas Turbine Of A Power Exceeding 5,000 Kw,Turbo Jets Of A Power Not Exceeding 1,100 Kw.
- **Country with the highest imported weight:** UAE
- **Largest share of total imports:** China , around 17.5%
- **Monthly trend:** We observed a decline in the value of imports during the second, ninth, and eleventh months of 2025 compared to the preceding month in each case; a similar trend was seen in the second month of 2026, while the remaining months showed an increase in import value.
- **Countries frequently appearing in the monthly Top 5:** China,US,Germany
- **Other notable finding:** Although Switzerland’s total export volume is not particularly high-ranking outside the top 50 nations by aggregate weight of goods,it has managed to secure a place among the top 10 exporters to Qatar by value, thanks to a focus on high-value-added products such as jewelry, precision medical devices, and specialized pharmaceuticals.

These findings were based directly on the SQL queries included in the `sql_scripts` folder.

---

## Repository Structure

```text
qatar-imports-sql-analysis/
│
├── datasets/
│   └── data_source.md
│
├── sql_scripts/
│   ├── 01_database_setup.sql
│   ├── 02_data_quality.sql
│   ├── 03_exploratory_analysis.sql
│   └── 04_business_analysis.sql
│
└── README.md
