-- 4.c Vypište seznam jmen a příjmení z tabulky TabA a Datum a Váhu z tabulky TabB,
-- u nichž se v čase vyskytlo vážení, kde váha byla větší než (například 100 kg).

USE Natalie;
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'TabA')
   AND
   EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'TabB')
BEGIN
    SELECT a.Jmeno, a.Prijmeni, b.Datum, b.Vaha
    FROM TabA a
    INNER JOIN TabB b 
    ON a.ID = b.IDA
    WHERE b.Vaha > 72
    ORDER BY a.Prijmeni DESC;
END