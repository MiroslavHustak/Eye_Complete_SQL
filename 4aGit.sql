-- 4.a Vypište seznam jmen a příjmení z tabulky TabA setříděné podle příjmení od A do Z.

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