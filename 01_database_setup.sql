CREATE DATABASE QatarTrade;
GO

USE QatarTrade;
GO

CREATE TABLE qatar_imports (
    import_id INT IDENTITY(1,1) PRIMARY KEY,
    [Year] SMALLINT,
    Quarter NVARCHAR(2),
    [Month] DECIMAL(3,1),
    Hs12 NVARCHAR(12),
    Details NVARCHAR(500),
    CountryOfOrigin NVARCHAR(100),
    Quantity DECIMAL(20,3),
    Weight_kg DECIMAL(20,3),
    Value_qr DECIMAL(20,3)
);