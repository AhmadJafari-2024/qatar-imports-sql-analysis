/*----------------------------------------------

Business Analysis

-----------------------------------------------*/

--Which 10 countries have the highest total import value?

SELECT TOP 10
CountryOfOrigin,
SUM (Value_qr) total_import_value
FROM qatar_imports
GROUP BY CountryOfOrigin
ORDER BY total_import_value DESC

--Which 10 products have the highest import value per unit?
SELECT
TOP 10
Hs12,
Details,
CountryOfOrigin,
Quantity,
Value_qr,
CAST(Round (Value_qr /NullIF (Quantity,0),2) AS DECIMAL (18,2)) as productbyvalue
FROM qatar_imports
ORDER BY productbyvalue DESC

--Which 10 countries has the highest imported weight?

SELECT TOP 10
CountryOfOrigin,
SUM(weight_kg) imported_weight
FROM qatar_imports
GROUP BY CountryOfOrigin
ORDER BY imported_weight DESC


--What percentage of total import value comes from each country?
SELECT
    CountryOfOrigin,
    CAST(SUM(Value_qr) AS DECIMAL(20,2)) AS TotalImportValue,

    CAST(
        SUM(Value_qr) * 100.0
        / SUM(SUM(Value_qr)) OVER()
        AS DECIMAL(10,2)
    ) AS PercentageOfTotal

FROM qatar_imports
WHERE CountryOfOrigin IS NOT NULL
GROUP BY CountryOfOrigin
ORDER BY PercentageOfTotal DESC;

--How do imports change by month?
SELECT
Year,
Month,
total_value_month,
LAG(total_value_month) OVER(ORDER BY Year ASC, Month ASC) as previous_month_value,
total_value_month - LAG(total_value_month) OVER(ORDER BY Year ASC, Month ASC) AS change_month
FROM(

SELECT
Year,
Month,
SUM (Value_qr) AS total_value_month
FROM qatar_imports
GROUP BY Year,Month )t


--Rank countries by import value
SELECT 
CountryOfOrigin,
total_import_value,
Row_Number() OVER ( ORDER BY total_import_value DESC) as RankOfCountry
FROM(
SELECT
CountryOfOrigin,
SUM (Value_qr) total_import_value
FROM qatar_imports
GROUP BY CountryOfOrigin)t


--Top 5 countries per month
WITH CTE_Country_total_value AS(
SELECT
CountryOfOrigin,
Year,
Month,
SUM (Value_qr) total_value
FROM qatar_imports
GROUP BY CountryOfOrigin,Year,Month
) ,
CTE_Ranking_country AS (
SELECT
CountryOfOrigin,
Year,
Month,
Row_Number() OVER(PARTITION BY [Year], [Month] ORDER BY total_value DESC ) as RANK
FROM CTE_Country_total_value)

SELECT
CountryOfOrigin,
Year,
Month,
[RANK]
FROM CTE_Ranking_country
WHERE [RANK] <=5

--Rank products within each country

WITH CTE_total_value_product_by_country AS(
SELECT
CountryOfOrigin,
Hs12,
Details,
SUM (Value_qr) total_value_product
FROM qatar_imports
GROUP BY CountryOfOrigin,Hs12,Details)

SELECT
CountryOfOrigin,
Hs12,
Details,
total_value_product,
Row_Number() OVER(PARTITION BY CountryOfOrigin ORDER BY total_value_product DESC,CountryOfOrigin) Rank
FROM CTE_total_value_product_by_country;

--Compare each country's import value with the overall average
WITH CountryImports AS
(
    SELECT
        CountryOfOrigin,
        SUM(Value_qr) AS TotalImportValue
    FROM qatar_imports
    WHERE CountryOfOrigin IS NOT NULL
      AND TRIM(CountryOfOrigin) <> ''
    GROUP BY CountryOfOrigin
)

SELECT
    CountryOfOrigin,

    CAST(TotalImportValue AS DECIMAL(20,2))
        AS TotalImportValue,

    CAST(
        AVG(TotalImportValue) OVER()
        AS DECIMAL(20,2)
    ) AS OverallAverage,

    CAST(
        TotalImportValue - AVG(TotalImportValue) OVER()
        AS DECIMAL(20,2)
    ) AS DifferenceFromAverage,

    CASE
        WHEN TotalImportValue > AVG(TotalImportValue) OVER()
            THEN 'Above Average'
        WHEN TotalImportValue < AVG(TotalImportValue) OVER()
            THEN 'Below Average'
        ELSE 'Average'
    END AS Performance

FROM CountryImports
ORDER BY TotalImportValue DESC;