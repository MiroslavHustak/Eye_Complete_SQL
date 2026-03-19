USE Natalie; 
GO

DROP TABLE IF EXISTS dbo.TabB; 
GO

CREATE TABLE dbo.TabB
(
    ID INT IDENTITY(1,1) PRIMARY KEY,  
    IDA INT,    --1:N relationship, pro 1:1 by muselo být IDA INT UNIQUE                        
    Poradi INT UNIQUE,                  
    Datum DATE,                        
    Vaha DECIMAL(5,2),  -- (5, 2) - Maník/mánička nebude hmotnit více, jak 999,99 kg, neb (5, 2) to zajistí   
    CHECK (Vaha >= 0.0),
    CONSTRAINT FK_TabB_TabA
        FOREIGN KEY (IDA) REFERENCES dbo.TabA(ID)   -- 1:N relationship
);
