/** Object:  View [dbo].[vwFormasDePagamento]    Script Date: 04/03/2024 19:49:46 **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwFormasDePagamento] AS
SELECT FormaDePagamentoID, FormaDePagamentoNome, FormaDePagamentoSigla, Inclusao, Edicao, Status, Regras, Ativo, Especie, Natureza, Parcelas, ParcelasEntrada, ParcelasDias, ParcelasDias2, CartaoRede, CartaoAdministradora, TEF, TEFTipoDeTransacao, ViasAdicionais, Assinatura, Troco, Taxa, FornecedorID
FROM dbo.fn_FormasDePagamento2()
GO