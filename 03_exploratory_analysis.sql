
/*----------------------------------------------



--Understand the size and coverage of the data


-----------------------------------------------*/

--How many total rows?

SELECT COUNT(*) AS Total_Rows
FROM qatar_imports

-- How many months we have in the dataset
SELECT
DISTINCT [Month] 
FROM qatar_imports
ORDER BY [Month]

--Which years are included?

SELECT
DISTINCT Year
FROM qatar_imports

--Which quarters are included?
SELECT
DISTINCT Quarter
FROM qatar_imports

--Which months are included?

SELECT
DISTINCT Month
FROM qatar_imports
ORDER BY Month ASC

/*----------------------------------------------



--Understand the dimensions


-----------------------------------------------*/

--How many countries are represented?
SELECT 
COUNT (DISTINCT CountryOfOrigin) AS total_countries
FROM qatar_imports
WHERE CountryOfOrigin IS NOT NULL OR TRIM(CountryOfOrigin) != ''

--How many unique HS12 product codes?

SELECT 
COUNT (DISTINCT  Hs12) AS Total_Products
FROM qatar_imports

--How many unique product descriptions?

SELECT
COUNT (DISTINCT Details) AS total_description
FROM qatar_imports


/*----------------------------------------------



--Understand the measures


-----------------------------------------------*/

--Total import value in QR

SELECT 
SUM(Value_qr) AS total_value_import
FROM qatar_imports

--Total quantity imported

SELECT 
SUM (quantity) AS total_quantity_import
FROM qatar_imports

--Total weight imported

SELECT
SUM(weight_kg) AS total_weight_import
FROM qatar_imports

--Average import value per record

SELECT
AVG(value_qr) AS average_value_import
FROM qatar_imports


--Average Import value per unit

SELECT
Hs12,
Details,
CountryOfOrigin,
CAST (ROUND (value_qr/quantity ,2) AS DECIMAL (18,2)) as average_value_import_unit
FROM qatar_imports
WHERE Quantity != 0
ORDER BY average_value_import_unit DESC


-- Minimum and maximum import value

--Minimum import value per record
SELECT
Hs12,
Details,
CountryOfOrigin,
Value_qr
FROM(

SELECT
Hs12,
Details,
CountryOfOrigin,
Value_qr,
MIN (Value_qr) OVER() AS minimum_value
FROM qatar_imports) t

WHERE Value_qr = minimum_value

--Maximum import value per record
SELECT
Hs12,
Details,
CountryOfOrigin,
Value_qr
FROM(


SELECT

Hs12,
Details,
CountryOfOrigin,
Value_qr,
MAX(Value_qr) OVER() AS maximum_value
FROM qatar_imports) t

WHERE Value_qr = maximum_value

--Minimum import value per product
WITH ProductValue AS
(
    SELECT
        Hs12,
        CountryOfOrigin,
        Details,
        SUM(Value_qr) AS TotalValue,
        SUM(Quantity) AS TotalQuantity
    FROM qatar_imports
    GROUP BY
        Hs12,
        Details,
        CountryOfOrigin
    
)

SELECT TOP 10
    Hs12,
    CountryOfOrigin,
    Details,
    CAST(
        TotalValue / NULLIF(TotalQuantity, 0)
        AS DECIMAL(18,4)
    ) AS ValuePerUnit
FROM ProductValue
WHERE TotalQuantity IS NOT NULL AND TotalQuantity !=0 AND TotalValue IS NOT NULL AND TotalValue!=0
ORDER BY ValuePerUnit ASC;

--Maximum import value per product
WITH ProductValue AS
(
    SELECT
        Hs12,
        CountryOfOrigin,
        Details,
        SUM(Value_qr) AS TotalValue,
        SUM(Quantity) AS TotalQuantity
    FROM qatar_imports
    GROUP BY
        Hs12,
        Details,
        CountryOfOrigin
)

SELECT TOP 10
    Hs12,
    CountryOfOrigin,
    Details,
    CAST(
        TotalValue / NULLIF(TotalQuantity, 0)
        AS DECIMAL(18,2)
    ) AS ValuePerUnit
FROM ProductValue
ORDER BY ValuePerUnit DESC;
