USE []
GO

/****** Object:  StoredProcedure [dbo].[sp_Consultar_Erro_Totais]    Script Date: 04/06/2024 11:51:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








/*	1.1 - VERSÃO Isakiel Souza
*/

CREATE PROCEDURE [dbo].[sp_Consultar_Erro_Totais]
(
	@L INT
)
AS
BEGIN
		

		SET NOCOUNT ON

		select Código, DataDeEmissão, Status, ValorDoLançamento, Abatimento, ValorDoFrete, ValorTotal, Troco, Frete, NFE_Chave, DFEMensagem, NFE_Chave, PreChave
		 from Lançamentos
		where Código = @L
		select P.Código as PedidoID, Conexão, S_Programa, S_ProgramaVersao from Pedidos P
		inner join Conexões C on C.Código = P.Conexão
		where lançamento = @L
		select PP.PedidoProdutoID, PP.Pedido, PP.Status, PP.Produto, P.Descrição, P.Tipo, Preço, PP.QDE, PP.Fator, Desconto, QDE * Preço as PreçoArred, PreçoTotal, Frete, ProdutoNCM, PP.Observações
		from Pedidos_Produtos PP
		inner join Produtos P on P.Código = PP.Produto
		where Lancamento = @L
		select sum((QDE * Preço) - Desconto) as TotalProdutos
		from Pedidos_Produtos PP
		where Lancamento = @L and Status & 1 = 0 and Fator > 0
		select ValorDaConta, ValorPago from Contas
		where Lançamento = @L and status % 2 = 0

		SET NOCOUNT OFF

	--RETURN 1

END





/****** Object:  StoredProcedure [sp_Consultar_Erros]    Script Date: 28/07/2021 19:39:09 ******/
SET ANSI_NULLS ON


GO


