ALTER FUNCTION [dbo].[fn_GetLancamentoComissaoVendedor]
(
@LancamentoID BIGINT,
@Status SMALLINT
)
RETURNS MONEY
BEGIN
IF (@LancamentoID < 10000)
BEGIN
SELECT @LancamentoID = LancamentoID, @Status = Status
FROM vwLancamentos
WHERE
(Emissao IS NULL) AND
(Atendimento = @LancamentoID) AND	
(UnidadeID = dbo.GetUnidadeLocal());
IF (@LancamentoID IS NULL)
RETURN 0.00;
END;
IF (@Status IS NULL)
RETURN 0.00;
IF ((@Status & 64) = 0)
RETURN 0.00;
DECLARE @Retorno MONEY;
SELECT @Retorno = ROUND(SUM(VendedorComissaoValor), 2, 1) 
FROM vwPedidos
WHERE
(LancamentoID = @LancamentoID) AND
(Natureza = -1);
SET @Retorno = ISNULL(@Retorno,0);	
RETURN @Retorno;
END;
GO