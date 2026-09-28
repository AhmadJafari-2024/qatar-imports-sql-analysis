--Any missing HS12?
--Missing Details?
--Missing Quantity, Weight_kg, or Value_qr?
--Any negative values?
--Any quantity/weight/value equal to zero?

SELECT
    Hs12,
    Details,
    CountryOfOrigin,
    Quantity,
    Weight_kg,
    Value_qr
FROM qatar_imports
WHERE
       Hs12 IS NULL
    OR TRIM(Hs12) = ''
    OR Details IS NULL
    OR TRIM(Details) = ''
    OR CountryOfOrigin IS NULL
    OR TRIM(CountryOfOrigin) = ''
    OR Quantity IS NULL
    OR Quantity <= 0
    OR Weight_kg IS NULL
    OR Weight_kg < 0
    OR Value_qr IS NULL
    OR Value_qr <= 0;

-- Any obvious duplicate rows?
SELECT
    [Year],
    Quarter,
    [Month],
    Hs12,
    Details,
    CountryOfOrigin,
    Quantity,
    weight_kg,
    Value_qr,
    COUNT(*) AS duplicate_count
FROM qatar_imports
GROUP BY
    [Year],
    Quarter,
    [Month],
    Hs12,
    Details,
    CountryOfOrigin,
    Quantity,
    weight_kg,
    Value_qr
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC