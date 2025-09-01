GO

/****** Object:  View [dbo].[vwUnidades]    Script Date: 28/06/2023 09:53:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwUnidades] AS
SELECT Código UnidadeID, Nome UnidadeNome, Sigla UnidadeSigla, DataDaInclusão Inclusao, DataDeEdição Edicao, Regras, Status, Ativo, RegimeTributario, PISAliquota, COFINSAliquota, CNPJ, ApuraIPI, IDUnidadeMosaico,  Fidelizador, FidelidadeProvedorId, IdentificacaoDaMaquina, CodigoDoCliente, CodigoDaLoja, WebUsuario, WebSenha, Município MunicipioID, IE, IM, GrupoUnidadeID, RazãoSocial RazaoSocial, UF, ImagemCaminhoLogo, CodigoPais, Pais, Endereço Endereco, Complemento, Número Numero, Bairro, Cidade, CEP, PixToken
FROM Unidades;
GO


