ALTER TABLE Fiscal.CalculosICMS ADD PautaFixa DECIMAL(5,2) NULL;
--
ALTER TABLE Fiscal.CalculosICMS ADD AliquotaFCPST DECIMAL(5,2) NULL;
--
ALTER table LANÇAMENTOS  ADD  INDFINAL int null;

--
alter VIEW [dbo].[vwLancamentos]
AS
SELECT        Código AS LancamentoID, DataDaInclusão AS Inclusao, DataDeEdição AS Edicao, Conexão AS ConexaoID, LançamentoOrigem AS LancamentoOrigemID, Status, Tipo, Atendimento, AtendimentoID, 
                         Unidade AS UnidadeID, UnidadeDestino AS UnidadeDestinoID, Histórico AS HistoricoID, CentroDeResultado AS CentroDeResultadoID, Cliente AS ClienteID, Fornecedor AS FornecedorID, Memorando, 
                         DataDeRequisição AS Requisicao, DataDeEnvio AS Envio, DataDeEmissão AS Emissao, ConexãoDaEmissão AS EmissaoConexaoID, DataDeMovimento AS Movimento, NF, NFSérie AS NFSerie, NFSubSerie, 
                         ValorDoLançamento AS Valor, Abatimento, Abatimento_Percentual AS AbatimentoPercentual, Bonificacao, Acrescimo, Credito, Encargos, ContraVale, ValorDoFrete AS Frete, Consumação AS Consumacao, 
                         ValorTotal, Troco, Modelo, DocumentoFiscalID, NFE, NFE_Recibo AS NFERecibo, NFE_Chave AS NFEChave, NFE_DT_AUTORIZACAO AS NFEAutorizacao, NFE_Status AS NFEStatus, NFE_Motivo AS NFEMotivo, 
                         nfe_dados_complementares AS NFEDadosComplementares, nfe_naturezaoperacao AS NFENaturezaDaOperacao, nfe_saidaentrada AS NFESaidaEntrada, nfe_formapagamento AS NFEFormaDePagamento, 
                         Transportador, Dinheiro, Cartão AS Cartao, Cheque, NFE_Ambiente AS NFEAmbiente, ValorDoSeguro AS Seguro, Transferencia, Autorizacao, AutorizacaoUsuarioID, AutorizacaoConexaoID, NFEProtocolo, 
                         Localizacao, LancamentoDestinoID, Operacao AS OperacaoID, NFPrefixo, CheckIn, FaturaID, FaturaStatus, Operacao, ClienteCPFCNPJ, DataDeEntradaFiscal, NFECancelamento, NFECancelamentoConexaoID, 
                         NFECancelamentoMotivo, DFEComputadorID, NFEImpressa, NFECancelada, DFETentativa, NFEFinalidade, EquipamentoCFeID, PreNF, PreNFSerie, PreChave, DescontoCondicional, ImportadoXML, 
                         NFEContingencia, NFEProtocoloCancelamento, CodigoExterno, NFEChaveCancelamento, NFEEmail, ContigenciaTipo, DFESituacao, DFEMensagem, CFeSessao, DFEEmailEnviado, ICMSvFCP, ICMSvFCPST, 
                         ICMSvFCPSTRet, EmissaoDFe, ConexaoCancelamento, DataDoCancelamento, ValorIOF AS IOFValor, DespesasAduaneiras, TipoConsumidor, PercentualDeDesconto, PercentualDeDesconto2, DiasParaDesconto, 
                         DiasParaDesconto2, PercentualDeMulta, DiasParaMulta, PercentualDeJuros, ValorCTE, ValorOutrosImpostos, Integradora, INDFINAL
FROM            dbo.Lançamentos