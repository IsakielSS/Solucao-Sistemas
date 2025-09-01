/****** UPDATE CHAVE TENTATIVAS ******/
UPDATE Autorizacao SET ChaveTentativas = 1
GO

/****** REDUÇÃO ARQUIVO DE LOG ******/
DBCC SHRINKFILE(2)
GO

/****** Object:  StoredProcedure [dbo].[sp_Encerra]    Script Date: 13/11/2023 09:35:03 ******/
DROP PROCEDURE [dbo].[sp_Encerra]
GO

/****** Object:  StoredProcedure [dbo].[sp_Encerra]    Script Date: 13/11/2023 09:35:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Encerra]
(
	@Atendimento INT
)
AS
BEGIN
	BEGIN TRANSACTION;
	UPDATE vwLancamentos SET
		Edicao = GETDATE(),
		Emissao = GETDATE(),
		EmissaoConexaoID = 0
	WHERE
		(Emissao IS NULL) AND
		(Atendimento = @Atendimento);
	IF (@@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION;
		RAISERROR('Desculpe, o atendimento %d não possui lançamento pendente.', 16, 11, @Atendimento);	
		RETURN;
	END;
	IF (@@ROWCOUNT > 1)
	BEGIN
		ROLLBACK TRANSACTION;
		RAISERROR('Desculpe, o atendimento %d possui vários lançamentos pendentes.', 16, 11, @Atendimento);	
		RETURN;
	END;
	COMMIT TRANSACTION;
END;
GO


/****** Object:  StoredProcedure [dbo].[sp_Temporizador]    Script Date: 13/11/2023 09:38:57 ******/
DROP PROCEDURE [dbo].[sp_Temporizador]
GO

/****** Object:  StoredProcedure [dbo].[sp_Temporizador]    Script Date: 13/11/2023 09:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Temporizador]
AS
BEGIN
	DECLARE @Temporizador DATETIME;
	SELECT @Temporizador = Temporizador
	FROM vwPublicacoes
	WHERE PublicacaoID = 1;
	IF (ABS(DATEDIFF(mi, GETDATE(), ISNULL(@Temporizador, 0))) < 1)
		RETURN;
	EXEC sp_TemporizadorProcedimentos;
	UPDATE vwPublicacoes SET
		Temporizador = GETDATE()
	WHERE PublicacaoID = 1;
END;
GO


/****** Object:  StoredProcedure [dbo].[sp_Temporizador2]    Script Date: 13/11/2023 09:44:57 ******/
DROP PROCEDURE [dbo].[sp_Temporizador2]
GO

/****** Object:  StoredProcedure [dbo].[sp_Temporizador2]    Script Date: 13/11/2023 09:44:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Temporizador2]
AS
BEGIN
	DECLARE @Temporizador DATETIME;
	SELECT @Temporizador = Temporizador
	FROM vwPublicacoes
	WHERE PublicacaoID = 1;
	IF (ABS(DATEDIFF(mi, GETDATE(), ISNULL(@Temporizador, 0))) < 1)
		RETURN;
	EXEC sp_TemporizadorProcedimentos;
	UPDATE vwPublicacoes SET
		Temporizador = GETDATE()
	WHERE PublicacaoID = 1;
END;
GO


/****** Object:  StoredProcedure [dbo].[sp_TemporizadorProcedimentos]    Script Date: 13/11/2023 09:45:54 ******/
DROP PROCEDURE [dbo].[sp_TemporizadorProcedimentos]
GO

/****** Object:  StoredProcedure [dbo].[sp_TemporizadorProcedimentos]    Script Date: 13/11/2023 09:45:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_TemporizadorProcedimentos]
AS
BEGIN
	DECLARE @LancamentoID BIGINT, @PedidoID BIGINT, @PedidoProdutoID BIGINT;
	DECLARE C CURSOR FOR
	SELECT L.LancamentoID, P.PedidoID, R.PedidoProdutoID
	FROM
		vwLancamentos L JOIN
		vwPedidos P ON P.LancamentoID = L.LancamentoID JOIN
		vwPedidosProdutos R ON P.PedidoID = R.PedidoID
	WHERE
		(L.Emissao IS NULL) AND
		(L.UnidadeID = 1) AND
		(R.BonificacaoConclusao IS NOT NULL) AND
		(R.BonificacaoConclusao < GETDATE());
	OPEN C;
	WHILE (1=1)
	BEGIN
		FETCH NEXT FROM C INTO @LancamentoID, @PedidoID, @PedidoProdutoID;
		IF (@@FETCH_STATUS <> 0)
			BREAK;
		UPDATE vwLancamentos SET
			Edicao = GETDATE()
		WHERE LancamentoID = @LancamentoID;
		UPDATE vwPedidos SET
			Edicao = GETDATE()
		WHERE PedidoID = @PedidoID;
		UPDATE vwPedidosProdutos SET
			Edicao = GETDATE(),
			Bonificacao = NULL
		WHERE PedidoProdutoID = @PedidoProdutoID;
	END;
	CLOSE C;
	DEALLOCATE C;
END;

GO


/****** Object:  StoredProcedure [dbo].[X_SP_Lancamentos_Confere]    Script Date: 13/11/2023 09:47:17 ******/
DROP PROCEDURE [dbo].[X_SP_Lancamentos_Confere]
GO

