-- 4.b Vypište seznam jmen a příjmení z tabulky TabA setříděné podle DatumNarozeni - od nejmladších po nejstarší.

USE Natalie;
GO

IF EXISTS (
    SELECT 1 
    FROM sys.tables 
    WHERE [name] = 'TabA'
)

SELECT Jmeno, Prijmeni
FROM TabA
ORDER BY DatumNarozeni DESC;