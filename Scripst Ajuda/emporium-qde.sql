/****** Object:  View [Mosaico].[ProdutoMontagem]    Script Date: 06/01/2025 09:58:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Mosaico].[ProdutoMontagem]
AS
SELECT        C.Código AS ID, C.Produto AS ProdutoTitularID, C.Produto2 AS ProdutoID, D.Descrição AS ProdutoNome,
        C.DataDeEdição AS Edicao, C.Status, D.Comissionado, CONVERT(BIT, CASE WHEN (ISNULL(D .TemInsumos, 0) = 1) OR
                         (D .Tipo = 'C') THEN 1 ELSE 0 END) AS TemInsumos, C.QDE, D.Qde AS Expr1
FROM            dbo.Produtos_Composições AS C INNER JOIN
                         dbo.Produtos AS D ON C.Produto2 = D.Código
WHERE        (C.Tipo = 15) AND (C.Ativo = 1)

GO


