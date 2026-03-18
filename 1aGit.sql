/*
Tabulka TabA se strukturou ID - jednoznačný identifikátor, klíč
 , Jmeno - 100 znaků
 , Prijmeni - 100 znaků
 , RC - 100 znaků - unikátní klíč
 , DatumNarozeni - datum
*/

/*
N - UNICODE (kdybychom měli jen ASCII, stačilo by VARCHAR)
VARCHAR - proměnná délka řetezce
IDENTITY od 1, krok 1
PRIMARY KEY constraint zajistí unikátnost (dle mne tady vhodné)
*/

USE Natalie; -- Hodí se v případě different DB context
GO

DROP TABLE IF EXISTS dbo.TabA; -- dbo je default schema
GO

CREATE TABLE dbo.TabA
(
    ID INT IDENTITY(1,1) PRIMARY KEY,   
    Jmeno NVARCHAR(100),                
    Prijmeni NVARCHAR(100),             
    RC NVARCHAR(100),                   
    DatumNarozeni DATE                  
);