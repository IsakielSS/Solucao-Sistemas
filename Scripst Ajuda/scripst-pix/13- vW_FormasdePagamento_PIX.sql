ALTER VIEW [dbo].[vwFormasDePagamento] AS
SELECT FormaDePagamentoID, FormaDePagamentoNome, FormaDePagamentoSigla, Inclusao, Edicao, Status, Regras, Ativo, Especie, Natureza, Parcelas, ParcelasEntrada, ParcelasDias, ParcelasDias2, CartaoRede, CartaoAdministradora, TEF, TEFTipoDeTransacao, ViasAdicionais, Assinatura, Troco, Taxa, FornecedorID, PIX
FROM dbo.fn_FormasDePagamento2()
GO


