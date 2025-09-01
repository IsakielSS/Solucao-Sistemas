ALTER TABLE unidades ADD tokenbrconsult VARCHAR(100);

ALTER view [dbo].[vwUnidades] as
select código unidadeid, nome unidadenome, sigla unidadesigla, datadainclusão inclusao, datadeedição edicao, regras, status, ativo, regimetributario, pisaliquota, cofinsaliquota, cnpj, apuraipi, idunidademosaico,  fidelizador, fidelidadeprovedorid, identificacaodamaquina, codigodocliente, codigodaloja, webusuario, websenha, município municipioid, ie, im, grupounidadeid, razãosocial razaosocial, uf, imagemcaminhologo, codigopais, pais, endereço endereco, complemento, número numero, bairro, cidade, cep, pixtoken, tokenbrconsult
from unidades;

GO


ALTER TABLE unidades ADD tokenbrconsult VARCHAR(100);

ALTER view [dbo].[vwUnidades] as
select código unidadeid, nome unidadenome, sigla unidadesigla, datadainclusão inclusao, datadeedição edicao, regras, status, ativo, regimetributario, pisaliquota, cofinsaliquota, cnpj, apuraipi, idunidademosaico,  fidelizador, fidelidadeprovedorid, identificacaodamaquina, codigodocliente, codigodaloja, webusuario, websenha, município municipioid, ie, im, grupounidadeid, razãosocial razaosocial, uf, imagemcaminhologo, codigopais, pais, endereço endereco, complemento, número numero, bairro, cidade, cep, pixtoken, tokenbrconsult
from unidades;

GO
