SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROC GetTabA
    @Count INT OUTPUT -- typová deklarace output parametru
AS
BEGIN 
    SELECT * FROM TabA; -- dostaneme result set, ze kterého níže pomocí COUNT vyselektujeme počet záznamů
    SELECT @Count = COUNT(*) FROM TabA; -- do output parametru dosadíme počet záznamů (tj. počet lidí)
END; -- Konec procedury END
GO
