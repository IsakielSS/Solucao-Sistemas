ALTER VIEW [Mosaico].[ComputadorFiscal]
AS
SELECT        ComputadoresConfigFiscalID AS ID, Inclusao, Edicao, Status, ComputadorID, CertNumeroDeSerie AS CertificadoNS, DANFE, FormaEmissao, CaminhoLogomarca AS LogomarcaCaminho, SalvarEnvioResposta, PathSalvar, 
                         WebServiceUF, WebServiceAmbiente, WebServiceVisualizar, AmbHomologacaoNumero AS HomologacaoNumero, AmbHomologacaoSerie AS HomologacaoSerie, AmbProducaoNumero AS ProducaoNumero, 
                         AmbProducaoSerie AS ProducaoSerie, DadosComplementares, ParcelasNFE AS NFeParcelas, ImprimirNFe AS NFeImprime, NFSeAmbHomologacaoLote AS NFSeHomologacaoLote, 
                         NFSeAmbHomologacaoRPS AS NFSeHomologacaoRPS, NFSeAmbHomologacaoSerie AS NFSeHomologacaoSerie, NFSeAmbProducaoLote AS NFSeProducaoLote, NFSeAmbProducaoRPS AS NFSeProducaoRPS, 
                         NFSeAmbProducaoSerie AS NFSeProducaoSerie, NFCeAmbHomologacaoNumero AS NFCeHomologacaoNumero, CSCHomologacao AS NFCeHomologacaoCSC, CSCIDHomologacao AS NFCeHomologacaoCSCID, 
                         NFCeAmbHomologacaoSerie AS NFCeHomologacaoSerie, NFCeAmbProducaoNumero AS NFCeProducaoNumero, NFCeAmbProducaoSerie AS NFCeProducaoSerie, CSC AS NFCeProducaoCSC, CSCID AS NFCeProducaoCSCID, 
                         ParcelasNFCe AS NFCeParcelas, ImprimeNFCe AS NFCeImprime, QrCodeNoXML, ValidaDigest, ChaveAcessoValidador, EntradaContingencia AS ContingenciaEntrada, ContigenciaTipo AS ContingenciaTipo, 
                         InfoResponsavelTecnico, Cert_SSLLib, Cert_CryptLib, Cert_HttpLib, Cert_XMLSignLib, Cert_SSLType, WebServiceTimeOut, NFCeVersao
FROM            dbo.ComputadoresConfigFiscal

GO