/****** Object:  StoredProcedure [dbo].[X_SP_Lancamentos_Confere]    Script Date: 13/11/2023 09:47:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[X_SP_Lancamentos_Confere](@Lancamento INT)
AS
BEGIN
	DECLARE @Pedidos_Total MONEY;
	DECLARE @Lancamentos_SubTotal MONEY;
	DECLARE @Lancamentos_Encargos MONEY;
	DECLARE @Lancamentos_Descontos MONEY;
	DECLARE @Lancamentos_ValorDoFrete MONEY;
	DECLARE @Lancamentos_Total MONEY;
	DECLARE @Contas_Total MONEY;
	-- TOTAL DOS LANÇAMENTOS
	SELECT 
		@Lancamentos_SubTotal = ISNULL(SUM(L.ValorDoLançamento), 0),
		@Lancamentos_Encargos = ISNULL(SUM(L.Encargos), 0),
		@Lancamentos_Descontos = ISNULL(SUM(L.Abatimento), 0),
		@Lancamentos_ValorDoFrete = ISNULL(SUM(L.ValorDoFrete), 0),
		@Lancamentos_Total = ISNULL(SUM(L.ValorTotal), 0)
	FROM Lançamentos L
	WHERE
		((L.Código = @Lancamento) OR
		(L.Código IN (SELECT Código FROM Lançamentos WHERE LançamentoOrigem = @Lancamento)))
	-- TOTAL DOS PEDIDOS
	SELECT @Pedidos_Total = ISNULL(SUM(R.PreçoTotal), 0)
	FROM Pedidos P JOIN Pedidos_Produtos R ON P.Código = R.Pedido
	WHERE 
		((P.Lançamento = @Lancamento) OR
		(P.Lançamento IN (SELECT Código FROM Lançamentos WHERE LançamentoOrigem = @Lancamento))) AND
		(P.Natureza = -1) AND
		(R.SubItem = 0)
	-- TOTAL DAS CONTAS
	SELECT @Contas_Total = ISNULL(SUM(C.ValorDaConta), 0)
	FROM Contas C
	WHERE 
		((C.Lançamento = @Lancamento) OR
		(C.Lançamento IN (SELECT Código FROM Lançamentos WHERE LançamentoOrigem = @Lancamento))) AND
		(C.Natureza = +1)
	IF
		(@Pedidos_Total <> @Lancamentos_SubTotal) OR
		((@Lancamentos_SubTotal + @Lancamentos_Encargos - @Lancamentos_Descontos + @Lancamentos_ValorDoFrete) <> @Contas_Total)
	BEGIN
		DECLARE @Mensagem varchar(250)
		SET @Mensagem = 'SP_Lancamentos_Confere: Não foi possível gravar os dados corretamente.'
		ROLLBACK TRANSACTION
		RAISERROR(@Mensagem, 16, 1)
	END;
END;

GO


/****** VARREDOR DE ÍNDICES ******/

DECLARE @Command VARCHAR(MAX) = '';

SELECT @Command = @Command + 'BEGIN TRY ' +
    'ALTER INDEX [' + ix.name + '] ON [' + sch.name + '].[' + obj.name + '] REORGANIZE; ' +
    'ALTER INDEX [' + ix.name + '] ON [' + sch.name + '].[' + obj.name + '] REBUILD WITH (ONLINE = ON); ' +
    'END TRY ' +
    'BEGIN CATCH ' +
    'PRINT ERROR_MESSAGE(); ' +
    'END CATCH '
FROM sys.indexes AS ix
INNER JOIN sys.objects AS obj ON ix.object_id = obj.object_id
INNER JOIN sys.schemas AS sch ON obj.schema_id = sch.schema_id
WHERE obj.type = 'U' -- Only tables
    AND ix.index_id > 0 -- Non-clustered indexes
    AND ix.is_disabled = 0 -- Enabled indexes
    AND ix.is_hypothetical = 0 -- Real indexes (not hypothetical)

BEGIN TRY
    EXEC(@Command);
END TRY
BEGIN CATCH
    PRINT 'Errors occurred while executing the command.';
    PRINT ERROR_MESSAGE();
END CATCH
GO