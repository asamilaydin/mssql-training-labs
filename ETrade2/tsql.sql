USE Etrade2

--DEĞİŞKEN KULLANIMI
DECLARE @SAYI2 INT = 3
DECLARE @SAYI3 INT = 0
DECLARE @TOPLAM INT

SET @TOPLAM = @SAYI2 + @SAYI3

SELECT @TOPLAM AS TOPLAM
---

DECLARE @ITEMNAME AS VARCHAR(100), @PRICE AS INT

SELECT @ITEMNAME=I.ITEMNAME, @PRICE=BUYINGPRICE
FROM ITEMS I

SELECT @ITEMNAME, @PRICE

--STRING FONKSİYONLAR (HATIRLAMAK ICIN)

-- 1. LEN()
SELECT LEN('OpenAI') AS Length; -- 6

-- 2. LEFT()
SELECT LEFT('OpenAI', 4) AS LeftPart; -- 'Open'

-- 3. RIGHT()
SELECT RIGHT('OpenAI', 2) AS RightPart; -- 'AI'

-- 4. SUBSTRING()
SELECT SUBSTRING('OpenAI', 2, 3) AS SubText; -- 'pen'

-- 5. CHARINDEX()
SELECT CHARINDEX('A', 'OpenAI') AS Position; -- 5

-- 6. PATINDEX()
SELECT PATINDEX('%AI%', 'OpenAI') AS PatPos; -- 5

-- 7. REPLACE()
SELECT REPLACE('Hello World', 'World', 'SQL') AS Replaced; -- 'Hello SQL'

-- 8. REPLICATE()
SELECT REPLICATE('SQL', 3) AS Repeated; -- 'SQLSQLSQL'

-- 9. SPACE()
SELECT 'A' + SPACE(3) + 'B' AS Spaced; -- 'A   B'

-- 10. LTRIM()
SELECT LTRIM('   SQL') AS TrimmedLeft; -- 'SQL'

-- 11. RTRIM()
SELECT RTRIM('SQL   ') AS TrimmedRight; -- 'SQL'

-- 12. UPPER()
SELECT UPPER('sql server') AS UpperCase; -- 'SQL SERVER'

-- 13. LOWER()
SELECT LOWER('SQL SERVER') AS LowerCase; -- 'sql server'

-- 14. CONCAT()
SELECT CONCAT('Hello', ' ', 'World') AS Concatenated; -- 'Hello World'

-- 15. FORMAT()
SELECT FORMAT(1234.567, 'N2') AS Formatted; -- '1,234.57'

-- 16. QUOTENAME()
SELECT QUOTENAME('ColumnName') AS Quoted; -- '[ColumnName]'

-- 17. STRING_AGG() (SQL Server 2017+)
SELECT STRING_AGG(Name, ', ') AS Names FROM (VALUES ('Ali'), ('Veli'), ('Ayşe')) AS X(Name); -- 'Ali, Veli, Ayşe'

--DATEDIFF


SELECT DATEDIFF(MONTH, '2023-12-01', '2024-05-13') AS AyFarki;  

SELECT DATEDIFF(YEAR, '2010-01-01', GETDATE()) AS YilFarki;

SELECT DATEDIFF(HOUR, '2024-05-13 08:00:00', '2024-05-13 15:00:00') AS SaatFarki; 

--DATEFROMPARTS

DECLARE @Yil INT = 2024;
DECLARE @Ay INT = 12;
DECLARE @Gun INT = 31;

SELECT DATEFROMPARTS(@Yil, @Ay, @Gun) AS TARIH;

--WHILE KULLANIMI 

DECLARE @i INT=1
WHILE @i<5
BEGIN
	PRINT 'SAYI ' + CAST(@i AS VARCHAR);
    SET @i=@i+1
END

--

DECLARE @i INT = 1;
DECLARE @customerId INT;

WHILE @i <= 5
BEGIN
    SELECT @customerId = ID
    FROM CUSTOMERS
    WHERE ID = @i;

    PRINT 'Müşteri ID: ' + CAST(@customerId AS VARCHAR);

    SET @i = @i + 1;
END





