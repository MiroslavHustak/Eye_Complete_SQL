-- 4.d Vypište seznam jmen a příjmení z tabulky TabA a ke každému jménu průměrnou váhu z tabulky TabB.

USE Natalie;
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'TabA')
   AND
   EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'TabB')
BEGIN
    SELECT a.Jmeno, a.Prijmeni, CAST(AVG(b.Vaha) AS DECIMAL(5, 2)) AS PrumernaVaha -- maximálně 999,99
    FROM TabA a
    INNER JOIN TabB b 
    ON a.ID = b.IDA
    GROUP BY a.Prijmeni, a.Jmeno 
    ORDER BY a.Prijmeni ASC;
END