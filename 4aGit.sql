USE Natalie;
GO

IF EXISTS (
    SELECT 1 
    FROM sys.tables 
    WHERE [name] = 'TabA'
)

SELECT Jmeno, Prijmeni
FROM TabA
ORDER BY Prijmeni ASC;
