-- MODIFIQUE ESTE ARQUIVO PARA ALTERAR A FORMA COMO É REALIZADA A CARGA DE PRODUTOS --
 SELECT DISTINCT 
  [Produto] = p.Código, 
  [Nome] = p.Descrição, 
  [Preco] = ISNULL(dbo.fn_GetPrecoDeVenda_PorUnidade(p.Código, 1),0), 
  [Comissionado] = ISNULL(p.Comissionado,0), 
  [Fracionado] = ISNULL(p.Fracionado,0), 
  [Categoria], 
  [Montagem] = (CASE WHEN m.ProdutoID IS NOT NULL THEN 1 ELSE 0 END) 
 FROM 
  Produtos p 
 LEFT JOIN 
  vw_PALM_Cg_ProdutoTipoMontagem m ON p.Código = m.ProdutoID 
 WHERE 
  (p.Disponível = 1) 
  AND p.Tipo not in('G', 'X') 
  AND (p.Ativo = 1) 
  AND p.Código IN ( 
    SELECT P.ProdutoID FROM vwProdutos P JOIN vwProdutosUnidades U ON U.ProdutoID = P.ProdutoID 
    WHERE U.Ativo = 1 AND u.UnidadeID = 1
    ) 
  ORDER BY Código; 

