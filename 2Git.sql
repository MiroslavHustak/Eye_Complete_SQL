-- 2. Do tabulky TabA vložte skriptem 5 záznamů (hodnoty si můžete vybrat)

-- Níže uvedený kód by zcela postačoval pro splnění zadání, .....

/*
USE Natalie;
GO

INSERT INTO TabA (Jmeno, Prijmeni, RC, DatumNarozeni)
VALUES
('Floor', 'Jansen', '8102216847', '1981-02-21'),  
('Tuomas','Holopainen','7612253089', '1976-12-25'), 
('Emppu', 'Vuorinen', '7806241572', '1978-06-24'),  
('Marco', 'Hietala', '6601125396', '1966-01-12'),   
('Jukka', 'Nevalainen','7804219264', '1978-04-21'); 
*/

-- ... jenže se projevila paranoia funkcionálního programátora (tendence ověřovat kdeco): 

USE Natalie;
GO

IF EXISTS (
    SELECT 1 
    FROM sys.tables 
    WHERE [name] = 'TabA'
)

INSERT INTO TabA (Jmeno, Prijmeni, RC, DatumNarozeni) -- V tomto případě by nemělo být riziko SQL injection (TODO řešit pouze v ADO .NET, pokud se k tomu dostanu)
VALUES
('Floor', 'Jansen', '8102216847', '1981-02-21'),  
('Tuomas','Holopainen','7612253089', '1976-12-25'), 
('Emppu', 'Vuorinen', '7806241572', '1978-06-24'),  
('Marco', 'Hietala', '6601125396', '1966-01-12'),   
('Jukka', 'Nevalainen','7804219264', '1978-04-21'); 