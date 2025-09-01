ALTER TABLE ProdutosPromocoes ADD AssumeValor bit;
GO
-------------
ALTER VIEW [dbo].[vwProdutosPromocoes] AS
SELECT ProdutoPromocaoID, Inclusao, Edicao, Status, Ativo, PromocaoNome, ProdutoID, PrecoID, Preco, Inicio, Conclusao, HoraInicio, HoraConclusao, Dom, Seg, Ter, Qua, Qui, Sex, Sab, TipoDesconto, Pague, Leve, APartirDe, UnidadeID, SomenteDiasUteis, Balcao, Mesas, Cartoes, Delivery, Encomendas, AssumeValor
FROM ProdutosPromocoes;
GO
-----------------
ALTER VIEW [Mosaico].[ProdutoPromocao] AS
SELECT ProdutoPromocaoID AS ID, Inclusao, Edicao, Status, Ativo, PromocaoNome AS Nome, ProdutoID, PrecoID, Preco, Inicio, Conclusao, HoraInicio, HoraConclusao, Dom, Seg, Ter, Qua, Qui, Sex, Sab, TipoDesconto AS Tipo, Pague, Leve, APartirDe, UnidadeID AS EstabelecimentoID, SomenteDiasUteis, ModalidadeRelacionada, Balcao, Mesas, Cartoes, Delivery, Encomendas, AssumeValor
FROM dbo.ProdutosPromocoes;
GO
---------------
UPDATE ProdutosPromocoes SET AssumeValor= 1 WHERE TipoDesconto= 1 AND Ativo= 1 AND Status %2 = 0;
GO

-------------
DROP TRIGGER [dbo].[TR_R_dboAtendimentos_IUD_Unidade];
GO

-------------
UPDATE Produtos SET Comissionado=0, arredonda=1, impressora=NULL WHERE Tipo IN ('G','X');
GO
-------------
ALTER VIEW [dbo].[vwLancamentos] AS
SELECT Código LancamentoID, DataDaInclusão Inclusao, DataDeEdição Edicao, Conexão ConexaoID, LançamentoOrigem LancamentoOrigemID, Status, Tipo, Atendimento, AtendimentoID, Unidade UnidadeID, UnidadeDestino UnidadeDestinoID, Histórico HistoricoID, CentroDeResultado CentroDeResultadoID, Cliente ClienteID, Fornecedor FornecedorID, Memorando, DataDeRequisição Requisicao, DataDeEnvio Envio, DataDeEmissão Emissao, ConexãoDaEmissão EmissaoConexaoID, DataDeMovimento Movimento, NF, NFSérie NFSerie, NFSubSerie, ValorDoLançamento Valor, Abatimento, Abatimento_Percentual AbatimentoPercentual, Bonificacao, Acrescimo, Credito, Encargos, ContraVale, ValorDoFrete Frete, Consumação Consumacao, ValorTotal, Troco, Modelo, DocumentoFiscalID, NFE, NFE_Recibo NFERecibo, NFE_Chave NFEChave, NFE_DT_Autorizacao NFEAutorizacao, NFE_Status NFEStatus, NFE_Motivo NFEMotivo, NFE_Dados_Complementares NFEDadosComplementares, NFE_NaturezaOperacao NFENaturezaDaOperacao, NFE_SaidaEntrada NFESaidaEntrada, NFE_FormaPagamento NFEFormaDePagamento, Transportador, Dinheiro, Cartão Cartao, Cheque, NFE_Ambiente NFEAmbiente, ValorDoSeguro Seguro, Transferencia, Autorizacao, AutorizacaoUsuarioID, AutorizacaoConexaoID, NFEProtocolo, Localizacao, LancamentoDestinoID, Operacao OperacaoID, NFPrefixo, CheckIn, FaturaID, FaturaStatus, Operacao, ClienteCPFCNPJ, DataDeEntradaFiscal, NFECancelamento, NFECancelamentoConexaoID, NFECancelamentoMotivo, DFEComputadorID, NFEImpressa, NFECancelada, DFETentativa, NFEFinalidade, EquipamentoCFeID, PreNF, PreNFSerie, PreChave, DescontoCondicional, ImportadoXML, NFEContingencia, NFEProtocoloCancelamento,CodigoExterno,NFEChaveCancelamento, NFEEmail, ContigenciaTipo, DFESituacao, DFEMensagem, CFeSessao, DFEEmailEnviado, ICMSvFCP, ICMSvFCPST, ICMSvFCPSTRet, EmissaoDFe, ConexaoCancelamento, DataDoCancelamento, ValorIOF IOFValor, DespesasAduaneiras, TipoConsumidor, PercentualDeDesconto, PercentualDeDesconto2, DiasParaDesconto, DiasParaDesconto2, PercentualDeMulta, DiasParaMulta, PercentualDeJuros, ValorCTE, ValorOutrosImpostos, Integradora
FROM Lançamentos;
GO
-------------