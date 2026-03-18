/*
1.c Tabulka TabB se strukturou ID - jednoznačný identifikátor, klíč
 , IDA - Identifikátor vazby na TabA.ID (1:N)
 , Poradi - integer - unikátní klíč
 , Datum - datum
 , Vaha - desetinné číslo
 Tabulka TabA je seznam lidí, do tabulky TabB se zaznamenávají váhy jednotlivých lidí v čase
 V zadání nebudeme řešit, že některé sloupce nesmí být prázdné. 
*/

USE Natalie; -- Tady musí být (different DB context)
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
    CHECK (Vaha >= 0.0), -- Přidal jsem alespoň jeden CHECK constraint, když už to dělám 
    CONSTRAINT FK_TabB_TabA
        FOREIGN KEY (IDA) REFERENCES dbo.TabA(ID)   -- 1:N relationship
);