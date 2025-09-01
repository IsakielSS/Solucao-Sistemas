/****** Object:  View [dbo].[vw_PALM_Cg_Produtos_Composicoes]    Script Date: 24/09/2018 16:10:21 ******/
DROP VIEW [dbo].[vw_PALM_Cg_Produtos_Composicoes]
GO

/****** Object:  View [dbo].[vw_PALM_Cg_Produtos_Composicoes]    Script Date: 24/09/2018 16:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_PALM_Cg_Produtos_Composicoes]
AS
(
	SELECT DISTINCT
		[CategoriaID] = ISNULL(Cat.CategoriaID,0),
		[CategoriaNome] = ISNULL(Cat.CategoriaNome,'OUTROS'),  
		[ProdutoID] = C.ProdutoID,
		[ProdutoNome] = D_Pai.ProdutoNome, 
		[SubProdutoID] = C.Produto2ID, 
		[SubProdutoNome] = D.ProdutoNome, 
		[Preco] = dbo.fn_GetPrecoDeVenda(c.Produto2ID, 1),
		[Fracionavel] = ISNULL(D.Fracionado,0),
		[Partes] = ISNULL(D_Pai.QDEItens, 1),
		[Tipo] = (
			CASE 
				WHEN C.TIPO = 5 THEN 'O'
				WHEN C.TIPO = 10 THEN 'A'
				WHEN C.TIPO = 15 THEN 'M'
				ELSE 'O'
			END), 
		
		[TemMontagem] = ISNULL(D.Montagem, 0), 
		[SubProdutoQuantidade] = C.QDE, 		
		[AceitaPrecoZero] = C.PrecoZero, 
		[Unidade] = PU.UnidadeID
	FROM
		vwProdutosComposicoes C JOIN
		vwProdutos D ON D.ProdutoID = C.Produto2ID JOIN
		vwProdutos D_Pai ON D_Pai.ProdutoID = C.ProdutoID JOIN
		vwProdutosUnidades PU ON D.ProdutoID = PU.ProdutoID OUTER APPLY
		(SELECT TOP 1 cc.CategoriaID, cc.CategoriaNome FROM vwCategorias cc WHERE cc.CategoriaID = ISNULL(C.GrupoDeOpcionais, D.CategoriaID)) AS Cat
	WHERE
		--(C.ProdutoID = 45) AND
		(C.Baixar = 0)
		AND (C.GrupoDeOpcionais > -1)
		AND ((D.Venda = 1) OR (C.Tipo = 1))
		AND (D.Ativo = 1)
		AND (C.Ativo = 1)		
		AND (c.Tipo IS NULL OR c.Tipo IN (5,10,15))
		AND (PU.Ativo = 1) 
	--	AND PU.UnidadeID = dbo.GetUnidadeLocal()
	--ORDER BY C.Tipo, C.GrupoDeOpcionais, D.CategoriaID, C.Produto2ID
);

 



