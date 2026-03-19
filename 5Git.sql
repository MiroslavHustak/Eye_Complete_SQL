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
    @Count INT OUTPUT 
AS
BEGIN 
    SELECT * FROM TabA; -- dostaneme result set, ze kterého níže pomocí COUNT vyselektujeme počet záznamů
    SELECT @Count = COUNT(*) FROM TabA;
END; 
GO
