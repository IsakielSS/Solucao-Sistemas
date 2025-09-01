ALTER VIEW [dbo].[vw_PALM_Cg_Produtos_Todos]
AS
(
	SELECT 
		p1.Produto,
		p1.Nome,
		p1.Preco,
		p1.Comissionado,
		p1.Fracionado,
		p1.Categoria,
		[DispVenda] = 1
	FROM dbo.vw_PALM_Cg_Produtos p1
	UNION
	SELECT
		p2.Código,
		p2.Descrição,
		0,
		0,
		0,
		0,
		0
	FROM Produtos p2
	WHERE NOT p2.Código IN (SELECT Produto FROM dbo.vw_PALM_Cg_Produtos)
	AND p2.Tipo not in('G', 'X')
);
GO

-------------------------------------------------

ALTER  VIEW [dbo].[vw_PALM_Cg_Produtos]
AS
/**

 [     .CAMPO.     ] [.TAMANHO.] [.FORMATO.]
  CÓDIGO...........         5        NNNNN     
  DESCRIÇÃO........        50     ********
  PREÇO DE VENDA...         7      NNNN.NN
  COMISSIONADO.....         1            B
  FRACIONADO.......         1            B

**/
SELECT 
	[Produto] = p.Código,
	[Nome] = p.Descrição,
	[Preco] = ISNULL(dbo.fn_GetPrecoDeVenda(p.Código,1),0),
	[Comissionado] = p.Comissionado,
	[Fracionado] = p.Fracionado,
	[Categoria] = p.Categoria,
	[Montagem] = (CASE WHEN m.ProdutoID IS NOT NULL THEN 1 ELSE 0 END),
	(
		'#' + dbo.fn_ZerosEsq(Código,5) + '#' + /*[ CÓDIGO ]*/
			cast(isnull(Descrição,'') as char(50)) + '#' + /*[ DESCRIÇÃO ]*/
				dbo.fn_ZerosEsq(cast(ISNULL(ISNULL(p.PreçoDeVenda, pv.Preco), 0) as varchar(7)),7) + '#' + /*[ PREÇO DE VENDA ]*/
					(case isnull(Comissionado,0) when 1 then '1' else '0' end) + '#' + /*[ COMISSIONADO ]*/
						(case isnull(Fracionado,0) when 1 then '1' else '0' end) + '#' + /*[ FRACIONADO ]*/
							dbo.fn_ZerosEsq(Categoria,5) + '#' /*[ CATEGORIA ]*/
	) 
	AS [Linha]
FROM
	Produtos p INNER JOIN ProdutosPrecosDeVenda pv ON p.Código = pv.ProdutoID
	INNER JOIN Precos pr ON pv.PrecoID = pr.PrecoID	
	LEFT JOIN vw_PALM_Cg_ProdutoTipoMontagem m ON p.Código = m.ProdutoID
WHERE
	p.Código IN (SELECT pu.Produto FROM Produtos_Unidades pu WHERE pu.Unidade = (SELECT CAST(Valor AS INT) FROM tb_PALM_Parametro WHERE Nome = 'Unidade'))
	AND pr.PrecoNome = (SELECT Valor FROM tb_PALM_Parametro WHERE Nome = 'PrecoNome')
	AND p.Ativo = 1
	AND p.Disponível = 1
	AND p.Tipo not in('G', 'X')
	AND p.Código IN (
		SELECT P.ProdutoID FROM vwProdutos P JOIN vwProdutosUnidades U ON U.ProdutoID = P.ProdutoID 
		WHERE P.Ativo = 1 AND u.UnidadeID = dbo.GetUnidadeLocal()	
	)
GO