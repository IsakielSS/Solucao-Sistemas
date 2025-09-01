ALTER VIEW [dbo].[vwAtendimentos] AS
SELECT AtendimentoID AtendimentoID2, Unidade UnidadeID, Atendimento, DataDaInclusão Inclusao, DataDeEdição Edicao, Status, Ativo, Tipo, Tipo | 16 AS ModalidadeID, Ambiente AS AmbienteID, Preço AS PrecoID, Produto AS ProdutoID, Crédito AS Credito, CheckIn, Setor AS SetorID, Vendedor VendedorID, Corretor CorretorID, Reservado, Observacoes, TipoDeApartamentoID, PacoteID, Ramal, StatusApartamento, RFID,ClienteID,EmPagamento
FROM Atendimentos
GO



