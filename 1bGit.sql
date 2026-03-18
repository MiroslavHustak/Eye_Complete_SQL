/*
1.b. K tabulce TabA vytvořte unikátní klíč na sloupec RC
*/
-- Níže uvedený kód by zcela postačoval pro splnění zadání, .....
/*
USE Natalie
GO

ALTER TABLE dbo.TabA
ADD CONSTRAINT UNIQUE_KEY_TabA_RC UNIQUE (RC);
*/

-- ... jenže se projevila paranoia funkcionálního programátora (tendence ověřovat kdeco): 

USE Natalie;
GO

IF EXISTS (
    SELECT 1 
    FROM sys.tables 
    WHERE [name] = 'TabA'
)
-- Pokud control statement (IF) má provést více jak jeden statement, BEGIN-END block je nutný
BEGIN
    ALTER TABLE dbo.TabA
    -- DROP CONSTRAINT UNIQUE_KEY_TabA_RC --UNIQUE (RC);
    ADD CONSTRAINT UNIQUE_KEY_TabA_RC UNIQUE (RC);
END