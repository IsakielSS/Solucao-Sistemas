ALTER FUNCTION [dbo].[fn_FormasDePagamento2]()
RETURNS @FormasDePagamento
TABLE
	(
		FormaDePagamentoID SMALLINT,
		FormaDePagamentoNome VARCHAR(60),
		FormaDePagamentoSigla VARCHAR(5),
		Inclusao DATETIME,
		Edicao DATETIME,
		Status SMALLINT,
		Regras INT,
		Ativo BIT,
		Especie SMALLINT,
		CartaoRede SMALLINT,
		CartaoAdministradora SMALLINT,
		Natureza SMALLINT,
		Parcelas SMALLINT,
		ParcelasEntrada BIT,
		ParcelasDias SMALLINT,
		ParcelasDias2 SMALLINT,
		TEF BIT,
		TEFTipoDeTransacao SMALLINT,
		ViasAdicionais SMALLINT,
		Assinatura BIT,
		Troco BIT,
		Taxa MONEY,
		FornecedorID INT,
	    PIX BIT
	)
AS
BEGIN
	DECLARE
		@FormaDePagamentoID SMALLINT,
		@FormaDePagamentoNome VARCHAR(60),
		@FormaDePagamentoSigla VARCHAR(5),
		@Inclusao DATETIME,
		@Edicao DATETIME,
		@Regras INT,
		@Status SMALLINT,
		@Ativo BIT,
		@Especie SMALLINT,
		@CartaoRede SMALLINT,
		@CartaoAdministradora SMALLINT,
		@Natureza SMALLINT,
		@Parcelas SMALLINT,
		@ParcelasEntrada BIT,
		@ParcelasDias SMALLINT,
		@ParcelasDias2 SMALLINT,
		@TEF BIT,
		@TEFTipoDeTransacao SMALLINT,
		@ViasAdicionais SMALLINT,
		@Assinatura BIT,
		@Troco BIT,
		@Taxa MONEY,
		@FornecedorID INT,
		@PIX BIT;
	DECLARE C CURSOR FOR
		SELECT
			Código FormaDePagamentoID,
			Descrição FormaDePagamentoNome,
			Sigla FormaDePagamentoSigla,
			DataDaInclusão Inclusao,
			DataDeEdição Edicao,
			Status Status,
			Regras Regras,
			Ativo Ativo,
			Espécie Especie,
			Rede Cartao_Rede,
			Administradora CartaoAdministradora,
			Troco Troco,
			Taxa Taxa,
			Fornecedor FornecedorID
		FROM FormasDePagamento;
	OPEN C;
	WHILE (0 = 0)
	BEGIN
		FETCH NEXT FROM C INTO
			@FormaDePagamentoID,
			@FormaDePagamentoNome,
			@FormaDePagamentoSigla,
			@Inclusao,
			@Edicao,
			@Status,
			@Regras,
			@Ativo,
			@Especie,
			@CartaoRede,
			@CartaoAdministradora,
			@Troco,
			@Taxa,
			@FornecedorID;
		IF (@@FETCH_STATUS <> 0)
			BREAK;
		SELECT
			@Edicao = CASE WHEN @Edicao > DataDeEdição THEN @Edicao ELSE DataDeEdição END,
			@Regras = @Regras & ISNULL(Regras, 0),
			@Status = @Status | ISNULL(Status, 0),
			@Natureza = Natureza,
			@Parcelas = Parcelas,
			@ParcelasEntrada = Entrada,
			@ParcelasDias = Dias,
			@ParcelasDias2 = Dias2,
			@TEF = TEF,
			@PIX = PIX,
			@TEFTipoDeTransacao = TEF_TipoDeTransação,
			@ViasAdicionais = ViasAdicionais,
			@Assinatura = Assinatura
		FROM PlanosDePagamento
		WHERE FormaDePagamento = @FormaDePagamentoID
		ORDER BY Natureza DESC;
		IF (@@ROWCOUNT > 0)
		BEGIN
			INSERT INTO @FormasDePagamento
			(
				FormaDePagamentoID,
				FormaDePagamentoNome,
				FormaDePagamentoSigla,
				Inclusao,
				Edicao,
				Status,
				Regras,
				Ativo,
				Especie,
				CartaoRede,
				CartaoAdministradora,
				Natureza,
				Parcelas,
				ParcelasEntrada,
				ParcelasDias,
				ParcelasDias2,
				TEF,
				TEFTipoDeTransacao,
				ViasAdicionais,
				Assinatura,
				Troco,
				Taxa,
				FornecedorID,
				PIX
			)
			VALUES
			(
				@FormaDePagamentoID,
				@FormaDePagamentoNome,
				@FormaDePagamentoSigla,
				@Inclusao,
				@Edicao,
				@Status,
				@Regras,
				@Ativo,
				@Especie,
				@CartaoRede,
				@CartaoAdministradora,
				@Natureza,
				@Parcelas,
				@ParcelasEntrada,
				@ParcelasDias,
				@ParcelasDias2,
				@TEF,
				@TEFTipoDeTransacao,
				@ViasAdicionais,
				@Assinatura,
				@Troco,
				@Taxa,
				@FornecedorID,
				@PIX
			);
		END;
	END;
	CLOSE C;
	DEALLOCATE C;
	RETURN;
END;
GO


