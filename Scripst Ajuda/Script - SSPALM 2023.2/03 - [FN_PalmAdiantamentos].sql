ALTER FUNCTION [dbo].[fn_PALM_Adiantamentos](@Unidade INT, @Atendimento INT)
RETURNS @t TABLE(Lancamento INT, Adiantamento MONEY)
AS
BEGIN

DECLARE @Lancamento INT;
DECLARE @Adiantamento MONEY;

SELECT 
@Lancamento = L.Código
FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
WHERE 
(L.DataDeEmissão IS NULL) 
AND ((L.Atendimento = @Atendimento AND L.Unidade = @Unidade) OR @Atendimento = 0) 
AND (L.Atendimento IS NOT NULL)
AND ((L.Status % 2) = 0)
AND (P.Natureza = -1) 
AND (R.SubItem = 0)
AND (R.Fator > 0)

--Comentado por iran_syber para pegar tambem o que tem na tabela de contas.
/*SELECT @Adiantamento = SUM(Valor) 
FROM dbo.Lançamentos_FormasDePagamento
WHERE LancamentoID = @Lancamento;*/

/*SELECT @Adiantamento = SUM(Valor)
FROM dbo.vwContas
WHERE LancamentoID = @Lancamento
AND Natureza = 1
AND ((Status % 16385) = 0);*/

SELECT @Adiantamento = SUM(Valor)
FROM
 vwContas
WHERE
 (LancamentoID IN (@Lancamento))	
 AND (Natureza <> 0);

SET @Lancamento = ISNULL(@Lancamento,0);
SET @Adiantamento = ISNULL(@Adiantamento,0);

INSERT @t(Lancamento, Adiantamento)
SELECT [Lancamento] = @Lancamento, [Adiantamento] =  @Adiantamento

RETURN;
END;
GO