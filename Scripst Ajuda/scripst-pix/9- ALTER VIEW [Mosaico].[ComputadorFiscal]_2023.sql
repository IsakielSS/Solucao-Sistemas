ALTER VIEW [Mosaico].[ComputadorFiscal] AS
SELECT
	ComputadoresConfigFiscalID ID, Inclusao, Edicao, Status, ComputadorID, CertNumeroDeSerie CertificadoNS,
	DANFE, FormaEmissao, CaminhoLogomarca LogomarcaCaminho, SalvarEnvioResposta, PathSalvar, WebServiceUF, WebServiceAmbiente,
	WebServiceVisualizar, AmbHomologacaoNumero HomologacaoNumero, AmbHomologacaoSerie HomologacaoSerie,
	AmbProducaoNumero ProducaoNumero, AmbProducaoSerie ProducaoSerie, DadosComplementares, ParcelasNFe NFeParcelas,
	ImprimirNFe NFeImprime, NFSeAmbHomologacaoLote NFSeHomologacaoLote, NFSeAmbHomologacaoRPS NFSeHomologacaoRPS,
	NFSeAmbHomologacaoSerie NFSeHomologacaoSerie, NFSeAmbProducaoLote NFSeProducaoLote, NFSeAmbProducaoRPS NFSeProducaoRPS,
	NFSeAmbProducaoSerie NFSeProducaoSerie, 
	NFCeAmbHomologacaoNumero NFCeHomologacaoNumero, CSCHomologacao NFCeHomologacaoCSC, CSCIDHomologacao NFCeHomologacaoCSCID,
	NFCeAmbHomologacaoSerie NFCeHomologacaoSerie,
	NFCeAmbProducaoNumero NFCeProducaoNumero, NFCeAmbProducaoSerie NFCeProducaoSerie, CSC NFCeProducaoCSC, CSCID NFCeProducaoCSCID,	
	ParcelasNFCe NFCeParcelas, ImprimeNFCe NFCeImprime, QrCodeNoXML,
	ValidaDigest,
	ChaveAcessoValidador, EntradaContingencia ContingenciaEntrada, ContigenciaTipo ContingenciaTipo,
	InfoResponsavelTecnico,Cert_SSLLib, Cert_CryptLib, Cert_HttpLib, Cert_XMLSignLib, Cert_SSLType, WebServiceTimeOut
FROM ComputadoresConfigFiscal;
GO