ALTER TABLE Clientes ADD Passaporte VARCHAR(30)

ALTER VIEW [Mosaico].[Cliente] AS
SELECT Código ID, Nome, DataDaInclusão Inclusao, DataDeEdição Edicao, Status, Ativo, Senha, Apelido, Unidade EstabelecimentoID, TipoDeCliente ClienteTipoID, PrecoID, Desconto, Endereço Endereco, Número EnderecoNumero, Complemento EnderecoComplemento, Bairro EnderecoBairro, Cidade EnderecoCidade, UF EnderecoUF, CEP EnderecoCEP, Referência EnderecoReferencia, Município MunicipioID, Telefones, FAX, Celulares, eMail, Crédito Credito, Crédito_Diário CreditoDiario, CPF, CNPJ, IE, RazãoSocial RazaoSocial, PaisID, Sexo, DataDeNascimento Nascimento, UID, RFID, Observações Observacoes, Passaporte
FROM Clientes;
GO

ALTER VIEW [dbo].[vwClientes] AS
SELECT Código ClienteID, Nome ClienteNome, DataDaInclusão Inclusao, DataDeEdição Edicao, CodigoFidelidade, Status, Ativo, Senha, Apelido ClienteApelido, Unidade UnidadeID, PrecoID, Desconto, Endereço Endereco, Número EnderecoNumero, Complemento EnderecoComplemento, Bairro EnderecoBairro, Cidade EnderecoCidade, UF EnderecoUF, CEP EnderecoCEP, Município MunicipioID, Referência EnderecoReferencia, Telefones Telefones, FAX, Celulares, eMail, Crédito Credito, CPF, CNPJ, IE, RazãoSocial RazaoSocial, PaisID, Grupo, AgenteCobrador, TipoDeCliente, Contato, PercentualDeDesconto, DiasParaDesconto, PercentualDeMulta, DiasParaMulta, PercentualDeJuros, Crédito_Diário CreditoDiario, Sexo, DataDeNascimento DataNascimento, RG, UID, IndicadorICMS, FormaDePagamentoID, VendedorID Vendedor, Passaporte
FROM Clientes
GO

ALTER TABLE TributacoesOperacoesICMS
ALTER COLUMN TributacaoOperacaoID int;
GO
ALTER TABLE TributacoesOperacoesISS
ALTER COLUMN TributacaoOperacaoID int;
GO
ALTER TABLE TributacoesOperacoesCFOPs
ALTER COLUMN TributacaoOperacaoID int;
