USE Natalie; 
GO

DROP TABLE IF EXISTS dbo.TabA; 
GO

CREATE TABLE dbo.TabA
(
    ID INT IDENTITY(1,1) PRIMARY KEY,   
    Jmeno NVARCHAR(100),                
    Prijmeni NVARCHAR(100),             
    RC NVARCHAR(100),                   
    DatumNarozeni DATE                  
);
