ALTER VIEW [dbo].[vwProdutosPromocoes] AS
SELECT ProdutoPromocaoID, Inclusao, Edicao, Status, Ativo, PromocaoNome, ProdutoID, PrecoID, Preco, Inicio, Conclusao, HoraInicio, HoraConclusao, Dom, Seg, Ter, Qua, Qui, Sex, Sab, TipoDesconto, Pague, Leve, APartirDe, UnidadeID, SomenteDiasUteis, Balcao, Mesas, Cartoes, Delivery, Encomendas, AssumeValor
FROM ProdutosPromocoes
GO