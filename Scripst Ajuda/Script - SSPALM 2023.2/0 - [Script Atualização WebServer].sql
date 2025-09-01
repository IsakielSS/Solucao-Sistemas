IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_CreateColumn') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_CreateColumn];

GO


CREATE PROCEDURE sp_CreateColumn(@table VARCHAR(255), @column VARCHAR(255), @type VARCHAR(255), @error VARCHAR(4000) output)
AS
BEGIN
	DECLARE @cmd NVARCHAR(4000);

	SET @error = '';
	IF NOT EXISTS(
		SELECT * FROM SysColumns c WHERE c.id = OBJECT_ID(@table) 
		AND [Name] = @column)
	BEGIN
		BEGIN TRY
			SET @cmd = N'ALTER TABLE [' + @table + '] ADD [' + @column + '] ' + @type;
			EXEC sp_ExecuteSQL @cmd;			
		END TRY
		BEGIN CATCH
			SET @error = ERROR_MESSAGE();
		END CATCH
	END;
END;

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Pedidos') AND c.Name = 'VendedorComissaoValor')
	ALTER TABLE [Pedidos] ADD [VendedorComissaoValor] [SMALLMONEY] NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao001')
	ALTER TABLE [Regras] ADD MobilePermissao001 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao002')
	ALTER TABLE [Regras] ADD MobilePermissao002 BIT NOT NULL DEFAULT(0);

GO


IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao003')
	ALTER TABLE [Regras] ADD MobilePermissao003 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao004')
	ALTER TABLE [Regras] ADD MobilePermissao004 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao005')
	ALTER TABLE [Regras] ADD MobilePermissao005 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao006')
	ALTER TABLE [Regras] ADD MobilePermissao006 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao007')
	ALTER TABLE [Regras] ADD MobilePermissao007 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao008')
	ALTER TABLE [Regras] ADD MobilePermissao008 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao009')
	ALTER TABLE [Regras] ADD MobilePermissao009 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao010')
	ALTER TABLE [Regras] ADD MobilePermissao010 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao011')
	ALTER TABLE [Regras] ADD MobilePermissao011 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao012')
	ALTER TABLE [Regras] ADD MobilePermissao012 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao013')
	ALTER TABLE [Regras] ADD MobilePermissao013 BIT NOT NULL DEFAULT(0);

GO

IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('Regras') AND c.Name = 'MobilePermissao014')
	ALTER TABLE [Regras] ADD MobilePermissao014 BIT NOT NULL DEFAULT(0);

GO


IF NOT EXISTS(SELECT 1 FROM SysObjects WHERE [Name] = 'tb_PALM_Dado')
BEGIN
	EXEC sp_ExecuteSQL N'
		CREATE TABLE [dbo].[tb_PALM_Dado](
			[DadoID] [int] IDENTITY(1,1) NOT NULL,
			[Valores] [varchar](4000) NULL
		); ';
END;

GO

IF NOT EXISTS(SELECT 1 FROM SysObjects WHERE [Name] = 'tb_PALM_Parametro')
BEGIN
	EXEC sp_ExecuteSQL N'
		CREATE TABLE [tb_PALM_Parametro](
			[ParametroID] INT IDENTITY(1,1) NOT NULL,
			[Nome] VARCHAR(255) NOT NULL,
			[Valor] VARCHAR(8000) NOT NULL	
		); ';
END;


GO

DECLARE @type VARCHAR(255), @length INT;
DECLARE @cmd NVARCHAR(4000);

SELECT @type = Type_Name(c.[xtype]), @length = c.[length] FROM SysColumns c WHERE c.id = OBJECT_ID('tb_Palm_Parametro') AND c.name = 'Valor';
SET @type = ISNULL(@type, '')
SET @length = ISNULL(@length, 0);

IF (@type <> '' AND (@type <> 'varchar' OR @length <> 8000))
BEGIN
	SET @cmd = N'ALTER TABLE [tb_PALM_Parametro] ADD [Valor_BKP] VARCHAR(8000); ';
	EXEC sp_ExecuteSQL @cmd;	
	
	SET @cmd = N'UPDATE p SET [Valor_BKP] = [Valor] FROM [tb_PALM_Parametro] p; ';
	EXEC sp_ExecuteSQL @cmd;

	SET @cmd = N'ALTER TABLE [tb_PALM_Parametro] DROP COLUMN [Valor]; ';
	EXEC sp_ExecuteSQL @cmd;
	
	SET @cmd = N'ALTER TABLE [tb_PALM_Parametro] ADD [Valor] VARCHAR(8000); ';	
	EXEC sp_ExecuteSQL @cmd;	
	
	SET @cmd = N'UPDATE p SET [Valor] = [Valor_BKP] FROM [tb_PALM_Parametro] p; ';
	EXEC sp_ExecuteSQL @cmd;
	
	SET @cmd = N'ALTER TABLE [tb_PALM_Parametro] DROP COLUMN [Valor_BKP]; ';
	EXEC sp_ExecuteSQL @cmd;	
	
END;

GO

DECLARE @Unidade INT, @Preco VARCHAR(255);

SELECT @Unidade = Unidade
FROM Produtos_Unidades pu 
GROUP BY Unidade
HAVING COUNT(*) = (SELECT MAX(q.Qtd) FROM (SELECT Unidade, [Qtd] = COUNT(*) FROM Produtos_Unidades pu GROUP BY Unidade) q)

SELECT @Preco = p.PrecoNome 
FROM Precos p 
WHERE p.PrecoID IN 
	(SELECT p1.PrecoID
	FROM ProdutosPrecosDeVenda pv1 INNER JOIN Precos p1 ON pv1.PrecoID = p1.PrecoID 
	GROUP BY p1.PrecoID 
	HAVING COUNT(*) = (SELECT MAX(q1.Qtd) FROM (SELECT p2.PrecoID, [Qtd] = COUNT(*) FROM ProdutosPrecosDeVenda pv2 INNER JOIN Precos p2 ON pv2.PrecoID = p2.PrecoID GROUP BY p2.PrecoID) q1)) 

IF NOT EXISTS(SELECT 1 FROM tb_PALM_Parametro WHERE Nome = 'Unidade')
BEGIN
	INSERT tb_PALM_Parametro(Nome, Valor) VALUES('Unidade', CAST(@Unidade AS VARCHAR(20)));
END;

IF NOT EXISTS(SELECT 1 FROM tb_PALM_Parametro WHERE Nome = 'PrecoNome')
BEGIN	
	INSERT tb_PALM_Parametro(Nome, Valor) VALUES('PrecoNome', @Preco);
END;

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Status')
	ALTER TABLE [Categorias] ADD [Status] [tinyint] NOT NULL DEFAULT (0);

GO

	
IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Apelido')
	ALTER TABLE [Categorias] ADD [Apelido] [varchar](20) NULL;

GO	


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Cor')
	ALTER TABLE [Categorias] ADD [Cor] [int] NULL;

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Prioridade')
	ALTER TABLE [Categorias] ADD [Prioridade] [tinyint] NULL;

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Handheld')
	ALTER TABLE [Categorias] ADD [Handheld] [bit] NULL

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'cfop')
	ALTER TABLE [Categorias] ADD [CFOP] [varchar](4) NULL

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Categorias') AND [Name] = 'Visivel')
	ALTER TABLE [Categorias] ADD [Visivel] [bit] NOT NULL DEFAULT ((1))

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Clientes') AND [Name] = 'ClasseAntiga')
	ALTER TABLE [Clientes] ADD [ClasseAntiga] [VARCHAR](20) NOT NULL DEFAULT('A');

GO


IF NOT EXISTS(SELECT 1 FROM syscolumns c WHERE id = OBJECT_ID('Clientes') AND [Name] = 'ClasseAtual')
	ALTER TABLE [Clientes] ADD [ClasseAtual] [VARCHAR](20) NOT NULL DEFAULT('A');

GO


IF NOT EXISTS(SELECT * FROM Categorias WHERE Visivel = 1)
	UPDATE Categorias SET Visivel = 1, HandHeld = 1, Cor = 0, Prioridade = 0;

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ANDROID_AtendimentosAbertos') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_ANDROID_AtendimentosAbertos];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPrecoDeVenda_PorUnidade') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetPrecoDeVenda_PorUnidade];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ANDROID_VendedorComissao') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_ANDROID_VendedorComissao];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_ConsultaContaWEB') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_ConsultaContaWEB];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Adiantamentos') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Adiantamentos];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Desconto') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Desconto];


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SemMask') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[SemMask];
	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PADL') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[PADL];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_FormatCPF') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_FormatCPF];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_MonthExt') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_MonthExt];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ClearAlpha') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[ClearAlpha];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_FaturadoDia') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_FaturadoDia];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'BinToDec') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[BinToDec];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DecToBin') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[DecToBin];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DecToHex') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[DecToHex];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'HexToDec') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[HexToDec];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'KbdGetSeqAlfa') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[KbdGetSeqAlfa];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_NumRealParts') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_NumRealParts];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_FindValueInAllTables') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_FindValueInAllTables];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EndOfDay') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[EndOfDay];
	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetConfig') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetConfig];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetParamValue') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetParamValue];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Debitos') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_Debitos];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EncodeStr255') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[EncodeStr255];

	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Produtos_Codigo') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_Produtos_Codigo];

GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID('vw_PALM_Cg_Produtos_Todos'))
	DROP VIEW [vw_PALM_Cg_Produtos_Todos];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Cg_ProdutoTipoMontagem') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Cg_ProdutoTipoMontagem];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Cg_Garcons') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Cg_Garcons];	

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Cg_Produtos') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Cg_Produtos];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetNumDays') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetNumDays];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_VendasGarcon') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_VendasGarcon];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_AtendimentoAberto') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_AtendimentoAberto];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Pedido_CheckStatus') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Pedido_CheckStatus];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PALM_Pedido_Incluir') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_PALM_Pedido_Incluir];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_PALM_Pedido_Incluir2') AND [Type] IN ('P', 'PC'))
	DROP PROCEDURE [dbo].[sp_PALM_Pedido_Incluir2];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_PALM_Pedido_Incluir3') AND [Type] IN ('P', 'PC'))
	DROP PROCEDURE [dbo].[sp_PALM_Pedido_Incluir3];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Autenticar2') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_Autenticar2];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Autenticar3') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_Autenticar3];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Garcon_CheckFaturamentoEmData') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Garcon_CheckFaturamentoEmData];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_CheckMeta') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_CheckMeta];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GetUnidadeLocal') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[GetUnidadeLocal];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetLancamentoComissaoVendedor') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetLancamentoComissaoVendedor];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetLancamentoAtendentes') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetLancamentoAtendentes];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Atendimentos') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Atendimentos];	

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Atendimento_CheckTempo') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Atendimento_CheckTempo];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Metas') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Metas];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PALM_Pedido_Listar') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_PALM_Pedido_Listar];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PALM_Conta_Imprimir') AND type in ('P'))
	DROP PROCEDURE [dbo].[sp_PALM_Conta_Imprimir];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_PALM_Conta_Imprimir2') AND [Type] IN ('P', 'PC'))
	DROP PROCEDURE [dbo].[sp_PALM_Conta_Imprimir2];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Categorias') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Categorias];	

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPrecoDeVenda') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetPrecoDeVenda];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_MaxFloat') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_MaxFloat];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_MinFloat') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_MinFloat];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_StrParamValue') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_StrParamValue];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_StrToIntDef') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_StrToIntDef];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PlainText') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[PlainText];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Remoto_Pedidos_Itens') AND type in ('U'))
	DROP TABLE [dbo].[Remoto_Pedidos_Itens];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Remoto_Pedidos') AND type in ('U'))
	DROP TABLE [dbo].[Remoto_Pedidos];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_ObservacoesPre') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_ObservacoesPre];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Atendimento_Credito') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Atendimento_Credito];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Pedido_Listar') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Pedido_Listar];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Atendimento_CheckModalidades') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Atendimento_CheckModalidades];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Autenticar') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_Autenticar];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CriptoStr255') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[CriptoStr255];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Garcon_CheckVendas') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Garcon_CheckVendas];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Garcon_CheckMeta') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Garcon_CheckMeta];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Atendimento_CheckTempo') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Atendimento_CheckTempo];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_FaturadoHoje') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_FaturadoHoje];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_Atendimento_CheckStatus') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_Atendimento_CheckStatus];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetDateAbs') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_GetDateAbs];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_BancoPAF') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_BancoPAF];

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_TxtToTable') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_TxtToTable];


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PADR') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[PADR];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_PedidosTotais') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_PedidosTotais];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_TempoDePermanencia') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_TempoDePermanencia];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_AtendimentosLivres') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_AtendimentosLivres];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_DataHora') AND type in ('V'))
	DROP VIEW [dbo].[vw_DataHora];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_AtendimentosAbertos') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_AtendimentosAbertos];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_PALM_Cg_Atendimentos') AND type in ('V'))
	DROP VIEW [dbo].[vw_PALM_Cg_Atendimentos];

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ZerosEsq') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_ZerosEsq];
	
GO

IF  EXISTS(SELECT * FROM SysObjects WHERE [Id] = OBJECT_ID('vw_PALM_Cg_Opcionais') AND [Type] = 'V')
	DROP VIEW [vw_PALM_Cg_Opcionais];

GO

IF  EXISTS(SELECT * FROM SysObjects WHERE [Id] = OBJECT_ID('vw_PALM_Cg_Clientes') AND [Type] = 'V')
	DROP VIEW [vw_PALM_Cg_Clientes];

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_PALM_VendasCurvaABC') AND type in ('FN', 'IF', 'TF', 'FS', 'FT'))
	DROP FUNCTION [dbo].[fn_PALM_VendasCurvaABC];

GO

IF  EXISTS(SELECT * FROM SysObjects WHERE [Id] = OBJECT_ID('vw_PALM_Cg_AmbientesProdutos') AND [Type] = 'V')
	DROP VIEW [dbo].[vw_PALM_Cg_AmbientesProdutos];

GO

IF  EXISTS(SELECT * FROM SysObjects WHERE [Id] = OBJECT_ID('vw_PALM_Cg_Produtos_Composicoes') AND [Type] = 'V')
	DROP VIEW [dbo].[vw_PALM_Cg_Produtos_Composicoes]
	
GO

CREATE FUNCTION fn_PALM_BancoPAF()
RETURNS BIT
AS
BEGIN
	DECLARE @paf BIT;
	SET @paf = 0;
	IF (SELECT COUNT(*) FROM SysObjects WHERE [Type] = 'U' AND name IN ('Conferencias','OperacoesCFOPs','OperacoesICMS','Lançamentos_Vendas')) = 4
	BEGIN
		SET @paf = 1;
	END
	RETURN @paf;
END;


GO

CREATE FUNCTION [dbo].[fn_PALM_Garcon_CheckMeta](@Garcon INTEGER, @Data DATETIME)
RETURNS NUMERIC(10,2)
AS
BEGIN
	DECLARE @Dia INTEGER, @Valor NUMERIC(10,2)
	SET @Dia = DATEPART(dw, @Data)
	SELECT @Valor =
		(CASE
			WHEN @Dia = 1 THEN Valor_1 
			WHEN @Dia = 2 THEN Valor_2
			WHEN @Dia = 3 THEN Valor_3
			WHEN @Dia = 4 THEN Valor_4
			WHEN @Dia = 5 THEN Valor_5
			WHEN @Dia = 6 THEN Valor_6
			WHEN @Dia = 7 THEN Valor_7
		END) 
	FROM Metas 
	WHERE 
		Fornecedor = @Garcon 
		AND @Data BETWEEN Início AND Conclusão
	SET @Valor = ISNULL(@Valor,0)
	RETURN(@Valor)
END;


GO


CREATE FUNCTION [SemMask](@VALOR varchar(60))
RETURNS varchar(6)
AS
BEGIN
 DECLARE
 @CONTADOR INT,
 @RETORNO varchar(60),
 @VALOR_RET varchar(60)

 SET @CONTADOR = Len(@VALOR)

  LOOP:
  BEGIN
   IF Substring(@VALOR, @CONTADOR,1) IN ('-','/', '(', ')', '\','.') 
    SET @VALOR_RET = @VALOR_RET + null ELSE
    SET @VALOR_RET = @VALOR_RET + SubString(@VALOR, @CONTADOR, 1)
    SET @CONTADOR = @CONTADOR-1
  END
  IF @CONTADOR >= 1 GOTO LOOP
  SET @RETORNO = @VALOR_RET
RETURN @RETORNO
END


GO


CREATE VIEW [vw_DataHora]
AS
SELECT GETDATE() AS [NOW]


GO


CREATE  FUNCTION [PlainText](@S VARCHAR(8000), @KillControlChars BIT)
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @I INT
	DECLARE @LEN INT
	DECLARE @Result VARCHAR(8000)
	DECLARE @C CHAR
	DECLARE @C2 CHAR

	SET @RESULT = ''
	SET @LEN = LEN(@S)
	SET @I = 1
	WHILE @I <= @LEN
	BEGIN
		SET @C = CAST(SUBSTRING(@S, @I, 1) AS CHAR)
			SET @C2 = @C		
			IF (NOT(ASCII(@C2) BETWEEN ASCII('A') AND ASCII('Z'))) AND (NOT(ASCII(@C2) BETWEEN ASCII('a') AND ASCII('z')))
			BEGIN		
				IF @C IN ('À','Æ') SET @C2 = 'A'
				ELSE IF @C = 'Ç' SET @C2 = 'C'
				ELSE IF @C IN ('È','É','Ê','Ë') SET @C2 = 'E'
				ELSE IF @C IN ('Ì','Í','Î','Ï') SET @C2 = 'I'
				ELSE IF @C = 'Ñ' SET @C2 = 'N'
				ELSE IF @C IN ('Ò','Ó','Ô','Ö','Õ','Ø') SET @C2 = 'O'
				ELSE IF @C IN ('Ù','Ú','Û','Ü') SET @C2 = 'U'
				ELSE IF @C = 'Ý' SET @C2 = 'Y'
				ELSE IF @C IN ('à','á','ã','ä','æ') SET @C2 = 'a'
				ELSE IF @C = 'ç' SET @C2 = 'c'
				ELSE IF @C IN ('è','ë','é','ê') SET @C2 = 'e'
				ELSE IF @C IN ('ì','í','î','ï') SET @C2 = 'i'
				ELSE IF @C = 'ñ' SET @C2 = 'n'
				ELSE IF @C IN ('ò','ó','ô','ö','õ') SET @C2 = 'o'
				ELSE IF @C IN ('ù','ú','û','ü') SET @C2 = 'u'
				ELSE IF @C = 'ý' SET @C2 = 'y'
				ELSE IF @C = '°' SET @C2 = 'o'
				ELSE IF @C = 'ª' SET @C2 = 'a'
				ELSE IF (ASCII(@C) > 32) AND (@KillControlChars = 1) SET @C2 = ' '
			END
		SET @RESULT = @RESULT + CAST(@C2 AS VARCHAR(1))
		SET @I = @I + 1
	END
	RETURN(@RESULT)
END

GO

CREATE FUNCTION [PADR](@str varchar(8000), @patern char(1), @len int)
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @chr CHAR(1)
	IF @len > 8000 SET @len = 8000
	IF @len < 0 SET @len = 0
	IF LEN(@str) > @len SET @str = LTRIM(RTRIM(SUBSTRING(@str,1,@len)))
	WHILE LEN(@str) < @len
	BEGIN
		SET @str = @str + char(6)
	END
	SET @str = REPLACE(@str,char(6),@patern)
	RETURN(@str)
END

GO

CREATE FUNCTION [fn_ZerosEsq] (@num VARCHAR(30), @zeros INT) 
RETURNS varchar(30)
AS 
BEGIN
	DECLARE @ret VARCHAR(30)

	SET @ret = @num
	WHILE (LEN(@ret) < @zeros) AND (LEN(@ret) < 30)
	BEGIN
		SET @ret = '0' + @ret		
	END
	RETURN @ret
END

GO

CREATE FUNCTION [PADL](@str VARCHAR(8000), @patern char(1), @len int)
RETURNS VARCHAR(8000)
AS
BEGIN
	IF @len > 8000 SET @len = 8000;
	IF @len < 0 SET @len = 0;
	WHILE (LEN(@str) > @len) AND (@len > 1)
	BEGIN
		SET @str = SUBSTRING(@str,2,len(@str)-1);
	END
	WHILE LEN(@str) < @len
	BEGIN
		SET @str = char(6) + @str;
	END
	SET @str = REPLACE(@str, char(6), @patern);
	RETURN(@str);
END;


GO


CREATE  FUNCTION [CriptoStr255](@S VARCHAR(8000), @Key VARCHAR(255))
RETURNS VARCHAR(8000)
AS
BEGIN
	RETURN(dbo.EncodeStr255(REVERSE(dbo.EncodeStr255(@S, @Key)),@Key));
END;


GO


CREATE FUNCTION [fn_FormatCPF](@cpf float)
RETURNS VARCHAR(14)
AS
BEGIN
	declare @sCPF varchar(14), @nCPF numeric(15,0)

	set @nCPF = @cpf

	set @sCPF = (cast(@nCPF as varchar(14)))

	while(len(@sCPF) < 11)
	begin
		set @sCPF = '0' + @sCPF
	end

	set @sCPF = substring(@sCPF,1,3) + '.' +
		substring(@sCPF,4,3) + '.' + substring(@sCPF,7,3) + 
		'-' + substring(@sCPF,10,2)

	RETURN @sCPF	
END


GO


CREATE FUNCTION [fn_GetDateAbs](@data DATETIME)
RETURNS datetime
BEGIN
	DECLARE @dia VARCHAR(2), @mes VARCHAR(2), @ano VARCHAR(4)

	SET @ano = CAST(YEAR(@data) AS VARCHAR(4))
	SET @mes = CAST(MONTH(@data) AS VARCHAR(2))
	SET @dia = CAST(DAY(@data) AS VARCHAR(2))
	IF LEN(@mes) < 2 
		SET @mes = '0' + @mes
	IF LEN(@dia) < 2 
		SET @dia = '0' + @dia
	
	RETURN CAST((@ano + '-' + @mes + '-' + @dia) AS DATETIME)
END


GO


CREATE FUNCTION [fn_MonthExt](@data datetime,@abrev bit)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @month as integer, @monthext VARCHAR(20)

	SET @month = MONTH(@data)
	SET @monthext = ''

	IF @abrev = 1 
	BEGIN
		SET @monthext = 
			(CASE
	
				WHEN @month = 1 THEN 'Jan'
				WHEN @month = 2 THEN 'Fev'
				WHEN @month = 3 THEN 'Mar'
				WHEN @month = 4 THEN 'Abr'
				WHEN @month = 5 THEN 'Mai'
				WHEN @month = 6 THEN 'Jun'
				WHEN @month = 7 THEN 'Jul'
				WHEN @month = 8 THEN 'Ago'
				WHEN @month = 9 THEN 'Set'
				WHEN @month = 10 THEN 'Out'
				WHEN @month = 11 THEN 'Nov'
				WHEN @month = 12 THEN 'Dez'
				ELSE ''
			 END)
	END
	ELSE
	BEGIN
		SET @monthext = 
			(CASE
	
				WHEN @month = 1 THEN 'Janeiro'
				WHEN @month = 2 THEN 'Fevereiro'
				WHEN @month = 3 THEN 'Março'
				WHEN @month = 4 THEN 'Abril'
				WHEN @month = 5 THEN 'Maio'
				WHEN @month = 6 THEN 'Junho'
				WHEN @month = 7 THEN 'Julho'
				WHEN @month = 8 THEN 'Agosto'
				WHEN @month = 9 THEN 'Setembro'
				WHEN @month = 10 THEN 'Outubro'
				WHEN @month = 11 THEN 'Novembro'
				WHEN @month = 12 THEN 'Dezembro'
				ELSE ''
			 END)
	END
	RETURN(@monthext)
END;


GO


CREATE VIEW [dbo].[vw_PALM_PedidosTotais]
-- old vw_PEDIDOS_Valors
AS
SELECT 
	[Pedido] = P.Código, 
	[Comissão] = ISNULL(P.Comissão,0), 
	[ValorDoPedido] = SUM(ISNULL(R.PreçoTotal, 0)), 
	[ValorDaComissão] = 
		(CASE 
		WHEN dbo.fn_PALM_BancoPAF() = 1 THEN MAX(ISNULL(p.VendedorComissaoValor,0))
		ELSE ROUND(SUM(CASE WHEN (ISNULL(R.Status, 0) & 64) = 0 THEN 0.0 ELSE ISNULL(R.PreçoTotal, 0) END) * (ISNULL(P.Comissão, 0) / 100), 2, 1)				
		END)
FROM dbo.Pedidos P INNER JOIN dbo.Pedidos_Produtos R ON P.Código = R.Pedido
WHERE 
	(P.Natureza <> 0) AND (R.SubItem = 0)
GROUP BY P.Código, P.Comissão


GO


CREATE FUNCTION [fn_TxtToTable] (@pTexto varchar(8000) = NULL, @pSeparador char(1) = '|') 
RETURNS @ARRAY TABLE (ordem VARCHAR(1000), valor VARCHAR(1000))
AS 
BEGIN
	DECLARE @CurrentStr varchar(8000)
	DECLARE @Coluna varchar(200)
    DECLARE @i int

    SET @i = 1
	
	SET @CurrentStr = @pTexto
	 
	WHILE Datalength(@CurrentStr) > 0
	BEGIN
		IF CHARINDEX(@pSeparador, @CurrentStr,1) > 0 
		BEGIN
	    	SET @Coluna = SUBSTRING (@CurrentStr, 1, CHARINDEX(@pSeparador, @CurrentStr,1) - 1)
	    	SET @CurrentStr = SUBSTRING (@CurrentStr, CHARINDEX(@pSeparador, @CurrentStr,1) + 1, (Datalength(@CurrentStr) - CHARINDEX(@pSeparador, @CurrentStr,1) + 1))
			INSERT @ARRAY (ordem,valor) VALUES (@i,@Coluna)
	   	END
		ELSE
		BEGIN                
			INSERT @ARRAY (ordem,valor) VALUES (@i,@CurrentStr)	 		
	    	BREAK;
	    END 
        SET @i = @i + 1
	END
	RETURN
END


GO


CREATE FUNCTION [fn_PALM_AtendimentoAberto](@Unidade INT, @Atendimento INT)
RETURNS BIT
AS
BEGIN
	
	DECLARE @Aberta BIT
	SET @Aberta = 0
	
	SELECT 
		@Aberta = 
		(CASE 
			WHEN ISNULL(Dias, 0) + ISNULL(Horas, 0) + ISNULL(Minutos, 0) + ISNULL(Segundos, 0) > 0 THEN 1
			ELSE 0
		END)
	FROM dbo.fn_PALM_TempoDePermanencia(@Unidade, @Atendimento)
	
	SET @Aberta = ISNULL(@Aberta, 0)

	RETURN(@Aberta)
END


GO


CREATE FUNCTION [ClearAlpha](@Value VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @result VARCHAR(255);
	DECLARE @i INT;
	DECLARE @len INT;	
	DECLARE @c CHAR(1);

	SET @i = 1;
	SET @len = LEN(@value);
	SET @result = '';
	WHILE @i <= @len
	BEGIN
		SET @c = SUBSTRING(@value, @i, 1);
		IF @c IN ('1','2','3','4','5','6','7','8','9','0')
		BEGIN
			SET @result = @result + @c;
		END;
		SET @i = @i + 1;
	END;
	RETURN @result;	
END;


GO


CREATE PROCEDURE [sp_FaturadoDia](@Garcon INTEGER, @Data DATETIME)
AS
BEGIN
	SET @Garcon = 176
	SET @Data = GETDATE()
	SELECT *, dbo.fn_MetasGarcon(@Garcon, @Data) as [Meta] FROM dbo.fn_VendasGarcon(@Garcon, @Data)
END


GO



CREATE FUNCTION [BinToDec](@sin AS VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @x AS INT, @result AS INT

	SET @result = 0
	SET @x = 1
	WHILE @x <= LEN(@sin)
	BEGIN
		SET @result = @result + (CAST(SUBSTRING(@sin, @x, 1) AS INT) * POWER(2, (LEN(@sin) - @x)))
		SET @x = @x + 1
	END
	RETURN @result
END


GO


CREATE FUNCTION [DecToBin](@valor INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @binario VARCHAR(50);

	SET @binario = '';
	WHILE @valor >= 1
	BEGIN	
		SET @binario = CAST((@valor % 2) AS VARCHAR(50)) + @binario;
		SET @valor = @valor / 2;
	END;
	RETURN(@binario);
END


GO


CREATE FUNCTION [DecToHex](@DecNum As BIGINT)
RETURNS VARCHAR(18)
AS
BEGIN
	DECLARE @remainder AS BIGINT, @HexStr AS VARCHAR(50)
	SET @HexStr = '' 

	WHILE @DecNum <> 0
	BEGIN
		SET @remainder = @DecNum % 16
		IF @remainder <= 9
			SET @HexStr = CHAR(ASCII(@remainder)) + @HexStr 
		ELSE 
			SET @HexStr = CHAR(ASCII('A') + @remainder - 10) + @HexStr 	
		SET @DecNum = @DecNum / 16 
	END

	IF @HexStr = '' 
		SET @HexStr = '0' 
	RETURN(@HexStr)

END


GO


CREATE FUNCTION [HexToDec](@HexStr AS VARCHAR(18))
RETURNS BIGINT
AS
BEGIN


	DECLARE @mult AS BIGINT, @DecNum AS BIGINT, @ch AS VARCHAR(50), @i INT
	SET @mult = 1 
	SET @DecNum = 0 


	SET @HexStr = Upper(@HexStr)
	SET @i = Len(@HexStr)

	WHILE @i >= 1
	BEGIN
		SET @ch = SUBSTRING(@HexStr, @i, 1) 
		IF ((@ch >= '0') AND (@ch <= '9'))
		BEGIN
			SET @DecNum = @DecNum + (CAST(@ch AS INT) * @mult) 
		END
		ELSE 
		BEGIN
			IF (@ch >= 'A') AND (@ch <= 'F')
			BEGIN
				SET @DecNum = @DecNum + ((ASCII(@ch) - ASCII('A') + 10) * @mult) 
			END
			ELSE 
			BEGIN
				RETURN(0)
			END
		END
		SET @mult = @mult * 16 
		SET @i = @i - 1
	END
	RETURN(@DecNum)
END


GO


CREATE FUNCTION [KbdGetSeqAlfa](@s VARCHAR(50))
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @i INT;
	DECLARE @c VARCHAR(1);
	DECLARE @r VARCHAR(250);
	SET @r = '%';
	SET @i = 1;
	WHILE (@i <= LEN(@s))
	BEGIN
		SET @c = SUBSTRING(@s, @i, 1);
		IF @c IN ('0','1','2','3','4','5','6','7','8','9','#','*')
		BEGIN
			SET @r = @r +
				(CASE @c 
					WHEN '0' THEN '%[   ]%'
					WHEN '1' THEN '[ABC]'
					WHEN '2' THEN '[DEF]'
					WHEN '3' THEN '[GHI]'
					WHEN '4' THEN '[JKL]'
					WHEN '5' THEN '[MNO]'
					WHEN '6' THEN '[PQR]'
					WHEN '7' THEN '[STU]'
					WHEN '8' THEN '[VWX]'
					WHEN '9' THEN '[YZZ]'					
				END)
			
		END;
		SET @i = @i + 1;
	END;
	SET @r = @r + '%'	
	RETURN(@r);	
END;


GO


CREATE FUNCTION [fn_NumRealParts](@n NUMERIC(10,2))
RETURNS @t TABLE (nA INT, nB INT)
AS
BEGIN

	DECLARE @nA INT, @nB INT;

	SET @nA = 0;
	SET @nB = 0;

	SET @n = ROUND(@n, 2);

	IF (@n > 0)
	BEGIN
		IF (CEILING(@n) = @n)
		BEGIN
			SET @nA = CEILING(@n);
			SET @nB = 0;
		END	
		ELSE
		BEGIN
			SET @nA = CEILING((CEILING(@n)-1));
			SET @nB = CEILING((@n - (CEILING(@n)-1)) * 100);
		END;
	END

	INSERT @t(nA, nB)
	SELECT @nA, @nB
	
	RETURN;
END;


GO


CREATE PROCEDURE [sp_FindValueInAllTables](@filter VARCHAR(2000))
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @cmd  NVARCHAR(2000)
	DECLARE @qtd INT
	DECLARE @table VARCHAR(255), @column VARCHAR(255)

	CREATE TABLE #Result (
		Qtd INT
	)	

	DECLARE c CURSOR FOR
		SELECT 
			o.Name as [Table],
			c.Name as [Column]
		FROM SysObjects o INNER JOIN SysColumns c ON o.ID = c.ID
		WHERE
			o.Type = 'U'
			AND TYPE_NAME(c.xtype) IN ('VARCHAR','CHAR','NVARCHAR','NCHAR')
		ORDER BY o.Name, c.ColId
		
	OPEN c

	FETCH NEXT FROM c INTO @table, @column

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DELETE #Result	

		SET @cmd = 'DECLARE @i INT SELECT @i = COUNT(*) FROM [' + @table + '] WHERE [' + @column + '] LIKE ''%' + @filter + '%'' SELECT @i AS [Qtd] '

		INSERT #Result(Qtd) EXEC sp_ExecuteSQL @cmd
		
		SELECT @Qtd = Qtd FROM #Result

		SET @cmd = @Table + '.' + @column + ': ' + CAST(@Qtd AS VARCHAR(10))

		IF @Qtd > 0
			PRINT @cmd	
		FETCH NEXT FROM c INTO @table, @column
	END

	CLOSE c
	DEALLOCATE c

	DROP TABLE #Result

	SET NOCOUNT OFF

END


GO


CREATE FUNCTION [EndOfDay](@Data DATETIME)
RETURNS DATETIME
AS
BEGIN
	DECLARE @RESULT DATETIME;
	DECLARE @S VARCHAR(30);
	SET @RESULT = ISNULL(@Data, GETDATE());
	SET @S = REPLACE(CONVERT(VARCHAR(10), @RESULT, 111), '/', '-') + ' 00:00:00.000';
	SET @RESULT = CAST(@S AS DATETIME) + 1;
	SET @RESULT = DATEADD(ms, -2, @RESULT);
	RETURN(@RESULT);
END;


GO


CREATE FUNCTION [fn_Produtos_Codigo](@@Codigo VARCHAR(20))
RETURNS
INT
AS
BEGIN
  IF (LEFT(@@Codigo, 1) = '0') AND (LEN(RTRIM(@@Codigo)) <= 7)
  BEGIN
    RETURN 1000 + CAST(RTRIM(@@Codigo) AS INT)
  END
  RETURN 0
END


GO


CREATE FUNCTION [fn_GetPrecoDeVenda](@ProdutoID BIGINT, @PrecoID SMALLINT)
RETURNS MONEY
AS
BEGIN
	DECLARE @Result MONEY;
	IF (ISNULL(@PrecoID, 0) = 0)
		SET @PrecoID = 1;
	SELECT @Result = Preco
	FROM vwProdutosPrecosDeVenda
	WHERE
		(ProdutoID = @ProdutoID) AND
		(PrecoID = @PrecoID);
	RETURN @Result;
END


GO


CREATE FUNCTION [fn_StrParamValue](@Params VARCHAR(2000), @Param VARCHAR(100), @Delimiter CHAR(1))
RETURNS VARCHAR
AS
BEGIN
	DECLARE @I INTEGER, @J INTEGER, @Z INTEGER;
	DECLARE @Dl BIT;
	DECLARE @Result VARCHAR(8000);
  	SET @Param = @Param + '=';
  	SET @J = 1;
  	SET @I = LEN(@Param);
  	SET @Z = LEN(@Params);
  	WHILE (@J <= @Z)
	BEGIN
		IF (SUBSTRING(@Params, @J, @I) = @Param)
    		BEGIN
			SET @J = @J + @I;
			SET @I = @J;
			SET @Dl = 0;
			WHILE ((@I <= @Z) AND ((SUBSTRING(@Params, @I, 1) <> @Delimiter) OR (@Dl = 1)))
			BEGIN
				IF (SUBSTRING(@Params, @I, 1) = '"')
					SET @Dl = @Dl ^ 1;
				SET @I = @I + 1;
			END;
			SET @Result = SUBSTRING(@Params, @J, @I - @J);
			IF (@Result > '')
			BEGIN
				IF (LEFT(@Result, 1) + RIGHT(@Result, 1) = '""')
					SET @Result = SUBSTRING(@Result, 2, LEN(@Result) - 2);
				RETURN @Result;
			END;
		END;
		WHILE (@J <= @Z) AND (SUBSTRING(@Params, @J, 1) <> @Delimiter)
			SET @J = @J + 1;
		SET @J = @J + 1;
	END;
	RETURN '';
END


GO


CREATE FUNCTION [fn_StrToIntDef](@S VARCHAR(20), @DEFAULT INTEGER)
RETURNS INTEGER
AS
BEGIN
	IF (ISNUMERIC(@S) = 1)
		RETURN CONVERT(INTEGER, @S);
	RETURN @DEFAULT;
END


GO


CREATE FUNCTION [fn_MaxFloat](@X FLOAT, @Y FLOAT)
RETURNS FLOAT
AS
BEGIN
	IF (@X < @Y)
		SET @X = @Y;
	RETURN(@X)
END;


GO


CREATE FUNCTION [fn_MinFloat](@X FLOAT, @Y FLOAT)
RETURNS FLOAT
AS
BEGIN
	IF (@X > @Y)
		SET @X = @Y;
	RETURN(@X)
END;


GO


CREATE FUNCTION dbo.GetUnidadeLocal()
RETURNS INT
BEGIN
	DECLARE @Unidade INT;
	SELECT @Unidade = ISNULL((SELECT CAST(Valor AS INT) FROM tb_PALM_Parametro WHERE Nome = 'Unidade'), 1);
	RETURN @Unidade;
END;


GO


CREATE FUNCTION dbo.fn_GetLancamentoComissaoVendedor
(
	@LancamentoID BIGINT,
	@Status SMALLINT
)
RETURNS MONEY
BEGIN
	IF (@LancamentoID < 10000)
	BEGIN
		SELECT @LancamentoID = LancamentoID, @Status = Status
		FROM vwLancamentos
		WHERE
			(Emissao IS NULL) AND
			(Atendimento = @LancamentoID) AND			
			(UnidadeID = dbo.GetUnidadeLocal());
		IF (@LancamentoID IS NULL)
			RETURN 0.00;
	END;
	IF (@Status IS NULL)
		RETURN 0.00;
	IF ((@Status & 64) = 0)
		RETURN 0.00;
	DECLARE @Retorno MONEY;
	SELECT @Retorno = ROUND(SUM(VendedorComissaoValor), 2, 1) 
	FROM vwPedidos
	WHERE
		(LancamentoID = @LancamentoID) AND
		(Natureza = -1);
	SET @Retorno = ISNULL(@Retorno,0);		
	RETURN @Retorno;
END;


GO


CREATE FUNCTION dbo.fn_GetLancamentoAtendentes
(
	@LancamentoID BIGINT
)
RETURNS VARCHAR(500)
BEGIN
	IF (@LancamentoID < 10000)
	BEGIN
		SELECT @LancamentoID = LancamentoID
		FROM vwLancamentos
		WHERE
			(Emissao IS NULL) AND
			(Atendimento = @LancamentoID) AND			
			(UnidadeID = dbo.GetUnidadeLocal());
		IF (@LancamentoID IS NULL)
			RETURN '';
	END;
	DECLARE
		@Retorno VARCHAR(500),
		@Separador VARCHAR(2),
		@Atendente VARCHAR(100);
	SET @Retorno = '';
	SET @Separador = '';
	DECLARE C CURSOR FOR
	SELECT DISTINCT V.PessoaNome AtendenteNome
	FROM
		vwPedidos P
		JOIN vwPessoas V ON V.PessoaID = P.VendedorID
	WHERE
		(P.LancamentoID = @LancamentoID) AND
		(P.Natureza = -1)
	ORDER BY V.PessoaNome;
	OPEN C;
	WHILE (0 = 0)
	BEGIN
		FETCH NEXT FROM C INTO @Atendente;
		IF (@@FETCH_STATUS <> 0)
			BREAK;
		SET @Retorno = @Retorno + @Separador + @Atendente;
		SET @Separador = ', ';
	END;
	CLOSE C;
	DEALLOCATE C;
	RETURN @Retorno;
END;


GO

CREATE FUNCTION [dbo].[fn_PALM_Atendimento_CheckModalidades](@Unidade INT, @Atendimento INT, @AtendimentoDestino INT) 
RETURNS @t TABLE(Status INT, Resultado INT, Mensagem VARCHAR(250))
AS
begin
	DECLARE @Ok BIT, @Result INT, @Mensagem VARCHAR(255), @TipoOrigem INT, @TipoDestino INT;

SELECT Top 1 @TipoOrigem = Tipo FROM vwLancamentos WHERE (Emissao IS NULL) AND (UnidadeID = @Unidade) AND (Atendimento = @Atendimento OR LancamentoID = @Atendimento)
BEGIN
  SET @TipoOrigem = ISNULL(@TipoOrigem, 0);
END;

SELECT Top 1 @TipoDestino = ModalidadeID FROM vwAtendimentos WHERE (UnidadeID = @Unidade) AND (Atendimento = @AtendimentoDestino)
BEGIN
  SET @TipoDestino = ISNULL(@TipoDestino, 0);
END;

  IF (@TipoOrigem in (22, 23)) AND (@TipoDestino in (17,22))
  BEGIN
	SET @Ok = 1
	SET @Result = 1
	SET @Mensagem = 'Impossível transferir do atendimento:'+ CAST(@Atendimento AS VARCHAR(20))+' Para: '+ CAST(@AtendimentoDestino AS VARCHAR(20))
  END
  ELSE
  BEGIN
	SET @Ok = 0
	SET @Result = 0
	SET @Mensagem = 'Atendimento disponivel!'
  END;

INSERT @t(Status, Resultado, Mensagem) VALUES(@Ok, @Result, @Mensagem)
RETURN 
END;

GO

CREATE TABLE [dbo].[Remoto_Pedidos](
	[Código] [int] IDENTITY(1,1) NOT NULL,
	[DataDaInclusão] [smalldatetime] NOT NULL,
	[Status] [int] NOT NULL,
	[Tipo] [tinyint] NOT NULL,
	[Atendimento] [int] NOT NULL,
	[Produto] [int] NULL,
	[Qde] [decimal](10, 4) NULL,
	[Vendedor] [int] NULL,
	[Observacoes] [varchar](2000) NULL,
	[Cliente] [int] NULL,
	[DataDeEdição] [datetime] NULL DEFAULT (GETDATE()),
	[Unidade] [int] NOT NULL,
	[Localização] [int] NULL,
	[Opcionais] [varchar](2000) NULL,
	[QdeHomens] [int] NULL,
	[QdeMulheres] [int] NULL,
	[QdeCriancas] [int] NULL,
	[Remoto_PedidosID] [uniqueidentifier] NULL,
	[Entrega_Nome] [varchar](60) NULL,
	[Entrega_CEP] [int] NULL,
	[Entrega_Endereco] [varchar](30) NULL,
	[Entrega_Numero] [smallint] NULL,
	[Entrega_Complemento] [varchar](20) NULL,
	[Entrega_Bairro] [varchar](20) NULL,
	[Entrega_Cidade] [varchar](20) NULL,
	[Entrega_UF] [varchar](2) NULL,
	[Entrega_Referencia] [varchar](80) NULL,
	[Entrega_Telefones] [varchar](30) NULL,
	[Dinheiro] [money] NULL,
	[Cheque] [money] NULL,
	[CartaoID] [smallint] NULL,
	[CartaoNumero] [varchar](20) NULL,
	[CartaoValidade] [int] NULL,
	[CartaoCS] [smallint] NULL,
	[ClienteUID] [varchar](40) NULL,
	[ClienteNome] [varchar](60) NULL,
	[ClienteCEP] [varchar](8) NULL,
	[ClienteEndereco] [varchar](40) NULL,
	[ClienteNumero] [smallint] NULL,
	[ClienteComplemento] [varchar](20) NULL,
	[ClienteBairro] [varchar](20) NULL,
	[ClienteCidade] [varchar](20) NULL,
	[ClienteUF] [varchar](2) NULL,
	[ClienteReferencia] [varchar](80) NULL,
	[ClienteTelefones] [varchar](120) NULL,
	[Modalidade] [tinyint] NULL,
	[UID] [varchar](40) NULL,
	[AtendimentoDestino] int NULL,
	[ImprimirTransferencia] bit NULL,
	[Pedido] int NULL		
) ON [PRIMARY]

GO


DECLARE @tb VARCHAR(255);
SET @tb = 'Remoto_Pedidos';
EXEC sp_CreateColumn @tb, 'Entrega_Nome', 'VARCHAR(60)', null;
EXEC sp_CreateColumn @tb, 'Entrega_CEP', 'INT', null;
EXEC sp_CreateColumn @tb, 'Entrega_Endereco', 'VARCHAR(30)', null;
EXEC sp_CreateColumn @tb, 'Entrega_Numero', 'SMALLINT', null;
EXEC sp_CreateColumn @tb, 'Entrega_Complemento', 'VARCHAR(20)', null;
EXEC sp_CreateColumn @tb, 'Entrega_Bairro', 'VARCHAR(20)', null;
EXEC sp_CreateColumn @tb, 'Entrega_Cidade', 'VARCHAR(20)', null;
EXEC sp_CreateColumn @tb, 'Entrega_UF', 'VARCHAR(2)', null;
EXEC sp_CreateColumn @tb, 'Entrega_Referencia', 'VARCHAR(80)', null;
EXEC sp_CreateColumn @tb, 'Entrega_Telefones', 'VARCHAR(30)', null;
EXEC sp_CreateColumn @tb, 'Dinheiro', 'money', null;
EXEC sp_CreateColumn @tb, 'Cheque', 'money', null;
EXEC sp_CreateColumn @tb, 'CartaoID', 'smallint', null;
EXEC sp_CreateColumn @tb, 'CartaoNumero', 'varchar(20)', null;
EXEC sp_CreateColumn @tb, 'CartaoValidade', 'int', null;
EXEC sp_CreateColumn @tb, 'CartaoCS', 'smallint', null;
EXEC sp_CreateColumn @tb, 'ClienteUID', 'varchar(40)', null;
EXEC sp_CreateColumn @tb, 'ClienteNome', 'varchar(60)', null;
EXEC sp_CreateColumn @tb, 'ClienteCEP', 'varchar(8)', null;
EXEC sp_CreateColumn @tb, 'ClienteEndereco', 'varchar(40)', null;
EXEC sp_CreateColumn @tb, 'ClienteNumero', 'smallint', null;
EXEC sp_CreateColumn @tb, 'ClienteComplemento', 'varchar(20)', null;
EXEC sp_CreateColumn @tb, 'ClienteBairro', 'varchar(20)', null;
EXEC sp_CreateColumn @tb, 'ClienteCidade', 'varchar(20)', null;
EXEC sp_CreateColumn @tb, 'ClienteUF', 'varchar(2)', null;
EXEC sp_CreateColumn @tb, 'ClienteReferencia', 'varchar(80)', null;
EXEC sp_CreateColumn @tb, 'ClienteTelefones', 'varchar(120)', null;

-- 18/05/2015 15:54 - Solicitado por Tiago Freire em email enviado ao Samuel Barros
EXEC sp_CreateColumn @tb, 'Modalidade', 'tinyint', null;
EXEC sp_CreateColumn @tb, 'UID', 'varchar(40)', null;
EXEC sp_CreateColumn @tb, 'AtendimentoDestino', 'INT', null;
EXEC sp_CreateColumn @tb, 'ImprimirTransferencia', 'bit', null;
EXEC sp_CreateColumn @tb, 'Pedido', 'INT', null;

GO

CREATE TABLE [dbo].[Remoto_Pedidos_Itens](
	[Remoto_Pedidos_ItensID] [int] IDENTITY(1,1) NOT NULL,
	[Remoto_PedidosID] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Produto] [int] NULL,
	[Qtd] [numeric](10, 3) NULL,
	[Observacao] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[Tipo] [varchar](10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO


CREATE VIEW [dbo].[vw_PALM_Cg_ProdutoTipoMontagem]
AS
(
	SELECT 
	   [ProdutoID] = P.ProdutoID, 
	   [ProdutoNome] = dbo.PlainText(P.ProdutoNome, 1),
	   [Produto2ID] = PC.Produto2ID, 
	   [Produto2Nome] = dbo.PlainText(P2.ProdutoNome, 1),
	   [QtdItensDaComposicao] = P.QDEItens,   
	   [QtdParaFechar] = PC.QDE
	FROM 
	   vwProdutosComposicoes PC 
	   JOIN vwProdutos P ON P.ProdutoID = PC.ProdutoID
	   JOIN vwProdutos P2 ON P2.ProdutoID = PC.Produto2ID
	WHERE
	   (P.Ativo = 1)			/************ PRODUTO ATIVO ************/
	   AND (P.Tipo2 = 'C')			/**** SOMENTE PRODUTO DE COMPOSICAO ****/
	   AND (P.Venda = 1)			/*** PRODUTO DISPONÍVEL PARA A VENDA ***/
	   AND (P.Fracionado = 1)	/****** PERMITE VENDER FRACIONADO ******/
	   AND (P.Montagem = 1)			/******** PRODUTO TIPO MONTAGEM ********/
	   AND (PC.Ativo = 1)			/****** PRODUTO COMPOSICAO ATIVO *******/
	   AND (PC.Baixar = 0)		/** BAIXA AUTOMATICAMENTE DO ESTOQUE ***/
	   AND (PC.PrecoZero = 1)	/****** PRODUTO ACEITA PREÇO ZERO ******/
	   AND (PC.Tipo = 15)
	--ORDER BY ProdutoNome, Produto2Nome
);



GO

CREATE  VIEW [vw_PALM_AtendimentosAbertos]
-- old vw_MesasAbertas
AS
SELECT DISTINCT
	l.Unidade as [Unidade],
	l.Atendimento as [Atendimento], 
	l.DataDaInclusão,
	ISNULL(a.CheckIn,0) as [CheckIn],
	(case when (l.status & 32 > 0) then 1 else 0 end) as [Conta_Impressa]
FROM Lançamentos l INNER JOIN Atendimentos a ON l.Atendimento = a.Atendimento
WHERE 
	((l.Unidade = a.Unidade) OR (a.Unidade IS NULL) OR (l.Unidade IS NULL))
	AND (l.datadeemissão is null) 
	AND (l.ConexãoDaEmissão is null)
	AND (l.Atendimento IS NOT NULL)

	
GO

CREATE VIEW [vw_PALM_Cg_Atendimentos]
AS
/**

 [     .CAMPO.     ] [.TAMANHO.] [.FORMATO.]
  UNIDADE..........         5        NNNNN
  ATENDIMENTO......         5        NNNNN
  CHECKIN..........         1            B

**/
SELECT
	Unidade, 
	Atendimento,
	ISNULL(CheckIN,0) AS [CheckIN],
	Ambiente,
	[Vendedor] = ISNULL(Vendedor, 0),
	(
		'#' + dbo.fn_ZerosEsq(Unidade,5) + '#' + /*[ UNIDADE ]*/
			dbo.fn_ZerosEsq(Atendimento,5) + '#' + /*[ ATENDIMENTO ]*/
				(CASE WHEN ISNULL(CheckIN,0) = 1 THEN '1' ELSE '0' END) + '#' /*[ CHECKIN ]*/
	) 
	AS [LINHA]
FROM Atendimentos
WHERE
	(Tipo IN (1,5)) AND (Ativo = 1 OR (Status & 1) = 0)


GO


CREATE FUNCTION [dbo].[fn_PALM_TempoDePermanencia](@Unidade INTEGER, @Atendimento INTEGER)
RETURNS @t TABLE(Dias INTEGER, Horas INTEGER, Minutos INTEGER, Segundos INTEGER, ContaImpressa BIT, Abertura DATETIME)
AS
BEGIN
	DECLARE @D INTEGER, @H INTEGER, @M INTEGER, @S INTEGER, @Tempo DATETIME, @DataHora DATETIME, @ContaImpressa BIT;
	DECLARE @DataOld DATETIME;

	SELECT @DataHora = NOW FROM vw_DataHora;

	IF EXISTS(SELECT * FROM Lançamentos WHERE DataDeEmissão IS NULL AND Atendimento = @Atendimento)
	BEGIN

		SELECT 
			@DataOld = MIN(DataDaInclusão)
		FROM Lançamentos 
		WHERE 
			DataDeEmissão IS NULL 
			AND Atendimento = @Atendimento
			AND ISNULL(Unidade,0) = @Unidade;

		SELECT 
			@Tempo = MIN(@DataHora - DataDaInclusão) 
		FROM Lançamentos 
		WHERE 
			DataDeEmissão IS NULL 
			AND Atendimento = @Atendimento
			AND ISNULL(Unidade,0) = @Unidade;

		SELECT 
			@ContaImpressa = (CASE WHEN (Status & 32 > 0) THEN 1 ELSE 0 END)
		FROM Lançamentos 
		WHERE 
			DataDeEmissão IS NULL 
			AND Atendimento = @Atendimento
			AND ISNULL(Unidade,0) = @Unidade;

		INSERT @T(Dias, Horas, Minutos, Segundos, ContaImpressa, Abertura)
		SELECT DATEPART(DAY, @Tempo) - 1, DATEPART(HOUR, @Tempo), DATEPART(MINUTE, @Tempo), DATEPART(SECOND, @Tempo), @ContaImpressa, @DataOld;
	END;
	RETURN;
END;

GO


CREATE FUNCTION [EncodeStr255](@s VARCHAR(8000), @k VARCHAR(255))
RETURNS VARCHAR(8000)
AS
BEGIN


	DECLARE @JK AS INT, @JS AS INT
	DECLARE @I AS INTEGER, @Lk AS INTEGER
	DECLARE @C AS CHAR
	DECLARE @Result VARCHAR(8000)

	DECLARE @Pantera_Key VARCHAR(255)
	SET @Pantera_Key = '12371233144'


	IF @K = '' SET @K = @Pantera_Key
	SET @Result = ''
	SET @Lk = LEN(@K)

	SET @I = 1
	WHILE @I <= LEN(@S)
	BEGIN

		SET @C = CAST(UPPER(SUBSTRING(@K, ((@I%@Lk)+1), 1)) AS CHAR)

		SET @C = dbo.PlainText(@C,0)
		SET @Jk = 0
		IF ASCII(@C) BETWEEN ASCII('0') AND ASCII('9')
		BEGIN
			SET @Jk = ASCII(@C) - ASCII('0')
		END
		ELSE IF ASCII(@C) BETWEEN ASCII('A') AND ASCII('Z')
		BEGIN
			SET @Jk = ASCII(@C) - ASCII('A') + 10
		END
		ELSE
		BEGIN
			SET @Jk = 0
		END

		SET @Js = ASCII(CAST(SUBSTRING(@S, @I, 1) AS CHAR))

		IF NOT((@Jk ^ @Js) = 0)
			SET @Result = @Result + '' + ISNULL(CHAR(@Jk ^ @Js),'')
		
		SET @I = @I + 1
	END


	RETURN(@Result)
END


GO

CREATE  FUNCTION [dbo].[fn_PALM_Pedido_CheckStatus](@pUnidade INT, @pAtendimento INT, @VerTotal BIT, @VerComissao BIT)
RETURNS @Pedidos TABLE(Unidade INT,	Atendimento INT, Tipo CHAR(1), Codigo INT, Descricao VARCHAR(100), Qde NUMERIC(10,2), UN VARCHAR(10), Total NUMERIC(10,2),	Linha VARCHAR(400))
AS
/**

	DATA DE CRIAÇÃO: 20/08/2008 17:50h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: checa os valores totais dos pedidos

	HISTÓRICO:
	
	07/05/2014: Adaptado para funcionar com o PAF
		Campos Checados:
		1. ((L.Status % 2) = 0)
			- Para não exibir pedidos que foram excluídos em uma exclusão completa de todo o atendimento
		2. ISNULL(CAST(ROUND(SUM(P.VendedorComissaoValor),2,1) AS NUMERIC(10,2)),0)
			- Para obter o valor da comissão do lugar atualmente sendo utilizado
		3. (R.Fator > 0)
			- Para não exibir pedidos cancelados

**/
BEGIN
	INSERT @Pedidos(Unidade, Atendimento, Tipo, Codigo, Descricao, Qde, UN, Total)
	SELECT 
		L.Unidade, 
		L.Atendimento,
		'P' as [Tipo],
		R.Produto as [Codigo], 
		Pr.Descrição AS Descricao, 
		CAST(ROUND(SUM(R.QDE),2) AS NUMERIC(10,2)) AS Qde, 
		Pr.UNE AS UN, 
		CAST(ROUND(SUM(R.PreçoTotal),2) AS NUMERIC(10,2)) AS Total
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
	WHERE 
		(L.DataDeEmissão IS NULL) 
		AND ((L.Atendimento = @pAtendimento AND L.Unidade = @pUnidade) OR @pAtendimento = 0) 
		AND (L.Atendimento IS NOT NULL)
		AND ((L.Status % 2) = 0)
		AND (P.Natureza = -1) 
		AND (R.SubItem = 0)
		AND (R.Fator > 0)
	GROUP BY L.Unidade, L.Atendimento, R.Produto, Pr.Descrição, Pr.UNE;

	IF @vercomissao = 1
	BEGIN
		INSERT @pedidos(Unidade, Atendimento, Tipo, Codigo, Descricao, Qde, UN, Total)
		SELECT 
			L.Unidade,
			L.Atendimento,
			'C' AS [Tipo], 
			0 as [Codigo],
			'COMISSÃO' as [Descricao],
			COUNT(*) as [Qde],
			'' as [UN],	
			ISNULL(CAST(ROUND(SUM(P.VendedorComissaoValor),2,1) AS NUMERIC(10,2)),0) as [Total]
		FROM (Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) 
		WHERE 
			(L.DataDeEmissão IS NULL) 
			AND ((L.Atendimento = @pAtendimento AND L.Unidade = @pUnidade) OR @pAtendimento = 0) 
			AND (L.Atendimento IS NOT NULL)
			AND ((L.Status % 2) = 0)			
			AND (P.Natureza = -1)
			AND EXISTS(SELECT * FROM Pedidos_Produtos PP WHERE PP.Pedido = P.Código AND PP.Fator > 0)
		GROUP BY L.Unidade, L.Atendimento;
	END;

	IF @vertotal = 1
	BEGIN
		INSERT @pedidos(Unidade, Atendimento, Tipo, Codigo, Descricao, Qde, UN, Total)
		SELECT 
			L.Unidade, 
			L.Atendimento,
			'T' as [Tipo],
			0 as [Codigo], 
			'TOTAL' AS Descricao, 
			CAST(ROUND(SUM(R.QDE),2) AS NUMERIC(10,2)) AS Qde, 
			'' AS UN, 
			CAST(ROUND(SUM(R.PreçoTotal),2) AS NUMERIC(10,2)) AS Total
		FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
		WHERE 
			(L.DataDeEmissão IS NULL) 
			AND ((L.Atendimento = @pAtendimento AND L.Unidade = @pUnidade) OR @pAtendimento = 0) 
			AND (L.Atendimento IS NOT NULL)
			AND (P.Natureza = -1) 
			AND ((L.Status % 2) = 0)			
			AND (R.SubItem = 0)
			AND (R.Fator > 0)			
		GROUP BY L.Unidade, L.Atendimento;
	END;

	IF ((SELECT count(*) FROM @Pedidos) = 0)
	BEGIN
		INSERT @Pedidos(Unidade, Atendimento, Tipo, Codigo, Descricao, Qde, UN, Total)
		VALUES(@pUnidade, @pAtendimento, 'T', 0, 'TOTAL', 0, '', 0);
	END;

	UPDATE @Pedidos
	SET Linha = 
		Tipo + '#' +
		dbo.fn_ZerosEsq(Unidade, 5) + '#' +
		dbo.fn_ZerosEsq(Atendimento, 5) + '#' +		
		dbo.fn_ZerosEsq(Codigo, 6) + '#' +
		dbo.PadR(Descricao, ' ', 100) + '#' +
		dbo.fn_ZerosEsq(Qde, 8) + '#' +
		dbo.PadR(UN, ' ', 3) + '#' +		
		dbo.fn_ZerosEsq(Total, 8) + '$';

	RETURN;
END;

-- SELECT * FROM dbo.fn_PALM_Pedido_CheckStatus(1,1,1,1)


GO


CREATE VIEW [vw_PALM_Cg_Garcons]
AS
/**

 [     .CAMPO.     ] [.TAMANHO.] [.FORMATO.]
  CÓDIGO...........         5        NNNNN     
  NOME.............        50     ********
  SENHA............        50     ********


**/
SELECT 
	[Código]	= f.Código, 
	[Nome]	 	= f.Nome, 
	[Senha]	 	= f.Senha,
	[Linha]	 	=
	    (
		    '#' + dbo.fn_ZerosEsq(f.Código,5) + '#' + /*[ CÓDIGO ]*/
			    CAST(ISNULL(f.Nome,'') AS CHAR(50)) + '#' + /*[ NOME ]*/
				    CAST(ISNULL(f.Senha,'') AS CHAR(50)) + '#' /*[ SENHA ]*/
	    ) 
	
FROM Fornecedores f
WHERE
	(f.Nome = 'ADMIN' OR (ISNULL(f.Vendedor, 0) = 1 AND f.Ativo = 1));

	
GO

CREATE VIEW [dbo].[vw_PALM_Cg_Produtos]
AS
/**

 [     .CAMPO.     ] [.TAMANHO.] [.FORMATO.]
  CÓDIGO...........         5        NNNNN     
  DESCRIÇÃO........        50     ********
  PREÇO DE VENDA...         7      NNNN.NN
  COMISSIONADO.....         1            B
  FRACIONADO.......         1            B

**/
SELECT 
	[Produto] = p.Código,
	[Nome] = p.Descrição,
	[Preco] = ISNULL(dbo.fn_GetPrecoDeVenda(p.Código,1),0),
	[Comissionado] = p.Comissionado,
	[Fracionado] = p.Fracionado,
	[Categoria] = p.Categoria,
	[Montagem] = (CASE WHEN m.ProdutoID IS NOT NULL THEN 1 ELSE 0 END),
	(
		'#' + dbo.fn_ZerosEsq(Código,5) + '#' + /*[ CÓDIGO ]*/
			cast(isnull(Descrição,'') as char(50)) + '#' + /*[ DESCRIÇÃO ]*/
				dbo.fn_ZerosEsq(cast(ISNULL(ISNULL(p.PreçoDeVenda, pv.Preco), 0) as varchar(7)),7) + '#' + /*[ PREÇO DE VENDA ]*/
					(case isnull(Comissionado,0) when 1 then '1' else '0' end) + '#' + /*[ COMISSIONADO ]*/
						(case isnull(Fracionado,0) when 1 then '1' else '0' end) + '#' + /*[ FRACIONADO ]*/
							dbo.fn_ZerosEsq(Categoria,5) + '#' /*[ CATEGORIA ]*/
	) 
	AS [Linha]
FROM
	Produtos p INNER JOIN ProdutosPrecosDeVenda pv ON p.Código = pv.ProdutoID
	INNER JOIN Precos pr ON pv.PrecoID = pr.PrecoID	
	LEFT JOIN vw_PALM_Cg_ProdutoTipoMontagem m ON p.Código = m.ProdutoID
WHERE
	p.Código IN (SELECT pu.Produto FROM Produtos_Unidades pu WHERE pu.Unidade = (SELECT CAST(Valor AS INT) FROM tb_PALM_Parametro WHERE Nome = 'Unidade'))
	AND pr.PrecoNome = (SELECT Valor FROM tb_PALM_Parametro WHERE Nome = 'PrecoNome')
	AND p.Ativo = 1
	AND p.Disponível = 1
	AND p.Código IN (
		SELECT P.ProdutoID FROM vwProdutos P JOIN vwProdutosUnidades U ON U.ProdutoID = P.ProdutoID 
		WHERE P.Ativo = 1 AND u.UnidadeID = dbo.GetUnidadeLocal()	
	)	

GO


CREATE FUNCTION [fn_GetNumDays](@DayOfWeek int, @DateBegin DateTime, @DateEnd DateTime)
RETURNS INT
BEGIN
	DECLARE @i INT, @num INT
	SET @i = 0
	SET @num = 0
	IF dbo.fn_GetDateAbs(@DateBegin) < dbo.fn_GetDateAbs(@DateEnd)
	BEGIN
		WHILE (dbo.fn_GetDateAbs(@DateBegin) + @i) < dbo.fn_GetDateAbs(@DateEnd)
		BEGIN
			IF DATEPART(WEEKDAY,(dbo.fn_GetDateAbs(@DateBegin) + @i)) = @DayOfWeek
			BEGIN
				SET @num = @num + 1
			END
			SET @i = @i + 1	
		END	
	END
	RETURN @num
END


GO


CREATE FUNCTION [fn_VendasGarcon](@Garcon INTEGER, @Data DATETIME)
RETURNS @Vendas TABLE(Código INTEGER, Nome VARCHAR(100), QDE INTEGER, TotalVendido NUMERIC(15,4), TotalComissao NUMERIC(15,4))
BEGIN

	DECLARE @DataInicial DATETIME, @DataFinal DATETIME

	SET @DataInicial = dbo.fn_GetDateAbs(@Data)
	SET @DataFinal = dateadd(ms, -2, dbo.fn_GetDateAbs(@Data))

	INSERT @Vendas(Código, Nome, QDE, TotalVendido, TotalComissao)	
	SELECT V.Código AS Código, V.Nome AS Nome, COUNT(*) AS QDE, SUM(PV.ValorDoPedido) AS TotalVendido, SUM(CASE WHEN (L.Status  &  64) > 0 THEN PV.ValorDaComissão ELSE 0.00 END ) AS TotalComissão
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) LEFT JOIN Fornecedores V ON ISNULL(P.Vendedor, 0) = V.Código) LEFT JOIN vw_Pedidos_Valores PV ON P.Código = PV.Pedido
	WHERE 
		((L.DataDeEmissão IS NULL) OR (L.DataDeEmissão BETWEEN @DataInicial AND @DataFinal)) 
		AND NOT (((L.Status  &  1)) > 0) AND (L.Tipo BETWEEN 16 AND 64) AND (P.Natureza = -1)
		AND V.Código = @Garcon
	GROUP BY V.Código, V.Nome
	ORDER BY V.Nome
	RETURN
END


GO


CREATE  VIEW [vw_PALM_FaturadoHoje]
AS
SELECT V.Código AS Código, V.Nome AS Nome, COUNT(*) AS QDE, SUM(PV.ValorDoPedido) AS TotalVendido, SUM(CASE WHEN (L.Status  &  64) > 0 THEN PV.ValorDaComissão ELSE 0.00 END ) AS TotalComissão
FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) LEFT JOIN Fornecedores V ON ISNULL(P.Vendedor, 0) = V.Código) LEFT JOIN vw_PALM_PedidosTotais PV ON P.Código = PV.Pedido
WHERE 
	((L.DataDeEmissão IS NULL) OR (L.DataDeEmissão BETWEEN dbo.fn_GetDateAbs(GETDATE()) AND dateadd(ms, -2, dbo.fn_GetDateAbs(GETDATE())))) 
	AND NOT (((L.Status  &  1)) > 0) AND (L.Tipo BETWEEN 16 AND 64) AND (P.Natureza = -1)
GROUP BY V.Código, V.Nome


GO


CREATE FUNCTION [dbo].[fn_PALM_Garcon_CheckVendas](@Garcon INTEGER, @Data DATETIME)
RETURNS @Vendas TABLE(Código INTEGER, Nome VARCHAR(100), QDE INTEGER, TotalVendido NUMERIC(15,4), TotalComissao NUMERIC(15,4))
BEGIN

	DECLARE @DataInicial DATETIME, @DataFinal DATETIME

	SET @DataInicial = dbo.fn_GetDateAbs(@Data)
	SET @DataFinal = dateadd(ms, -2, dbo.fn_GetDateAbs(@Data))+1

	INSERT @Vendas(Código, Nome, QDE, TotalVendido, TotalComissao)	
SELECT 
	Código,
	Nome,
	[Qde] = SUM(Qde),
	[TotalVendido] = SUM(TotalVendido),
	[TotalComissao] = SUM(TotalComissão)
FROM
	(SELECT V.Código AS Código, V.Nome AS Nome, 1 AS QDE, PV.ValorDoPedido AS TotalVendido, 0 AS TotalComissão
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) 
		LEFT JOIN Fornecedores V ON ISNULL(P.Vendedor, 0) = V.Código) LEFT JOIN vw_PALM_PedidosTotais PV ON P.Código = PV.Pedido
	WHERE 
		((L.DataDeEmissão IS NULL) OR (L.DataDeEmissão BETWEEN @DataInicial AND @DataFinal)) 
		AND NOT (((L.Status  &  1)) > 0) AND (L.Tipo BETWEEN 16 AND 64) AND (P.Natureza = -1)
		AND V.Código = @Garcon
		AND EXISTS (
			SELECT pp.Pedido FROM Pedidos_Produtos pp INNER JOIN Produtos pr ON pp.Produto = pr.Código
			WHERE pp.Pedido = p.Código AND pr.Tipo != 'X'
		)
	UNION
	SELECT V.Código AS Código, V.Nome AS Nome, 0 AS [Qde], 0 AS TotalVendido, PV.ValorDoPedido AS TotalComissão
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) 
		LEFT JOIN Fornecedores V ON ISNULL(P.Vendedor, 0) = V.Código) LEFT JOIN vw_PALM_PedidosTotais PV ON P.Código = PV.Pedido
	WHERE 
		((L.DataDeEmissão IS NULL) OR (L.DataDeEmissão BETWEEN @DataInicial AND @DataFinal)) 
		AND NOT (((L.Status  &  1)) > 0) AND (L.Tipo BETWEEN 16 AND 64) AND (P.Natureza = -1)
		AND V.Código = @Garcon
		AND EXISTS (
			SELECT pp.Pedido FROM Pedidos_Produtos pp INNER JOIN Produtos pr ON pp.Produto = pr.Código
			WHERE pp.Pedido = p.Código AND pr.Tipo = 'X'
		)) AS re
	GROUP BY re.Código, re.Nome
	ORDER BY re.Nome
	RETURN
END;


GO


CREATE FUNCTION [dbo].[fn_PALM_Pedido_Listar](@Unidade INT, @Atendimento INT, @VerTotal BIT, @VerComissao BIT)
RETURNS @Pedidos TABLE(
			Tipo VARCHAR(20), 
			Pedido INT,
			PedidoProdutoID INT,
			Item INT,
			Codigo INT, 
			Descricao VARCHAR(100), 
			Qde NUMERIC(10,2), 
			UN VARCHAR(10), 
			Total NUMERIC(10,2))
/**

	DATA DE CRIAÇÃO: 20/08/2008 17:11h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento para listar os pedidos de uma mesa

**/
-- old dbo.sp_MOBILE_ListaPedidos
AS
BEGIN


	INSERT @Pedidos(Tipo, PedidoProdutoID, Pedido, Item, Codigo, Descricao, Qde, UN, Total)
	SELECT 
		'P' as [Tipo],
		R.PedidoProdutoID as [PedidoProdutoID],
		R.Pedido as [Pedido],
		R.Item as [Item],
		R.Produto as [Codigo], 
		Pr.Descrição AS Descricao, 
		CAST(ROUND(SUM(R.QDE),2) AS NUMERIC(10,2)) AS Qde, 
		Pr.UNE AS UN, 
		CAST(ROUND(SUM(R.PreçoTotal),2) AS NUMERIC(10,2)) AS Total
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
	WHERE 
		(L.DataDeEmissão IS NULL) 
		AND (L.Atendimento = @Atendimento) 
		AND (L.Unidade = @Unidade)
		AND (P.Natureza = -1) 
		AND (R.SubItem = 0)
		AND (R.Fator != 0)
	GROUP BY R.PedidoProdutoID, R.Pedido, R.Item, R.Produto, Pr.Descrição, Pr.UNE


	IF @vercomissao = 1
	BEGIN
		INSERT @pedidos(Tipo, Codigo, Descricao, Qde, UN, Total)
		SELECT 
			'C' AS [Tipo], 
			0 as [Codigo],
			'COMISSÃO' as [Descricao],
			COUNT(*) as [Qde],
			'' as [UN],	
			ISNULL(CAST(ROUND(SUM(Pv.ValorDaComissão),2) AS NUMERIC(10,2)),0) as [Total]
		FROM (Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) LEFT JOIN vw_PALM_PedidosTotais Pv ON P.Código = Pv.Pedido
		WHERE 
			(L.DataDeEmissão IS NULL) 
			AND (L.Atendimento = @Atendimento) 
			AND (L.Unidade = @Unidade)
			AND (P.Natureza = -1)

	END

	IF @vertotal = 1
	BEGIN
		INSERT @pedidos(Tipo, Codigo, Descricao, Qde, UN, Total)
		SELECT 
			'T' as [Tipo],
			0 as [Codigo], 
			'TOTAL' AS Descricao, 
			CAST(ROUND(SUM(R.QDE),2) AS NUMERIC(10,2)) AS Qde, 
			'' AS UN, 
			CAST(ROUND(SUM(R.PreçoTotal),2) AS NUMERIC(10,2)) AS Total
		FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
		WHERE 
			(L.DataDeEmissão IS NULL) 
			AND (L.Atendimento = @Atendimento) 
			AND (L.Unidade = @Unidade)
			AND (P.Natureza = -1) 
			AND (R.SubItem = 0)
			AND (R.Fator != 0)
	END

	RETURN
END


GO


CREATE FUNCTION [fn_PALM_ObservacoesPre](@Obs VARCHAR(4000))
RETURNS VARCHAR(4000)
AS
BEGIN
	DECLARE @val VARCHAR(1000)
	DECLARE @msg VARCHAR(1000)
	DECLARE @c VARCHAR(1)
	DECLARE @i INT
	DECLARE @isnum BIT
	DECLARE @result VARCHAR(4000)

	SET @result = ''

	DECLARE c CURSOR FOR 
		SELECT Valor FROM [dbo].[fn_TxtToTable](@Obs, '|')
	OPEN c
	FETCH NEXT FROM c INTO @val
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @i = 1
		SET @isnum = 1
		SET @Msg = ''
		IF LEN(@val) > 0
		BEGIN
			WHILE @i <= LEN(@val)
			BEGIN
				SET @c = SUBSTRING(@val,@i,1)
				IF NOT(@c IN ('1','2','3','4','5','6','7','8','9','0'))
				BEGIN
					SET @isnum = 0
				END
				SET @i = @i + 1
			END
			IF @isnum = 1
			BEGIN
				SELECT @Msg = Descrição FROM Observações WHERE CAST(Código AS VARCHAR(10)) = @Val
			END
			ELSE
			BEGIN
				SET @Msg = @Val				
			END
			IF LEN(@Msg) > 0
				SET @result = @result + ', ' + @Msg
		END
		FETCH NEXT FROM c INTO @val
	END
	CLOSE c
	DEALLOCATE c

	IF LEN(@result) > 0
	BEGIN
		SET @result = SUBSTRING(@result, 3, 255)
		
	END

	RETURN @result
END


GO


CREATE FUNCTION [fn_GetConfig](@Computador INT, @Chave VARCHAR(255), @ValorPadrao VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @Valor VARCHAR(255)

	IF NOT EXISTS(SELECT * FROM Computadores_Configs WHERE Computador = @Computador AND Chave = @Chave)
	BEGIN
		SET @Valor = @ValorPadrao
	END
	ELSE
	BEGIN
		SELECT @Valor = ValorString FROM Computadores_Configs WHERE Computador = @Computador AND Chave = @Chave
	END
	RETURN @Valor
END


GO


CREATE  FUNCTION [fn_GetParamValue] (@Chave varchar(50), @Computador int, @ValorPadrao varchar(100))  
RETURNS Varchar(100) AS  
BEGIN 
	DECLARE @Retorno varchar(100)
	SELECT @Retorno = Isnull(ValorString,@ValorPadrao) FROM Computadores_Configs WHERE Chave LIKE @Chave and computador = @Computador
	IF @Retorno is null
	BEGIN
		SET @Retorno = @ValorPadrao
	END
	RETURN @Retorno
END


GO


CREATE FUNCTION [fn_Debitos](@Cliente INT)
RETURNS @t TABLE (
	[Lancamento] [int],
	[Conta] [int],
	[Natureza] [int],
	[Historico] [varchar](40),
	[Memorando] [varchar](250),
	[NF] [int],
	[Documento_Numero] [varchar](40),
	[Documento_Banco] [int],
	[DataDeEmissao] [datetime],
	[DataDeVencimento] [datetime],
	[DataDeRecebimento] [datetime],
	[ValorDaConta] [money],
	[FormaDePagamento] [varchar](5),
	[DataDePagamento] [datetime],
	[Acrescimos] [money],
	[Descontos] [money],
	[ValorPago] [money],
	[ContaCorrente] [varchar](40),
	[Status] [int],
	[Parcela] [int],
	[Parcelas] [int],
	[Inclusao] [varchar](60),
	[Baixa] [varchar](60),
	[ChaveId] [int]
) 
AS
BEGIN

	INSERT @t (
		[Lancamento], [Conta], [Natureza], [Historico], [Memorando], [NF], [Documento_Numero],
		[Documento_Banco], [DataDeEmissao], [DataDeVencimento], [DataDeRecebimento], [ValorDaConta],
		[FormaDePagamento], [DataDePagamento], [Acrescimos], [Descontos], [ValorPago], [ContaCorrente],
		[Status], [Parcela], [Parcelas], [Inclusao], [Baixa], [ChaveId])
	SELECT
		[Lancamento] = C.Lançamento, 
		[Conta] = C.Código, 
		[Natureza] = C.Natureza, 
		[Historico] = H.Descrição, 
		[Memorando] = L.Memorando, 
		[NF] = L.NF, 
		[Documento_Numero] = C.Documento, 
		[Documento_Banco] = C.Documento_Banco, 
		[DataDeEmissao] = L.DataDeEmissão, 
		[DataDeVencimento] = C.DataDeVencimento, 
		[DataDeRecebimento] = ISNULL(C.DataDeRecebimento, C.DataDePagamento), 
		[ValorDaConta] = (C.ValorDaConta * ISNULL(NULLIF(C.Natureza, 0), 1)), 
		[FormaDePagamento] = F.Sigla, 
		[DataDePagamento] = C.DataDePagamento, 
		[Acrescimos] = (dbo.fn_Contas_Acrescimos(C.Natureza, C.Status, CONVERT(DATETIME, '2011-04-24 00:00:00.000', 121), C.DataDeVencimento, C.DataDePagamento, C.ValorDaConta, C.Descontos, C.Acréscimos, L.DiasParaMulta, L.PercentualDeMulta, L.PercentualDeJuros) * ISNULL(NULLIF(C.Natureza, 0), 1)), 
		[Descontos] = (dbo.fn_Contas_Descontos(C.Natureza, C.Status, CONVERT(DATETIME, '2011-04-24 00:00:00.000', 121), C.DataDeVencimento, C.DataDePagamento, C.ValorDaConta, C.Descontos, C.Acréscimos, L.DiasParaDesconto, L.PercentualDeDesconto, L.DiasParaDesconto2, L.PercentualDeDesconto2) * ISNULL(NULLIF(C.Natureza, 0), 1)), 
		[ValorPago] = (C.ValorPago * ISNULL(NULLIF(C.Natureza, 0), 1)), 
		[ContaCorrente] = O.Descrição, 
		[Status] = C.Status, 
		[Parcela] = C.Parcela, 
		[Parcelas] = C.Parcelas,
		[Inclusao] = (SELECT Fr.Nome FROM Conexões Cx LEFT JOIN Fornecedores Fr ON Cx.Usuário = Fr.Código WHERE Cx.Código = C.Conexão), 
		[Baixa] = (SELECT Fr.Nome FROM Conexões Cx LEFT JOIN Fornecedores Fr ON Cx.Usuário = Fr.Código WHERE Cx.Código = ISNULL(C.ConexãoDoPagamento, C.ConexãoDoRecebimento)),
		[ChaveId] = CL.Código_Auxiliar
	FROM Lançamentos L JOIN Contas C ON L.Código = C.Lançamento
		JOIN Clientes CL ON L.Cliente = CL.Código
		JOIN Históricos H ON L.Histórico = H.Código 
		JOIN FormasDePagamento F ON C.FormaDePagamento = F.Código 
		LEFT JOIN ContasCorrentes O ON C.ContaCorrente = O.Código
	WHERE 
		(L.Cliente = @Cliente) 
		AND (C.DataDePagamento IS NULL) 
		AND ((C.DataDeVencimento + 1) < GETDATE())
		AND (C.Natureza <> 0)
	ORDER BY L.DataDeEmissão DESC, C.Código;

	RETURN;
END;


GO


CREATE VIEW [vw_PALM_Categorias]
AS
SELECT 
	Código AS [Codigo],
	Descrição AS [Descricao],
	ISNULL(Apelido, Descrição) AS [Apelido],
	ISNULL(Cor,0) AS [Cor],
	ISNULL(Prioridade,0) AS [Prioridade]
FROM Categorias 
WHERE 
	Visivel = 1 
	AND Código IN (SELECT Categoria FROM Produtos WHERE Ativo = 1 AND Disponível = 1)


GO


CREATE FUNCTION [fn_PALM_Atendimento_Credito](@Unidade INT, @Atendimento INT)
RETURNS MONEY
AS
BEGIN

	DECLARE @Credito MONEY
	SET @Credito = 0
	
	SELECT
		@Credito = Crédito
	FROM CHECKINS C 
	WHERE
		C.CÓDIGO IN
	(SELECT
		L.CHECKIN
	FROM LANÇAMENTOS L
	WHERE 
		L.DATADEEMISSÃO IS NULL 
		AND L.TIPO<64
		AND L.Atendimento = @Atendimento
		AND (L.Unidade = @Unidade OR L.Unidade IS NULL)
		AND (L.Atendimento = @Atendimento))
	
	SET @Credito = ISNULL(@Credito, 0)

	RETURN @Credito
END


GO


CREATE FUNCTION [fn_Autenticar](@usuario VARCHAR(50), @senha VARCHAR(50))
RETURNS INTEGER
AS
BEGIN
	DECLARE @res INTEGER
	SET @res = 0

	IF LEN(ISNULL(@senha,'')) > 0 -- não aceitar senha nula
	BEGIN	
		IF (@usuario = 'ADMIN') -- tratamento especial para login admin
		BEGIN
			IF EXISTS(SELECT 1 FROM Fornecedores WHERE nome = @usuario AND senha = @senha) 
			BEGIN
				SELECT @res = Código + 9000000 FROM Fornecedores 
				WHERE nome = @usuario AND senha = @senha
			END
		END
		ELSE IF EXISTS(SELECT 1 FROM Fornecedores WHERE nome = @usuario AND senha = @senha AND Garçon = 1 AND Ativo = 1 AND Vendedor = 1) -- se não for o admin tem que ser garçon e estar ativado
		BEGIN
			IF EXISTS(SELECT 1 FROM Usuários WHERE Código IN (SELECT Usuário FROM Usuários_Regras WHERE Regra IN (SELECT Código FROM Regras WHERE Descrição = 'ADMINISTRADORES')) AND Nome = @usuario AND Senha = @senha)
			BEGIN
				SELECT @res = Código + 9000000 FROM Fornecedores 
				WHERE nome = @usuario AND senha = @senha
			END		
			ELSE
			BEGIN
				SELECT @res = Código FROM Fornecedores 
				WHERE nome = @usuario AND senha = @senha
			END
		END
	END
	RETURN @res
END


GO


CREATE PROCEDURE [sp_PALM_Pedido_Incluir](@Unidade INT, @Atendimento INT, @Garcon INT, @Produto INT, @Qtd NUMERIC(10,4), @Obs VARCHAR(2000), @Local INT, @Status INT OUT, @Msg VARCHAR(100) OUT)
AS
/**

	DATA DE CRIAÇÃO: 20/08/2008 15:57h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento armazenado para incluir um pedido enviado pelo palm

**/
-- old dbo.sp_MOBILE_AddPedido
BEGIN
	DECLARE @t TABLE (Status INT, Msg VARCHAR(100), Linha VARCHAR(100))
	DECLARE @Linha VARCHAR(100)

	SET @obs = dbo.fn_PALM_ObservacoesPre(@obs)

	-- TESTAR O LIMITE DA MESA
	DECLARE @LimiteOk BIT, @Credito MONEY, @TotalConta MONEY, @TotalPedido MONEY

	SET @LimiteOk = 0
	SET @Credito = 0
	SET @TotalConta = 0

	SELECT @Credito = dbo.fn_PALM_Atendimento_Credito(@Unidade, @Atendimento)		
	IF (@Credito > 0)
	BEGIN
		SELECT @TotalConta = ISNULL(Total, 0) FROM dbo.fn_PALM_Pedido_Listar(@Unidade, @Atendimento, 1, 1) as [p] WHERE p.Tipo = 'T'
		SELECT @TotalPedido = (PreçoDeVenda * @Qtd) + (CASE WHEN Comissionado = 1 THEN ((PreçoDeVenda * @Qtd) / 10) ELSE 0 END) FROM Produtos WHERE Código = @Produto

		SET @Credito = ISNULL(@Credito, 0)
		SET @TotalConta = ISNULL(@TotalConta, 0)
		SET @TotalPedido = ISNULL(@TotalPedido, 0) 

		IF (@TotalPedido + @TotalConta) <= @Credito
		BEGIN
			SET @LimiteOk = 1
		END
	END
	ELSE
	BEGIN
		SET @LimiteOk = 1
	END
	-- FIM DO TESTE DO LIMITE

	IF @LimiteOk = 1
	BEGIN
		IF (EXISTS(SELECT * FROM Produtos WHERE Código = @Produto) AND EXISTS(SELECT * FROM Fornecedores WHERE Código = @Garcon))
		BEGIN

			SET @Status = 0  
			SET @Msg = 'Pedido adicionado!'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]

				
			INSERT Remoto_Pedidos(DataDaInclusão, Status, Tipo, Unidade, Atendimento, Produto, Qde, Vendedor, Observacoes, DataDeEdição, Localização)
			VALUES(GETDATE(), 0, 1, @Unidade, @Atendimento, @Produto, @Qtd, @Garcon, @Obs, GETDATE(), @Local)

		END
		ELSE	
		BEGIN
			SET @Status = 2  
			SET @Msg = 'Erro: Pedido inválido.'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	
		END
	END
	ELSE
	BEGIN
		SET @Status = 1  
		SET @Msg = 'O pedido ultrapassa o limite da mesa.'
		SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
		SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	END
END
/* 
	DECLARE @Status BIT, @Msg VARCHAR(100)

	EXEC dbo.sp_PALM_Pedido_Incluir 1, 1, 341, 1, 1, '1|2|3', 1, @Status OUT, @Msg OUT
	SELECT * FROM Remoto_Pedidos
	DELETE Remoto_Pedidos
*/


GO


CREATE PROCEDURE [dbo].[sp_PALM_Pedido_Incluir2](@Unidade INT, @Atendimento INT, @Garcon INT, @Produto INT, @Qtd NUMERIC(10,4), @Obs VARCHAR(2000), @Local INT, @Opcionais VARCHAR(2000), @Status INT OUT, @Msg VARCHAR(100) OUT)
AS
/**

	DATA DE CRIAÇÃO: 20/08/2008 15:57h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento armazenado para incluir um pedido enviado pelo palm

**/
-- old dbo.sp_MOBILE_AddPedido
BEGIN
	DECLARE @t TABLE (Status INT, Msg VARCHAR(100), Linha VARCHAR(100))
	DECLARE @Linha VARCHAR(100)

	SET @obs = dbo.fn_PALM_ObservacoesPre(@obs)

	-- TESTAR O LIMITE DA MESA
	DECLARE @LimiteOk BIT, @Credito MONEY, @TotalConta MONEY, @TotalPedido MONEY

	SET @LimiteOk = 0
	SET @Credito = 0
	SET @TotalConta = 0

	SELECT @Credito = dbo.fn_PALM_Atendimento_Credito(@Unidade, @Atendimento)		
	IF (@Credito > 0)
	BEGIN
		SELECT @TotalConta = ISNULL(Total, 0) FROM dbo.fn_PALM_Pedido_Listar(@Unidade, @Atendimento, 1, 1) as [p] WHERE p.Tipo = 'T'
		SELECT @TotalPedido = (PreçoDeVenda * @Qtd) + (CASE WHEN Comissionado = 1 THEN ((PreçoDeVenda * @Qtd) / 10) ELSE 0 END) FROM Produtos WHERE Código = @Produto

		SET @Credito = ISNULL(@Credito, 0)
		SET @TotalConta = ISNULL(@TotalConta, 0)
		SET @TotalPedido = ISNULL(@TotalPedido, 0) 

		IF (@TotalPedido + @TotalConta) <= @Credito
		BEGIN
			SET @LimiteOk = 1
		END
	END
	ELSE
	BEGIN
		SET @LimiteOk = 1
	END
	-- FIM DO TESTE DO LIMITE

	IF @LimiteOk = 1
	BEGIN
		IF (EXISTS(SELECT * FROM Produtos WHERE Código = @Produto) AND EXISTS(SELECT * FROM Fornecedores WHERE Código = @Garcon))
		BEGIN

			SET @Status = 0  
			SET @Msg = 'Pedido adicionado!'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]

				
			INSERT Remoto_Pedidos(DataDaInclusão, Status, Tipo, Unidade, Atendimento, Produto, Qde, Vendedor, Observacoes, DataDeEdição, Localização, Opcionais)
			VALUES(GETDATE(), 0, 1, @Unidade, @Atendimento, @Produto, @Qtd, @Garcon, @Obs, GETDATE(), @Local, @Opcionais)

		END
		ELSE	
		BEGIN
			SET @Status = 2  
			SET @Msg = 'Erro: Pedido inválido.'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	
		END
	END
	ELSE
	BEGIN
		SET @Status = 1  
		SET @Msg = 'O pedido ultrapassa o limite da mesa.'
		SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
		SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	END
END
/* 
	DECLARE @Status BIT, @Msg VARCHAR(100)

	EXEC dbo.sp_PALM_Pedido_Incluir2 1, 1, 341, 1, 1, '1|2|3', 1, '13:1.0,7:1.0', @Status OUT, @Msg OUT
	SELECT * FROM Remoto_Pedidos
	DELETE Remoto_Pedidos
*/


GO


CREATE PROCEDURE [dbo].[sp_PALM_Pedido_Incluir3](@Unidade INT, @Atendimento INT, @Garcon INT, @Produto INT, @Qtd NUMERIC(10,4), @Obs VARCHAR(2000), @Local INT, @Opcionais VARCHAR(2000), @Cliente INT, @Status INT OUT, @Msg VARCHAR(100) OUT)
AS
/**

	DATA DE CRIAÇÃO: 30/08/2012 14:51h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento armazenado para incluir um pedido enviado pelo palm

**/
-- old dbo.sp_MOBILE_AddPedido
BEGIN
	DECLARE @t TABLE (Status INT, Msg VARCHAR(100), Linha VARCHAR(100))
	DECLARE @Linha VARCHAR(100)

	SET @obs = dbo.fn_PALM_ObservacoesPre(@obs)

	-- TESTAR O LIMITE DA MESA
	DECLARE @LimiteOk BIT, @Credito MONEY, @TotalConta MONEY, @TotalPedido MONEY

	SET @LimiteOk = 0
	SET @Credito = 0
	SET @TotalConta = 0

	SELECT @Credito = dbo.fn_PALM_Atendimento_Credito(@Unidade, @Atendimento)		
	IF (@Credito > 0)
	BEGIN
		SELECT @TotalConta = ISNULL(Total, 0) FROM dbo.fn_PALM_Pedido_Listar(@Unidade, @Atendimento, 1, 1) as [p] WHERE p.Tipo = 'T'
		SELECT @TotalPedido = (PreçoDeVenda * @Qtd) + (CASE WHEN Comissionado = 1 THEN ((PreçoDeVenda * @Qtd) / 10) ELSE 0 END) FROM Produtos WHERE Código = @Produto

		SET @Credito = ISNULL(@Credito, 0)
		SET @TotalConta = ISNULL(@TotalConta, 0)
		SET @TotalPedido = ISNULL(@TotalPedido, 0) 

		IF (@TotalPedido + @TotalConta) <= @Credito
		BEGIN
			SET @LimiteOk = 1
		END
	END
	ELSE
	BEGIN
		SET @LimiteOk = 1
	END
	-- FIM DO TESTE DO LIMITE

	IF @LimiteOk = 1
	BEGIN
		IF (EXISTS(SELECT * FROM Produtos WHERE Código = @Produto) AND EXISTS(SELECT * FROM Fornecedores WHERE Código = @Garcon))
		BEGIN

			SET @Status = 0  
			SET @Msg = 'Pedido adicionado!'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]

				
			INSERT Remoto_Pedidos(DataDaInclusão, Status, Tipo, Unidade, Atendimento, Produto, Qde, Vendedor, Observacoes, DataDeEdição, Localização, Opcionais, Cliente) 
			VALUES(GETDATE(), 0, 1, @Unidade, @Atendimento, @Produto, @Qtd, @Garcon, @Obs, GETDATE(), @Local, @Opcionais, @Cliente)

		END
		ELSE	
		BEGIN
			SET @Status = 2  
			SET @Msg = 'Erro: Pedido inválido.'
			SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
			SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	
		END
	END
	ELSE
	BEGIN
		SET @Status = 1  
		SET @Msg = 'O pedido ultrapassa o limite da mesa.'
		SET @Linha = CAST(@Status AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Msg, 1, 97) + '#', ' ', 97) + '$'
		SELECT @Status as [Status], @Msg as [Msg], @Linha as [Linha]
	END
END;


GO


CREATE FUNCTION [fn_PALM_Atendimento_CheckTempo](@pUnidade INT, @pAtendimento INT)
RETURNS @Tempo TABLE(Unidade INT, Atendimento INT, Abertura DATETIME, Dias INT, Horas INT, Minutos INT, Segundos INT, ContaImpressa BIT, Linha VARCHAR(200))
AS
/**
	DATA DE CRIAÇÃO: 20/08/2008 15:57h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento armazenado para emissão da conta do palm

	Estrutura do campo "Linha"
		<@Unidade,5>#
		<@Atendimento,5>#
		<@Abertura,10>#
		<@Abertura,8>#
		<@ContaImpressa,1>#
		<@Dias,5>#
		<@Horas,5>#
		<@Minutos,5>#
		<@Segundos,5>$

	Exemplo:
		00001#00001#27/03/2008#19:04:00#0#00028#00021#00026#00001$
**/
-- old dbo.sp_MOBILE_ListaMesas (@mesaparam INT)
BEGIN
	DECLARE @Unidade INTEGER, @Atendimento INTEGER, @Abertura DATETIME, @Linha VARCHAR(200)
	DECLARE @Dias INT, @Horas INT, @Minutos INT, @Segundos INT, @ContaImpressa INT

	DECLARE c CURSOR FOR
	SELECT 
		Unidade, Atendimento, DataDaInclusão as [Abertura]
	FROM dbo.vw_PALM_AtendimentosAbertos
	WHERE 
		((Unidade = @pUnidade AND Atendimento = @pAtendimento) OR (@pAtendimento = 0))
	
	OPEN c

	SET @Linha = 
			ISNULL(dbo.fn_ZerosEsq(@pUnidade, 5), '00000') + '#' +
			ISNULL(dbo.fn_ZerosEsq(@pAtendimento, 5), '00000') + '#' + 
			'01/01/1900#' + '00:00:00#' + '0#' + '00000#' + '00000#' + '00000#' + '00000$'

	FETCH NEXT FROM c INTO @Unidade, @Atendimento, @Abertura
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT 
			@Dias = Dias, 
			@Horas = Horas, 
			@Minutos = Minutos, 
			@Segundos = Segundos, 
			@ContaImpressa = ContaImpressa 
		FROM [dbo].[fn_PALM_TempoDePermanencia](@Unidade, @Atendimento)


		SET @Linha = 
				ISNULL(dbo.fn_ZerosEsq(@Unidade, 5), '00000') + '#' +
				ISNULL(dbo.fn_ZerosEsq(@Atendimento, 5), '00000') + '#' + 
				CONVERT(VARCHAR(10), @Abertura, 103) + '#' + 
				CONVERT(VARCHAR(10), @Abertura, 108) + '#' +
				(CASE ISNULL(@ContaImpressa,0) WHEN 0 THEN '0' ELSE '1' END) + '#' +
				ISNULL(dbo.fn_ZerosEsq(@Dias, 5), '00000') + '#' +
				ISNULL(dbo.fn_ZerosEsq(@Horas, 5), '00000') + '#' +
				ISNULL(dbo.fn_ZerosEsq(@Minutos, 5), '00000') + '#' +
				ISNULL(dbo.fn_ZerosEsq(@Segundos, 5), '00000') + '$'
				

		INSERT @Tempo(Unidade, Atendimento, Abertura, Dias, Horas, Minutos, Segundos, ContaImpressa, Linha)
		VALUES(@Unidade, @Atendimento, @Abertura, @Dias, @Horas, @Minutos, @Segundos, @ContaImpressa, @Linha)

		FETCH NEXT FROM c INTO @Unidade, @Atendimento, @Abertura
	END
	CLOSE c
	DEALLOCATE c

	IF (SELECT COUNT(*) FROM @Tempo) = 0
	BEGIN
		INSERT @Tempo(Unidade, Atendimento, Abertura, Dias, Horas, Minutos, Segundos, ContaImpressa, Linha)
		VALUES(@pUnidade, @pAtendimento, '1900-01-01 00:00:00.000', 0, 0, 0, 0, 0, @Linha)
	END

	RETURN
END
-- SELECT * FROM dbo.fn_PALM_Atendimento_CheckTempo(1,1)


GO


CREATE FUNCTION [fn_Autenticar2](@user VARCHAR(255), @pass VARCHAR(255))
RETURNS @t TABLE(Administrador BIT, Autenticado BIT)
AS
BEGIN
	DECLARE @result INT, @admin BIT, @autenticado BIT
	SET @admin = 0
	SET @autenticado = 0
	SET @result = dbo.fn_Autenticar(@user, dbo.CriptoStr255(@pass,''))
	IF @result > 0
	BEGIN
		SET @autenticado = 1
		IF @result > 9000000
			SET @admin = 1
	END
	INSERT @T(Administrador, Autenticado)
	SELECT @admin as [Administrador], @autenticado [Autenticado]
	RETURN
END


GO


CREATE  VIEW [vw_PALM_AtendimentosLivres]
AS
/**
Para CheckIN já deve existir um lançamento
**/
SELECT DISTINCT
	Unidade, 
	Atendimento,
	CheckIN
FROM vw_PALM_AtendimentosAbertos
WHERE
	(CheckIN = 1)
	AND (Conta_Impressa = 0)

UNION
/**
Para não CheckIN não pode existir uma conta impressa
**/
SELECT DISTINCT
	cg.Unidade, 
	cg.Atendimento,
	cg.CheckIN
FROM vw_PALM_Cg_Atendimentos cg
WHERE 
	(CheckIN = 0)
	AND (NOT EXISTS(SELECT * FROM vw_PALM_AtendimentosAbertos aa WHERE aa.Unidade = cg.Unidade AND aa.Atendimento = cg.Atendimento AND aa.Conta_Impressa = 1))


GO


/***
* Utilizar com "SET DATEFORMAT YMD"
***/
CREATE FUNCTION [fn_PALM_CheckMeta](@Unidade INT, @Garcon INT, @Agora DATETIME)
RETURNS @T TABLE (Meta MONEY, Vendido MONEY, Comissao MONEY, [Percentual] NUMERIC(10,2), Inicio VARCHAR(20), Conclusao VARCHAR(20))
AS
BEGIN
	--SET DATEFORMAT YMD	

	DECLARE @Meta MONEY, @Vendido MONEY, @Comissao MONEY
	DECLARE @Inicio VARCHAR(20), @Conclusao VARCHAR(20), @Percentual NUMERIC(10,2);

	SELECT TOP 1
		@Meta = 
		(CASE DATEPART(weekday, @Agora)
			WHEN 1 THEN m.Valor_1 -- domingo
			WHEN 2 THEN m.Valor_2 -- segunda
			WHEN 3 THEN m.Valor_3 -- terça
			WHEN 4 THEN m.Valor_4 -- quarta
			WHEN 5 THEN m.Valor_5 -- quinta
			WHEN 6 THEN m.Valor_6 -- sexta
			WHEN 7 THEN m.Valor_7 -- sábado
		END),
		@Inicio = CONVERT(VARCHAR(20), Início, 103),
		@Conclusao = CONVERT(VARCHAR(20), Conclusão, 103)
	FROM Metas m
	WHERE 
		(m.Unidade = @Unidade )
		AND (m.Fornecedor = @Garcon)
		AND (@Agora BETWEEN CAST(REPLACE(CONVERT(VARCHAR(20), Início, 102),'.','-')+' 00:00:00.000' AS DATETIME) AND DATEADD(day, 1, CAST(REPLACE(CONVERT(VARCHAR(20), Conclusão, 102),'.','-')+' 00:00:00.000' AS DATETIME)));
		
	SELECT 
		@Vendido = TotalVendido, @Comissao = TotalComissao
	FROM dbo.fn_PALM_Garcon_CheckVendas(@Garcon, @Agora)	
		

	SET @Vendido = ISNULL(@Vendido, 0);	
	SET @Comissao = ISNULL(@Comissao, 0);
	SET @Meta = ISNULL(@Meta, 0);
	SET @Inicio = ISNULL(@Inicio, 'N/I');
	SET @Conclusao = ISNULL(@Conclusao, 'N/I');

	IF @Meta > 0
		SET @Percentual = @Vendido / @Meta * 100;
	ELSE	
		SET @Percentual = 100;	

	INSERT @T(Meta, Vendido, Comissao, Percentual, Inicio, Conclusao)
	SELECT [Meta] = @Meta, [Vendido] = @Vendido, [Comissao] = @Comissao, [Percentual] = @Percentual, [Inicio] = @Inicio, [Conclusao] = @Conclusao

	RETURN;
END;


GO


CREATE   VIEW [vw_PALM_Metas]
-- old vw_FaturadoXMetas
AS
SELECT 
	m.Fornecedor AS [Vendedor],
	'Meta do Dia' as [Descrição],
	(CASE
		WHEN DATEPART(dw, GETDATE()) = 1 THEN ISNULL(m.Valor_1, 0) 
		WHEN DATEPART(dw, GETDATE()) = 2 THEN ISNULL(m.Valor_2, 0) 
		WHEN DATEPART(dw, GETDATE()) = 3 THEN ISNULL(m.Valor_3, 0) 
		WHEN DATEPART(dw, GETDATE()) = 4 THEN ISNULL(m.Valor_4, 0)  
		WHEN DATEPART(dw, GETDATE()) = 5 THEN ISNULL(m.Valor_5, 0)  
		WHEN DATEPART(dw, GETDATE()) = 6 THEN ISNULL(m.Valor_6, 0)  
		WHEN DATEPART(dw, GETDATE()) = 7 THEN ISNULL(m.Valor_7, 0) 
	END) as [Total] 
FROM   Metas m LEFT JOIN vw_PALM_FaturadoHoje fd ON fd.Código=m.Fornecedor
WHERE
	GETDATE() BETWEEN m.Início AND m.Conclusão
UNION
SELECT 
	m.Fornecedor AS [Vendedor],
	'Total Vendido' as [Descrição],
	ISNULL(fd.TotalVendido,0) AS [Total]
FROM   Metas m LEFT JOIN vw_PALM_FaturadoHoje fd ON fd.Código=m.Fornecedor
WHERE
	GETDATE() BETWEEN m.Início AND m.Conclusão

	
GO


CREATE FUNCTION [fn_PALM_Garcon_CheckFaturamentoEmData](@Garcon INTEGER, @Data DATETIME)
RETURNS @Vendas TABLE(Código INTEGER, Nome VARCHAR(100), QDE INTEGER, TotalVendido NUMERIC(15,4), TotalComissao NUMERIC(15,4), TotalMeta NUMERIC(15,4))
AS
BEGIN
	INSERT @Vendas(Código, Nome, QDE, TotalVendido, TotalComissao, TotalMeta)
	SELECT *, dbo.fn_PALM_Garcon_CheckMeta(@Garcon, @Data) as [Meta] FROM dbo.fn_PALM_Garcon_CheckVendas(@Garcon, @Data)
	RETURN
END


GO


CREATE PROCEDURE [sp_PALM_Pedido_Listar](@Unidade INT, @Atendimento INT, @VerTotal BIT, @VerComissao BIT)
/**

	DATA DE CRIAÇÃO: 20/08/2008 17:11h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento para listar os pedidos de uma mesa

**/
-- old dbo.sp_MOBILE_ListaPedidos
AS
BEGIN
	SELECT * FROM dbo.fn_PALM_Pedido_Listar(@Unidade, @Atendimento, @VerTotal, @VerComissao)
END


GO


CREATE VIEW [vw_PALM_Atendimentos]
AS
SELECT
	a.Unidade, 
	a.Atendimento,
	ISNULL(a.CheckIN,0) AS [CheckIN],
	(CASE WHEN ISNULL(ab.Atendimento, 0) = 0 THEN 0 ELSE 1 END) AS [Aberto],
	ISNULL(ab.Conta_Impressa, 0) AS [Conta_Impressa],
	ab.DataDaInclusão AS [Abertura],
	(CASE WHEN al.Atendimento IS NULL THEN 0 ELSE 1 END) AS [Disponivel]
FROM Atendimentos a LEFT JOIN vw_PALM_AtendimentosAbertos ab ON a.Unidade = ab.Unidade AND a.Atendimento = ab.Atendimento 
	LEFT JOIN vw_PALM_AtendimentosLivres al ON a.Unidade = al.Unidade AND a.Atendimento = al.Atendimento
WHERE
	(Status & 1) = 0


GO


CREATE FUNCTION [fn_PALM_Atendimento_CheckStatus](@Unidade INT, @Atendimento INT)
/**

	DATA DE CRIAÇÃO: 20/08/2008 15:57h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Função que checa se o atendimento está livre para envio de pedidos
	
	0 = Atendimento livre
	1 = Conta já impressa
	2 = Não foi feito checkin
	3 = Mesa inexistente
	4 = Motivo desconhecido

**/
RETURNS @t TABLE(Status INT, Mensagem VARCHAR(250), Linha VARCHAR(100))
AS
BEGIN
	DECLARE @Ok BIT, @Result INT, @Mensagem VARCHAR(255), @Linha VARCHAR(100)

	SET @Result = 0
	SET @Mensagem = 'Atendimento disponivel!'

	-- ATENDIMENTO BLOQUEADO
	IF EXISTS(					
		SELECT 
			1
		FROM Lançamentos_Vendas lv 
			INNER JOIN Lançamentos l ON lv.LancamentoID = l.Código
		WHERE
			l.DataDeEmissão IS NULL
			AND l.Unidade = @unidade
			AND l.Atendimento = @atendimento
			AND lv.Bloqueado = 1
		)
	BEGIN
		SET @Result = 1
		SET @Mensagem = 'O atendimento ' + CAST(@Atendimento AS VARCHAR(20)) + ' está bloqueado.'
	END 
	ELSE
	BEGIN


		SELECT @Ok = (CASE WHEN (SELECT COUNT(*) FROM [dbo].[vw_PALM_AtendimentosLivres] WHERE Unidade = @Unidade AND Atendimento = @Atendimento) > 0 THEN 1 ELSE 0 END)
		IF @Ok <> 1
		BEGIN
			-- MESA INEXISTENTE
			IF (NOT EXISTS(SELECT * FROM dbo.vw_PALM_Cg_Atendimentos WHERE Unidade = @Unidade AND Atendimento = @Atendimento))
			BEGIN
				SET @Result = 3
				SET @Mensagem = 'Atendimento ' + CAST(@Atendimento AS VARCHAR(20)) + ' inexistente.'
			END 
			-- CONTA IMPRESSA
			ELSE IF EXISTS(SELECT * FROM vw_PALM_AtendimentosAbertos aa WHERE Unidade = @Unidade AND Atendimento = @Atendimento AND Conta_Impressa = 1)
			BEGIN
				SET @Result = 0
				SET @Mensagem = 'A conta do atendimento ' + CAST(@Atendimento AS VARCHAR(20)) + ' foi impressa anteriormente.'
			END 
			-- NÃO FOI FEITO CHECKIN
			ELSE IF EXISTS(SELECT * FROM dbo.vw_PALM_Cg_Atendimentos aa WHERE Unidade = @Unidade AND Atendimento = @Atendimento AND CheckIN = 1)
			BEGIN
				SET @Result = 2
				SET @Mensagem = 'Nao foi feito o checkin ainda.'
			END
			ELSE
			BEGIN
				SET @Result = 4
				SET @Mensagem = '* desconhecido (checar a existencia e/ou situacao da mesa no terminal) *'
			END
		END

	END;

	SET @Linha = CAST(@Result AS VARCHAR(1)) + '#' + dbo.PADR(SUBSTRING(@Mensagem, 1, 97) + '#', ' ', 97) + '$'
	INSERT @t(Status, Mensagem, Linha) VALUES(@Result, @Mensagem, @Linha)
	RETURN
END
--SELECT * FROM fn_PALM_Atendimento_CheckStatus(1,10568)


GO


CREATE VIEW [vw_PALM_Atendimento_CheckTempo]
AS
-- old dbo.vw_PALM_MesasStatus
SELECT 
	*,
	(CASE WHEN ISNULL(dias,0) > 0 THEN CAST(dias AS VARCHAR(5)) + ' dias e ' ELSE '' END) +
	(CASE WHEN ISNULL(horas,0) > 0 THEN CAST(horas AS VARCHAR(5)) + 'h, ' ELSE '' END) +
	(CASE WHEN ISNULL(minutos,0) > 0 THEN CAST(minutos AS VARCHAR(5)) + 'min e ' ELSE '' END) +
	CAST(ISNULL(segundos,0) AS VARCHAR(5)) + 's' as [Tempo]
FROM dbo.fn_PALM_Atendimento_CheckTempo(0,0)
-- SELECT * FROM dbo.vw_PALM_Atendimento_CheckTempo


GO


CREATE PROCEDURE [sp_PALM_Conta_Imprimir](@Unidade INT, @Atendimento INT, @Garcon INT = NULL)
/**

	DATA DE CRIAÇÃO: 20/08/2008 15:57h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Procedimento armazenado para emissão da conta do palm

**/
-- old dbo.sp_MOBILE_ContaImpr
AS
BEGIN
	DECLARE @Status INT, @Mensagem VARCHAR(255), @Linha VARCHAR(255);


	IF @Garcon IS NULL
	BEGIN
		SELECT @Garcon = Código FROM Fornecedores WHERE Nome = 'ADMIN';
	END;

	SELECT 
		@Status = Status, @Mensagem = Mensagem, @Linha = Linha 
	FROM dbo.fn_PALM_Atendimento_CheckStatus(@Unidade, @Atendimento)

	if @Status = 0
	BEGIN
		SELECT 	'0#Conta impressa!                        #                                                         $' as [Linha],
		0 AS [Status], 'Conta impressa!                        ' AS [Mensagem]
		INSERT Remoto_Pedidos(DataDaInclusão, Status, Tipo, Unidade, Atendimento, Produto, Qde, Vendedor)
		VALUES(GETDATE(), 0, 9, @Unidade, @Atendimento, 0, 0, @Garcon)		
	END
	ELSE
	BEGIN
		SELECT @Linha as [Linha], @Status AS [Status], @Mensagem AS [Mensagem]
	END
END
/*
EXEC dbo.sp_PALM_Conta_Imprimir 1, 1
SELECT * FROM Remoto_Pedidos
DELETE Remoto_Pedidos
*/


GO


CREATE PROCEDURE [dbo].[sp_PALM_Conta_Imprimir2](@Unidade INT, @Atendimento INT, @Garcon INT, @QdeHomens INT, @QdeMulheres INT, @QdeCriancas INT)
/**

	DATA DE CRIAÇÃO: 16/08/2012 15:33h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: Mesma funcionalidade da [sp_PALM_Conta_Imprimir] com a diferença que é possível informar a qtd de pessoas.

**/
-- old dbo.sp_MOBILE_ContaImpr
AS
BEGIN
	DECLARE @Status INT, @Mensagem VARCHAR(255), @Linha VARCHAR(255);


	IF ((ISNULL(@QdeHomens,0) + ISNULL(@QdeMulheres,0) + ISNULL(@QdeCriancas,0)) <= 0)
	BEGIN
		SET @QdeHomens = 1;
		SET @QdeMulheres = 0;
		SET @QdeCriancas = 0;
	END;

	SET @QdeHomens = ISNULL(@QdeHomens,0);
	SET @QdeMulheres = ISNULL(@QdeMulheres,0);
	SET @QdeCriancas = ISNULL(@QdeCriancas,0);

	IF @Garcon IS NULL
	BEGIN
		SELECT @Garcon = Código FROM Fornecedores WHERE Nome = 'ADMIN';
	END;

	SELECT @Status = Status, @Mensagem = Mensagem, @Linha = Linha 
	FROM dbo.fn_PALM_Atendimento_CheckStatus(@Unidade, @Atendimento)

	if @Status = 0
	BEGIN
		SELECT 	'0#Solicitacao de emissao de conta enviada#                                                         $' as [Linha],
		0 AS [Status], 'Solicitacao de emissao de conta enviada' AS [Mensagem]
		INSERT Remoto_Pedidos(DataDaInclusão, Status, Tipo, Unidade, Atendimento, Produto, Qde, Vendedor, QdeHomens, QdeMulheres, QdeCriancas)
		VALUES(GETDATE(), 0, 9, @Unidade, @Atendimento, 0, 0, @Garcon, @QdeHomens, @QdeMulheres, @QdeCriancas);
	END
	ELSE
	BEGIN
		SELECT @Linha as [Linha], @Status AS [Status], @Mensagem AS [Mensagem]
	END
END;


GO

/*************************
* Carga dos opcionais
**************************/
CREATE VIEW [vw_PALM_Cg_Opcionais] 
AS 
(
	SELECT 
		[Produto] = c.Produto, 
		[Opcional] = c.Produto2, 
		[Nome] = UPPER(p.Descrição), 
		[Qde] = c.Qde, 
		[UN] = UPPER(ISNULL(p.Une,'UN'))
	FROM Produtos_Composições c JOIN Produtos p ON c.Produto2 = p.Código
	WHERE
		(c.Qde > 0) AND
		(c.Ativo = 1) AND
		(p.Disponível = 1) AND
		(p.Ativo = 1) AND
		(c.GrupoDeOpcionais IS NOT NULL)
	--ORDER BY c.Produto, p.Descrição
);

GO

CREATE VIEW [vw_PALM_Cg_Clientes]
AS
SELECT 
	[ClienteID] = c.Código, 
	[Nome] = UPPER(c.Nome), 
	[CPF] = SUBSTRING('00000000000' + CAST(ISNULL(c.CPF, 0) AS VARCHAR(20)), LEN('00000000000' + CAST(ISNULL(c.CPF, 0) AS VARCHAR(20))) - 10, 11),
	[Telefone] = dbo.ClearAlpha(Telefones),
	[Endereco] = SUBSTRING(c.Endereço + ' ' + CAST(ISNULL(Número, 0) AS VARCHAR(10)) + ' / ' + 'COMPL. ' + ISNULL(c.Complemento, '<N/I>') + ' / ' + 'BAIRRO ' + ISNULL(c.Bairro, '<N/I>') + ' / ' + 'PTO.REF. ' + ISNULL(c.Referência, '<N/I>'), 1, 255),
	[Classe] = c.ClasseAtual
FROM Clientes c;

GO

CREATE FUNCTION [dbo].[fn_Autenticar3](@user VARCHAR(255), @pass VARCHAR(255))
RETURNS @t TABLE(Administrador BIT, Autenticado BIT, UsuarioId INT)
AS
BEGIN
	DECLARE @admin BIT, @autenticado BIT, @UsuarioID INT;
	SET @admin = 0;
	SET @autenticado = 0;
	SET @UsuarioID = 0;
	IF (LEN(ISNULL(@pass,'')) > 0) AND EXISTS(SELECT 1 FROM Fornecedores WHERE nome = @user AND (dbo.CriptoStr255(senha,'') = @pass OR lower(dbo.CriptoStr255(senha,'')) = lower(dbo.CriptoStr255(@pass,''))) AND ((Ativo = 1 AND Vendedor = 1) OR (@user = 'ADMIN')))
	BEGIN
		SELECT @UsuarioID = Código FROM Fornecedores WHERE nome = @user;
		SET @autenticado = 1;
		IF (EXISTS(SELECT * FROM Fornecedores f WHERE f.Nome = @user AND f.Código IN (SELECT ur.Usuário FROM Regras r INNER JOIN Usuários_Regras ur ON r.Código = ur.Regra WHERE r.Descrição = 'ADMINISTRADORES'))) OR (@User = 'ADMIN')
			SET @admin = 1;
	END;
	INSERT @T(Administrador, Autenticado, UsuarioID) SELECT @admin, @autenticado, @UsuarioID;
	RETURN;
END;

GO

CREATE FUNCTION fn_PALM_VendasCurvaABC(@DtIni DATETIME, @DtFim DATETIME, @Unidade INT)
RETURNS @t TABLE(
	Row INT,
	ProdutoID BIGINT, 
	Nome VARCHAR(255), 
	UN VARCHAR(20), 
	PrecoDeVenda MONEY, 
	Qde NUMERIC(10,2), 
	TotalVendido NUMERIC(10,3), 
	PrecoMinimo MONEY, 
	PrecoMedio MONEY, 
	PrecoMaximo MONEY,
	Percentual NUMERIC(10,3),
	Acumulado NUMERIC(10,3),
	FaturamentoTotal NUMERIC(10,3),
	PrecoMedioVendido NUMERIC(10,3))
AS
BEGIN

	--SET @DtIni = '2012-06-01 00:00:00.000';
	--SET @DtFim = '2012-08-01 23:59:59.997';
	--SET @Unidade = 2;

	DECLARE
		@Row INT,
		@ProdutoID BIGINT, 
		@Nome VARCHAR(255), 
		@UN VARCHAR(20), 
		@PrecoDeVenda MONEY, 
		@Qde NUMERIC(10,3), 
		@TotalVendido NUMERIC(10,3), 
		@PrecoMinimo MONEY, 
		@PrecoMedio MONEY, 
		@PrecoMaximo MONEY,
		@Percentual NUMERIC(10,3),
		@Acumulado NUMERIC(10,3);

	DECLARE @Total NUMERIC(10,3);
	SET @Acumulado = 0;

	INSERT @t(Row, ProdutoID, Nome, UN, PrecoDeVenda, Qde, TotalVendido, PrecoMinimo, PrecoMedio, PrecoMaximo)
	SELECT
		ROW_NUMBER() OVER (ORDER BY [TotalVendido] DESC),
		P.Código, 
		P.Descrição, 
		P.UNE UN, 
		[PrecoDeVenda] = ISNULL(X.PreçoDeVenda, 0), 
		[Qde] = ISNULL(X.QDE, 0), 
		[TotalVendido] = ISNULL(X.TotalVendido, 0), 
		[PrecoMinimo] = ISNULL(X.PrecoMinimo, 0), 
		[PrecoMedio] = ISNULL(X.PrecoMedio, 0), 
		[PrecoMaximo] = ISNULL(X.PrecoMaximo, 0)
	FROM Produtos P JOIN
		(SELECT 
			G.Nome Grupo, 
			R.Produto, 
			AVG(R.Preço / NULLIF(R.Fator, 0)) PreçoDeVenda, 
			SUM(R.QDE * R.Fator) QDE, 
			SUM(R.PreçoTotal) TotalVendido,
			MIN(R.Preço / NULLIF(R.Fator, 0)) PrecoMinimo, 
			AVG(R.Preço / NULLIF(R.Fator, 0)) PrecoMedio, 
			MAX(R.Preço / NULLIF(R.Fator, 0)) PrecoMaximo
		FROM Lançamentos L JOIN Pedidos P ON L.Código = P.Lançamento 
			JOIN Pedidos_Produtos R ON P.Código = R.Pedido 
			JOIN Produtos D ON D.Código = R.Produto
			JOIN Fornecedores G ON '0' = G.Código
		WHERE
			(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121)) 
			AND NOT ((L.Status  &  1) > 0) 
			AND (L.Tipo BETWEEN 16 AND 64) 
			AND (P.Natureza <> 0) 
			AND (R.SubItem = 0) 
			AND (R.Fator <> 0)
			AND (R.Preço > 0.00)
			AND (@Unidade = 0 OR L.Unidade = @Unidade)
		GROUP BY G.Nome, R.Produto) as [X] 
	ON P.Código = X.Produto
	WHERE
	  ((P.Ativo = 1) AND (P.Disponível = 1)) OR (X.Produto IS NOT NULL)
	ORDER BY X.TotalVendido DESC;

	SET @Total = (SELECT SUM(TotalVendido) FROM @t);

	DECLARE c CURSOR FOR
	SELECT
		Row,
		ProdutoID, 
		Nome, 
		UN, 
		PrecoDeVenda, 
		Qde, 
		TotalVendido, 
		PrecoMinimo, 
		PrecoMedio, 
		PrecoMaximo
	FROM @t;

	OPEN c;
	FETCH NEXT FROM c INTO @Row, @ProdutoID, @Nome, @UN, @PrecoDeVenda, @Qde, @TotalVendido, @PrecoMinimo, @PrecoMedio, @PrecoMaximo;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Percentual = CAST(((@TotalVendido / @Total) * 100) AS NUMERIC(10,2));
		SET @Acumulado = @Acumulado + @Percentual;

		IF (@Acumulado > 99.9) 
			SET @Acumulado = 100;

		UPDATE @t
		SET Percentual = @Percentual, Acumulado = @Acumulado,
			FaturamentoTotal = @Total,
			PrecoMedioVendido = CAST((@TotalVendido / @Qde) AS NUMERIC(10,3))
		WHERE Row = @Row;
		FETCH NEXT FROM c INTO @Row, @ProdutoID, @Nome, @UN, @PrecoDeVenda, @Qde, @TotalVendido, @PrecoMinimo, @PrecoMedio, @PrecoMaximo;
	END;
	CLOSE c;
	DEALLOCATE c;

	RETURN
END;

GO

CREATE VIEW [dbo].[vw_PALM_Cg_AmbientesProdutos]
AS
(
	SELECT 
		[UnidadeID] = pa.Unidade, 
		[ProdutoID] = pa.Produto,
		[AmbienteID] = pa.Ambiente, 
		[AmbienteNome] = ua.Descrição
	FROM Produtos_Ambientes pa 
		INNER JOIN Unidades_Ambientes ua ON pa.Unidade = ua.Unidade AND pa.Ambiente = ua.Ambiente
);

GO

CREATE VIEW [dbo].[vw_PALM_Cg_Produtos_Composicoes]
AS
(
	SELECT DISTINCT
		[CategoriaID] = ISNULL(Cat.CategoriaID,0),
		[CategoriaNome] = ISNULL(Cat.CategoriaNome,'OUTROS'),  
		[ProdutoID] = C.ProdutoID,
		[ProdutoNome] = D_Pai.ProdutoNome, 
		[SubProdutoID] = C.Produto2ID, 
		[SubProdutoNome] = D.ProdutoNome, 
		[Preco] = dbo.fn_GetPrecoDeVenda(c.ProdutoID, 1),
		[Fracionavel] = ISNULL(D.Fracionado,0),
		[Partes] = ISNULL(D.QDEItens, 1),
		[Tipo] = (
			CASE 
				WHEN C.TIPO = 5 THEN 'O'
				WHEN C.TIPO = 10 THEN 'A'
				WHEN C.TIPO = 15 THEN 'M'
				ELSE 'O'
			END), 
		
		[TemMontagem] = ISNULL(D.Montagem, 0), 
		[SubProdutoQuantidade] = C.QDE, 		
		[AceitaPrecoZero] = C.PrecoZero, 
		[Unidade] = PU.UnidadeID
	FROM
		vwProdutosComposicoes C JOIN
		vwProdutos D ON D.ProdutoID = C.Produto2ID JOIN
		vwProdutos D_Pai ON D_Pai.ProdutoID = C.ProdutoID JOIN
		vwProdutosUnidades PU ON D.ProdutoID = PU.ProdutoID OUTER APPLY
		(SELECT TOP 1 cc.CategoriaID, cc.CategoriaNome FROM vwCategorias cc WHERE cc.CategoriaID = ISNULL(C.GrupoDeOpcionais, D.CategoriaID)) AS Cat
	WHERE
		--(C.ProdutoID = 46) AND
		(C.Baixar = 0)
		AND (C.GrupoDeOpcionais > -1)
		AND ((D.Venda = 1) OR (C.Tipo = 1))
		AND (D.Ativo = 1)
		AND (C.Ativo = 1)		
		AND (c.Tipo IS NULL OR c.Tipo IN (5,10,15))
		AND (PU.Ativo = 1) 
	--	AND PU.UnidadeID = dbo.GetUnidadeLocal()
	--ORDER BY C.Tipo, C.GrupoDeOpcionais, D.CategoriaID, C.Produto2ID
);

GO

CREATE VIEW vw_PALM_Cg_Produtos_Todos
AS
(
	SELECT 
		p1.Produto,
		p1.Nome,
		p1.Preco,
		p1.Comissionado,
		p1.Fracionado,
		p1.Categoria,
		[DispVenda] = 1
	FROM dbo.vw_PALM_Cg_Produtos p1
	UNION
	SELECT
		p2.Código,
		p2.Descrição,
		0,
		0,
		0,
		0,
		0
	FROM Produtos p2
	WHERE NOT p2.Código IN (SELECT Produto FROM dbo.vw_PALM_Cg_Produtos)
);

GO

CREATE FUNCTION dbo.fn_PALM_Adiantamentos(@Unidade INT, @Atendimento NUMERIC(10,2))
RETURNS @t TABLE(Lancamento INT, Adiantamento MONEY)
/**

	DATA DE CRIAÇÃO: 07/05/2014 17:40h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: retorna os valores adiantados como pagamento para um atendimento

	HISTÓRICO:
	
	07/05/2014: Criação da função

**/
AS
BEGIN

	DECLARE @Lancamento INT;
	DECLARE @Adiantamento MONEY;

	SELECT 
		@Lancamento = L.Código
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
	WHERE 
		(L.DataDeEmissão IS NULL) 
		AND ((L.Atendimento = @Atendimento AND L.Unidade = @Unidade) OR @Atendimento = 0) 
		AND (L.Atendimento IS NOT NULL)
		AND ((L.Status % 2) = 0)
		AND (P.Natureza = -1) 
		AND (R.SubItem = 0)
		AND (R.Fator > 0)

	SELECT @Adiantamento = SUM(Valor) 
	FROM dbo.Lançamentos_FormasDePagamento
	WHERE LancamentoID = @Lancamento;

	SET @Lancamento = ISNULL(@Lancamento,0);
	SET @Adiantamento = ISNULL(@Adiantamento,0);
	
	INSERT @t(Lancamento, Adiantamento)
	SELECT [Lancamento] = @Lancamento, [Adiantamento] =  @Adiantamento

	RETURN;
END;

GO


CREATE FUNCTION dbo.fn_PALM_Desconto(@Unidade INT, @Atendimento INT)
RETURNS @t TABLE(Lancamento INT, Desconto MONEY)
/**

	DATA DE CRIAÇÃO: 09/05/2014 10:30h
	AUTOR: NELSON CARLSON I (ncarlsonf@gmail.com)
	DESCRIÇÃO: retorna o desconto dado a um atendimento

	HISTÓRICO:
	
	09/05/2014: Criação da função

**/
AS
BEGIN

	DECLARE @Lancamento INT;
	DECLARE @Desconto MONEY;

	SELECT 
		@Lancamento = L.Código
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
	WHERE 
		(L.DataDeEmissão IS NULL) 
		AND ((L.Atendimento = @Atendimento AND L.Unidade = @Unidade) OR @Atendimento = 0) 
		AND (L.Atendimento IS NOT NULL)
		AND ((L.Status % 2) = 0)
		AND (P.Natureza = -1) 
		AND (R.SubItem = 0)
		AND (R.Fator > 0)

	SELECT @Desconto = Abatimento 
	FROM dbo.Lançamentos
	WHERE Código = @Lancamento;

	SET @Lancamento = ISNULL(@Lancamento,0);
	SET @Desconto = ISNULL(@Desconto,0);
	
	INSERT @t(Lancamento, Desconto)
	SELECT [Lancamento] = @Lancamento, [Desconto] =  @Desconto

	RETURN;
END;
--SELECT * FROM dbo.fn_PALM_Desconto(1,1)

GO

CREATE FUNCTION dbo.fn_PALM_ConsultaContaWEB(@Unidade INT, @Atendimento INT)
RETURNS @t TABLE
(
	[DataHora] DATETIME, [ProdutoID] INT, [ProdutoNome] VARCHAR(555), 
	[Qtd] NUMERIC(10,2), [Preco] INT, [Un] VARCHAR(20), [TotalUn] NUMERIC(10,2), 
	[Subtotal] NUMERIC(10,2), [Taxa] NUMERIC(10,2), [Total] NUMERIC(10,2), [Aberto] BIT, 
	[Dias] INT, [Horas] INT, [Minutos] INT, [Segundos] INT, 
	[Status] INT, [Mensagem] VARCHAR(500), [Atendentes] VARCHAR(2000), 
	[Adiantamento] NUMERIC(10,2), [Desconto] NUMERIC(10,2), [TotalAPagar] NUMERIC(10,2) 
)
AS
BEGIN
 
    DECLARE @Adiantamento NUMERIC(10,2), @Desconto NUMERIC(10,2), @SubTotal NUMERIC(10,2), @Comissao NUMERIC(10,2), @Total NUMERIC(10,2); 
    DECLARE @Tempo VARCHAR(255); 
    DECLARE @Aberto BIT, @Dias INT, @Horas INT, @Minutos INT, @Segundos INT; 
    DECLARE @Status INT, @Mensagem VARCHAR(2000); 
     
     
    SELECT @SubTotal = SUM(a.Total)  
    FROM dbo.fn_PALM_Pedido_CheckStatus(@Unidade, @Atendimento, 1, 1) AS a 
    WHERE a.Tipo = 'P' 
     
    SET @Comissao = dbo.fn_GetLancamentoComissaoVendedor(@Atendimento,0);  
     
    SET @Total = @SubTotal + @Comissao;  
     
    SELECT  
    	@Aberto = (CASE WHEN CAST(Abertura AS NUMERIC(10,5)) > 0 THEN 1 ELSE 0 END), 
    	@Dias = Dias, 
    	@Horas = Horas, 
    	@Minutos = Minutos, 
    	@Segundos = Segundos 
    FROM dbo.fn_PALM_Atendimento_CheckTempo(@Unidade, @Atendimento) AS a; 
     
    SELECT  
    	@Adiantamento = ad.Adiantamento 
    FROM dbo.fn_PALM_Adiantamentos(@Unidade, @Atendimento) AS ad; 
     
    SELECT  
    	@Desconto = d.Desconto 
    FROM dbo.fn_PALM_Desconto(@Unidade, @Atendimento) AS d; 
     
    SELECT @Status = Status, @Mensagem = Mensagem FROM dbo.fn_PALM_Atendimento_CheckStatus(@Unidade, @Atendimento) AS a; 
     
    IF @Aberto = 1 AND @Status = 0 
    BEGIN 
    	SET @Mensagem = 'Atendimento em andamento'; 
    END; 
    
    INSERT @t(
		[DataHora], [ProdutoID], [ProdutoNome], 
		[Qtd], [Preco], [Un], [TotalUn], 
		[Subtotal], [Taxa], [Total], [Aberto], 
		[Dias], [Horas], [Minutos], [Segundos], 
		[Status], [Mensagem], [Atendentes], 
		[Adiantamento], [Desconto], [TotalAPagar] 	    
    ) 
    SELECT 	 
		[DataHora] = GETDATE(), 
		[ProdutoID] = a.Codigo, 
		[ProdutoNome] = UPPER(a.Descricao), 
		[Qtd] = a.Qde, 
		[Preco] = CAST(a.Total / a.Qde AS NUMERIC(10,2)), 
		[Un] = UPPER(a.Un), 
		[TotalUn] = a.Total, 
		[Subtotal] = @Subtotal, 
		[Taxa] = @Comissao, 
		[Total] = @Total, 
		[Aberto] = @Aberto, 
		[Dias] = @Dias, 
		[Horas] = @Horas, 
		[Minutos] = @Minutos, 
		[Segundos] = @Segundos, 
		[Status] = @Status, 
		[Mensagem] = @Mensagem, 
		[Atendentes] = dbo.fn_GetLancamentoAtendentes(@Atendimento), 
		[Adiantamento] = @Adiantamento, 
		[Desconto] = @Desconto, 
		[TotalAPagar] = (@Total - @Adiantamento - @Desconto) 
    FROM dbo.fn_PALM_Pedido_CheckStatus(@Unidade, @Atendimento, 1, 1) AS a 
    WHERE  
    	a.Tipo = 'P' 

	RETURN;
END;

GO


CREATE FUNCTION dbo.fn_ANDROID_VendedorComissao(@VendedorID INT, @DtIni DATETIME, @DtFim DATETIME)
RETURNS @T TABLE(Posicao INT, Vendedor INT, Nome VARCHAR(255), Dia DATETIME, Comissao MONEY, Comissao1 MONEY, Comissao2 MONEY, Comissao3 MONEY, Comissao4 MONEY, Comissao5 MONEY, Pedidos INT, ValorVendido MONEY, ValorDaComissao MONEY, Atendimentos INT, Pessoas INT, Qde INT)
AS
BEGIN

	INSERT @T(Posicao, Vendedor, Nome, Dia, Comissao, Comissao1, Comissao2, Comissao3, Comissao4, Comissao5, Pedidos, ValorVendido, ValorDaComissao, Atendimentos, Pessoas, Qde)
	SELECT 
		R.Posição, 
		ISNULL(R.Grupo, '0') Grupo, 
		V.Nome Grupo_Nome, 
		R.DataDeEmissão, 
		V.Comissão, 
		V.Comissão1, 
		V.Comissão2, 
		V.Comissão3, 
		V.Comissão4, 
		Comissão5, 
		SUM(R.Pedidos) Pedidos, 
		SUM(R.ValorVendido) ValorVendido, 
		SUM(R.ValorDaComissão) ValorDaComissão, 
		SUM(R.Atendimentos) Atendimentos, 
		SUM(R.Pessoas) Pessoas, 
		SUM(R.Qde) Qde
	FROM 
		(
			SELECT 
				0 Posição, 
				C.Grupo, 
				CONVERT(DATETIME, '', 121) DataDeEmissão, 
				SUM(C.Pedidos) Pedidos, 
				SUM(C.ValorVendido) ValorVendido, 
				SUM(C.ValorDaComissão) ValorDaComissão, 
				SUM(C.Atendimentos) Atendimentos, 
				SUM(C.Pessoas) Pessoas, 
				SUM(C.Qde) Qde
			FROM 
				(
					SELECT 
						C.Grupo, 
						CONVERT(DATETIME, C.DataDeEmissão) DataDeEmissão, 
						SUM(C.Pedidos) Pedidos, 
						SUM(C.ValorVendido) ValorVendido, 
						SUM(C.ValorDaComissão) ValorDaComissão, 
						SUM(C.Atendimentos) Atendimentos, 
						SUM(C.Pessoas) Pessoas, 
						SUM(C.Qde) Qde
					FROM
						(
							SELECT 
								X.Grupo, 
								X.DataDeEmissão, 
								SUM(X.Pedidos) Pedidos, 
								SUM(X.Atendimentos) Atendimentos, 
								SUM(ISNULL(NULLIF(X.Pessoas, 0), 1)) Pessoas, 
								0.00 ValorVendido, 
								0.00 ValorDaComissão, 
								0 QDE
							FROM 
								(
									SELECT 
										P.Vendedor Grupo, 
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										COUNT(DISTINCT P.Lançamento) Atendimentos, 
										COUNT(*) Pedidos, 
										MAX(ISNULL(L.Homens, 0) + ISNULL(L.Mulheres, 0) + ISNULL(L.Crianças, 0)) Pessoas
									FROM
										Lançamentos L 
										JOIN Pedidos P ON L.Código = P.Lançamento
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (P.Vendedor = @VendedorID)
										AND (P.Natureza = -1)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY P.Vendedor, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) X
							GROUP BY X.Grupo, X.DataDeEmissão
							UNION ALL
							SELECT 
								Y.Grupo, 
								Y.DataDeEmissão, 
								0, 
								0, 
								0, 
								SUM(Y.ValorVendido), 
								SUM(Y.ValorDaComissão), 
								0
							FROM 
								(
									SELECT
										LV.VendedorID Grupo,
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										SUM(LV.PrecoTotal) ValorVendido, 
										SUM(LV.ComissaoValor) ValorDaComissão
									FROM
										Lançamentos L 
										LEFT JOIN 
											(
												SELECT
													P.VendedorID,
													P.LancamentoID,
													MAX(P.VendedorComissao) VendedorComissao,
													SUM(R.PrecoTotal) PrecoTotal, 
													SUM(ROUND(CASE WHEN (L.Status & 64) > 0 THEN P.VendedorComissaoValor ELSE $0.00 END , 2, 1)) ComissaoValor
												FROM
													vwLancamentos L 
													JOIN vwPedidos P ON L.LancamentoID = P.LancamentoID
													CROSS APPLY 
													(
														SELECT 
															SUM(R.PrecoTotal) PrecoTotal
														FROM vwPedidosProdutos R
														WHERE
															(R.PedidoID = P.PedidoID) 
															AND (R.SubItem = 0) 
															AND (R.Qde <> 0) 
															AND (R.Fator <> 0) 
															AND (ISNULL(R.Taxa, 0) = 0)
													) R
												WHERE
													(L.Emissao BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121)) 
													AND (P.Natureza = -1)
												GROUP BY P.VendedorID, P.LancamentoID, L.Status, L.AbatimentoPercentual
												HAVING SUM(R.PrecoTotal) > 0
											) LV ON L.Código = LV.LancamentoID
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (LV.VendedorID = @VendedorID)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY LV.VendedorID, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) Y
							GROUP BY Y.Grupo, Y.DataDeEmissão
							UNION ALL
							SELECT 
								Z.Grupo, 
								Z.DataDeEmissão, 
								0, 
								0, 
								0, 
								0, 
								0, 
								SUM(Z.Qde) Qde
							FROM 
								(
									SELECT 
										P.Vendedor Grupo, 
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										SUM(CEILING(R.Qde)) Qde
									FROM
										Lançamentos L 
										JOIN Pedidos P ON L.Código = P.Lançamento 
										JOIN Pedidos_Produtos R ON P.Código = R.Pedido
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (P.Vendedor = @VendedorID)
										AND (P.Natureza = -1) AND (R.SubItem = 0) AND (R.Preço > 0)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY P.Vendedor, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) Z
							GROUP BY Z.Grupo, Z.DataDeEmissão
						) C
					GROUP BY C.Grupo, CONVERT(DATETIME, C.DataDeEmissão)
				) C
			GROUP BY C.Grupo
			UNION ALL
			SELECT 
				1 Posição, 
				C.Grupo, 
				C.DataDeEmissão, 
				SUM(C.Pedidos) Pedidos, 
				SUM(C.ValorVendido) ValorVendido, 
				SUM(C.ValorDaComissão) ValorDaComissão, 
				SUM(C.Atendimentos) Atendimentos, 
				SUM(C.Pessoas) Pessoas, 
				SUM(C.Qde) Qde
			FROM 
				(
					SELECT 
						C.Grupo, 
						CONVERT(DATETIME, C.DataDeEmissão) DataDeEmissão, 
						SUM(C.Pedidos) Pedidos, 
						SUM(C.ValorVendido) ValorVendido, 
						SUM(C.ValorDaComissão) ValorDaComissão, 
						SUM(C.Atendimentos) Atendimentos, 
						SUM(C.Pessoas) Pessoas, 
						SUM(C.Qde) Qde
					FROM
						(
							SELECT 
								X.Grupo, 
								X.DataDeEmissão, 
								SUM(X.Pedidos) Pedidos, 
								SUM(X.Atendimentos) Atendimentos, 
								SUM(ISNULL(NULLIF(X.Pessoas, 0), 1)) Pessoas, 
								0.00 ValorVendido, 
								0.00 ValorDaComissão, 
								0 QDE
							FROM 
								(
									SELECT 
										P.Vendedor Grupo, 
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										COUNT(DISTINCT P.Lançamento) Atendimentos, 
										COUNT(*) Pedidos, 
										MAX(ISNULL(L.Homens, 0) + ISNULL(L.Mulheres, 0) + ISNULL(L.Crianças, 0)) Pessoas
									FROM
										Lançamentos L 
										JOIN Pedidos P ON L.Código = P.Lançamento
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (P.Vendedor = @VendedorID)
										AND (P.Natureza = -1)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY P.Vendedor, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) X
							GROUP BY X.Grupo, X.DataDeEmissão
							UNION ALL
							SELECT 
								Y.Grupo, 
								Y.DataDeEmissão, 
								0, 
								0, 
								0, 
								SUM(Y.ValorVendido), 
								SUM(Y.ValorDaComissão), 
								0
							FROM 
								(
									SELECT
										LV.VendedorID Grupo,
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										SUM(LV.PrecoTotal) ValorVendido, 
										SUM(LV.ComissaoValor) ValorDaComissão
									FROM
										Lançamentos L 
										LEFT JOIN 
											(
												SELECT
													P.VendedorID,
													P.LancamentoID,
													MAX(P.VendedorComissao) VendedorComissao,
													SUM(R.PrecoTotal) PrecoTotal, 
													SUM(ROUND(CASE WHEN (L.Status & 64) > 0 THEN P.VendedorComissaoValor ELSE $0.00 END , 2, 1)) ComissaoValor
												FROM
													vwLancamentos L 
													JOIN vwPedidos P ON L.LancamentoID = P.LancamentoID
													CROSS APPLY
														(
															SELECT 
																SUM(R.PrecoTotal) PrecoTotal
															FROM vwPedidosProdutos R
															WHERE
																(R.PedidoID = P.PedidoID) 
																AND (R.SubItem = 0) 
																AND (R.Qde <> 0) 
																AND (R.Fator <> 0) 
																AND (ISNULL(R.Taxa, 0) = 0)
														) R
												WHERE
													(L.Emissao BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121)) 
													AND (P.Natureza = -1)
												GROUP BY P.VendedorID, P.LancamentoID, L.Status, L.AbatimentoPercentual
												HAVING SUM(R.PrecoTotal) > 0
											) LV ON L.Código = LV.LancamentoID
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (LV.VendedorID = @VendedorID)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY  LV.VendedorID, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) Y
							GROUP BY Y.Grupo, Y.DataDeEmissão
							UNION ALL
							SELECT 
								Z.Grupo, 
								Z.DataDeEmissão, 
								0, 
								0, 
								0, 
								0, 
								0, 
								SUM(Z.Qde) Qde
							FROM 
								(
									SELECT 
										P.Vendedor Grupo, 
										FLOOR(CONVERT(FLOAT, L.DataDeEmissão)) DataDeEmissão, 
										SUM(CEILING(R.Qde)) Qde
									FROM
										Lançamentos L 
										JOIN Pedidos P ON L.Código = P.Lançamento 
										JOIN Pedidos_Produtos R ON P.Código = R.Pedido
									WHERE
										(L.DataDeEmissão BETWEEN CONVERT(DATETIME, @DtIni, 121) AND CONVERT(DATETIME, @DtFim, 121))
										AND (P.Vendedor = @VendedorID)
										AND (P.Natureza = -1) 
										AND (R.SubItem = 0) 
										AND (R.Preço > 0)
										AND (L.Tipo BETWEEN 16 AND 64)
									GROUP BY P.Vendedor, FLOOR(CONVERT(FLOAT, L.DataDeEmissão))
								) Z
							GROUP BY Z.Grupo, Z.DataDeEmissão
						) C
					GROUP BY C.Grupo, CONVERT(DATETIME, C.DataDeEmissão)
				) C
			GROUP BY C.Grupo, C.DataDeEmissão
		) R 
		LEFT JOIN Fornecedores V ON ISNULL(R.Grupo, '0') = V.Código
	GROUP BY R.Posição, R.Grupo, V.Nome, R.DataDeEmissão, V.Comissão, V.Comissão1, V.Comissão2, V.Comissão3, V.Comissão4, V.Comissão5
	ORDER BY R.Posição, V.Nome, R.DataDeEmissão;
	
	RETURN;

END;

GO

CREATE FUNCTION fn_ANDROID_AtendimentosAbertos(@VendedorID INT, @UnidadeID INT)
RETURNS @T2 TABLE(VendedorID INT, Qtd INT, TotalVendido MONEY, Media MONEY)
AS
BEGIN
	DECLARE @SomenteAbertas BIT;
	SET @SomenteAbertas = 1;
	DECLARE @T TABLE(VendedorID INT, Qtd INT, TotalVendido MONEY, Media MONEY)

	INSERT @T(VendedorID, Qtd, TotalVendido, Media)
	SELECT 
		[VendedorID] = LV.VendedorID,
		[Qtd] = COUNT(DISTINCT L.LancamentoID), 
		[TotalVendido] = SUM(ISNULL(LV.PrecoTotal, 0.0)),
		[Media] = SUM(ISNULL(LV.PrecoTotal, 0.0)) / COUNT(DISTINCT L.LancamentoID) 
	FROM
		vwLancamentos L 
		LEFT JOIN (
			SELECT 
				p.VendedorID,
				P.LancamentoID,
				MAX(P.VendedorComissao) VendedorComissao,
				COUNT(*) Pedidos,
				SUM(R.TaxaDeEntrega) TaxaDeEntrega,
				SUM(R.PrecoTotal) PrecoTotal,
				SUM(R.Itens) Itens,
				SUM(R.DescontoItem) DescontoItem,
				SUM(ROUND(CASE WHEN (L.Status & 64) > 0 THEN P.VendedorComissaoValor ELSE $0.00 END , 2, 1)) ComissaoValor
			FROM
				vwLancamentos L 
				JOIN vwPedidos P ON L.LancamentoID = P.LancamentoID
				CROSS APPLY (
					SELECT 
						SUM(CASE WHEN ISNULL(R.Taxa, 0) = 0 THEN R.PrecoTotal ELSE 0.00 END) PrecoTotal,                
						SUM(CASE WHEN R.Taxa = 20 THEN R.PrecoTotal ELSE 0.00 END) TaxaDeEntrega,   
						SUM(CASE WHEN ISNULL(R.Taxa, 0) = 0 THEN CEILING(R.Qde) ELSE 0.0 END) Itens,                    
						SUM(CASE WHEN ISNULL(R.Desconto, 0) = 0 THEN 0.00 ELSE R.Desconto END) DescontoItem             
					FROM vwPedidosProdutos R
					WHERE
						(R.PedidoID = P.PedidoID) 
						AND (R.SubItem = 0) 
						AND (R.Qde <> 0) 
						AND (R.Fator <> 0)
				) R
			WHERE
				(@VendedorID = 0 OR P.VendedorID = @VendedorID)
				AND (L.Emissao IS NULL) 
				AND (L.UnidadeID = @UnidadeID) 
				AND (P.Natureza = -1)
			GROUP BY P.VendedorID, P.LancamentoID
			HAVING SUM(R.PrecoTotal) > 0
		) LV ON L.LancamentoID = LV.LancamentoID
	WHERE
		(LV.VendedorID = @VendedorID)
		AND (L.Emissao IS NULL) 
		AND (L.UnidadeID = @UnidadeID) 
		AND (L.Tipo BETWEEN 16 AND 64) 
		AND (L.OperacaoID IS NULL)
	GROUP BY LV.VendedorID
	UNION
	SELECT 
		[VendedorID] = LV.VendedorID,
		[Qtd] = COUNT(DISTINCT L.LancamentoID), 
		[TotalVendido] = ISNULL(SUM(ISNULL(LV.PrecoTotal, 0.0)),0),	
		[Media] = ISNULL(SUM(ISNULL(LV.PrecoTotal, 0.0)) / COUNT(DISTINCT L.LancamentoID), 0)
	FROM
		vwLancamentos L 
		LEFT JOIN (
			SELECT 
				P.VendedorID,
				P.LancamentoID,
				MAX(P.VendedorComissao) VendedorComissao,
				COUNT(*) Pedidos,
				SUM(R.TaxaDeEntrega) TaxaDeEntrega,
				SUM(R.PrecoTotal) PrecoTotal,
				SUM(R.Itens) Itens,
				SUM(R.DescontoItem) DescontoItem,
				SUM(ROUND(CASE WHEN (L.Status & 64) > 0 THEN P.VendedorComissaoValor ELSE $0.00 END , 2, 1)) ComissaoValor
			FROM
				vwLancamentos L 
				JOIN vwPedidos P ON L.LancamentoID = P.LancamentoID
				CROSS APPLY (
					SELECT 
						SUM(CASE WHEN ISNULL(R.Taxa, 0) = 0 THEN R.PrecoTotal ELSE 0.00 END) PrecoTotal,                
						SUM(CASE WHEN R.Taxa = 20 THEN R.PrecoTotal ELSE 0.00 END) TaxaDeEntrega,   
						SUM(CASE WHEN ISNULL(R.Taxa, 0) = 0 THEN CEILING(R.Qde) ELSE 0.0 END) Itens,                    
						SUM(CASE WHEN ISNULL(R.Desconto, 0) = 0 THEN 0.00 ELSE R.Desconto END) DescontoItem             
					FROM vwPedidosProdutos R
					WHERE
						(R.PedidoID = P.PedidoID) 
						AND (R.SubItem = 0) 
						AND (R.Qde <> 0) 
						AND (R.Fator <> 0)
				) R
			WHERE
				(@VendedorID = 0 OR P.VendedorID = @VendedorID)
				AND (NOT ((L.Status  &  1) > 0) AND (L.Tipo BETWEEN 16 AND 64) AND (L.Emissao IS NOT NULL)) 
				AND (P.Natureza = -1)
			GROUP BY P.VendedorID, P.LancamentoID
			HAVING SUM(R.PrecoTotal) > 0
		) LV ON L.LancamentoID = LV.LancamentoID
	WHERE 
		LV.VendedorID = @VendedorID
		AND (NOT ((L.Status  &  1) > 0))
		AND (L.Tipo BETWEEN 16 AND 64) 
		AND (L.Emissao IS NOT NULL)
		AND NOT(@SomenteAbertas = 1)
	GROUP BY LV.VendedorID;

	IF (SELECT COUNT(*) FROM @T) = 0
	BEGIN
		INSERT @T(VendedorID, Qtd, TotalVendido, Media) VALUES(0,0,0,0);
	END;

	INSERT @T2
	SELECT VendedorID = ISNULL(VendedorID,0), Qtd = SUM(Qtd), TotalVendido = SUM(TotalVendido), Media = SUM(Media) FROM @T AS [T] GROUP BY VendedorID;

	RETURN;
END;

GO

CREATE FUNCTION fn_GetPrecoDeVenda_PorUnidade(@ProdutoID BIGINT, @UnidadeID BIGINT)
RETURNS MONEY
AS
BEGIN

	DECLARE 
		@PrecoID BIGINT, 
		@Preco MONEY;

	SELECT TOP 1 @PrecoID = PrecoID
	FROM UnidadesModalidades
	WHERE
		UnidadeID = @UnidadeID
		AND ModalidadeID IN
		(

			SELECT
				ModalidadeID
			FROM
				(SELECT
					UnidadeID, ModalidadeID
				FROM 
					(SELECT
						UnidadeID, 
						ModalidadeID, 
						Qtd = COUNT(*)
					FROM vwAtendimentos
					GROUP BY UnidadeID, ModalidadeID) a
				WHERE
					a.Qtd IN
						(SELECT
							MAX(m.Qtd)
						FROM 
							(SELECT
								a2.UnidadeID, 
								a2.ModalidadeID, 
								Qtd = COUNT(*)
							FROM vwAtendimentos a2
							WHERE 
								a2.UnidadeID = a.UnidadeID
							GROUP BY a2.UnidadeID, a2.ModalidadeID) m
						GROUP BY m.UnidadeID)) um
			WHERE
				um.UnidadeID = @UnidadeID
		);

	SET @PrecoID = ISNULL(@PrecoID, 1);

	SELECT @Preco = Preco 
	FROM vwProdutosPrecosDeVenda
	WHERE 
		ProdutoID = @ProdutoID
		AND PrecoID = @PrecoID;

	RETURN(@Preco);
END;

GO



DECLARE @cmd NVARCHAR(MAX), @n VARCHAR(2);

SET @cmd = '';
SET @n = '' + CHAR(13) + CHAR(10);

IF NOT EXISTS(SELECT 1 FROM SysObjects o WHERE o.id = OBJECT_ID('ReservasDeMesas'))
BEGIN
	
	SET @cmd = @cmd + 'CREATE TABLE dbo.ReservasDeMesas ' + @n;
	SET @cmd = @cmd + '(' + @n;
	SET @cmd = @cmd + '	[ID] INT IDENTITY(100000,1) NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Inclusao] DATETIME NOT NULL, -- GETDATE()' + @n;
	SET @cmd = @cmd + '	[Edicao] DATETIME NOT NULL, -- GETDATE() a cada alteração' + @n;
	SET @cmd = @cmd + '	[Status] SMALLINT NOT NULL, -- 0' + @n;
	SET @cmd = @cmd + '	[UsuarioID] INT NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Ambiente] TINYINT NOT NULL, -- 0' + @n;
	SET @cmd = @cmd + '	[UnidadeID] TINYINT NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Nome] VARCHAR(60) NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Telefone] VARCHAR(60) NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Pessoas] SMALLINT NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Prioridade] BIT NOT NULL,' + @n;
	SET @cmd = @cmd + '	[Situacao] TINYINT NOT NULL, -- 0 Aguardando, 1 Confirmada, 9 Cancelada' + @n;
	SET @cmd = @cmd + '	[Mesa] INT NULL,' + @n;
	SET @cmd = @cmd + '	CONSTRAINT PK_ReservasDeMesas PRIMARY KEY CLUSTERED (ID)' + @n;
	SET @cmd = @cmd + '); ';

	EXEC sp_ExecuteSQL @cmd;

END
ELSE
BEGIN

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Inclusao')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Inclusao] DATETIME NOT NULL DEFAULT(GETDATE()); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Edicao')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Edicao] DATETIME NOT NULL DEFAULT(GETDATE()); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Status')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Status] SMALLINT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'UsuarioID')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [UsuarioID] INT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Ambiente')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Ambiente] TINYINT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'UnidadeID')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [UnidadeID] TINYINT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Nome')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Nome] VARCHAR(60) NOT NULL DEFAULT(''X''); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Telefone')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Telefone] VARCHAR(60) NOT NULL DEFAULT(''X''); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Pessoas')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Pessoas] SMALLINT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Prioridade')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Prioridade] BIT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Situacao')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Situacao] TINYINT NOT NULL DEFAULT(0); ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

	IF NOT EXISTS(SELECT 1 FROM SysColumns c WHERE c.id = OBJECT_ID('ReservasDeMesas') AND c.Name = 'Mesa')
	BEGIN
		SET @cmd = 'ALTER TABLE [ReservasDeMesas] ADD [Mesa] INT NULL; ';
		EXEC sp_ExecuteSQL @cmd;	
	END;

END;

GO

IF NOT EXISTS(SELECT 1 FROM Sysindexes i WHERE Name = 'IX_ReservasDeMesas')
BEGIN
	EXEC sp_ExecuteSQL N'
	CREATE INDEX IX_ReservasDeMesas ON dbo.ReservasDeMesas
	(
		Situacao,
		Inclusao DESC
	); ';
END;

GO


/****
* Função que adiciona uma nova reserva
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('sp_ReservasDeMesas_Adicionar'))
BEGIN
	DROP PROCEDURE sp_ReservasDeMesas_Adicionar;
END;

GO

CREATE PROCEDURE dbo.sp_ReservasDeMesas_Adicionar
(
	@UsuarioID int,	
	@UnidadeID tinyint,	
	@Nome varchar(60),	
	@Telefone varchar(60),	
	@Pessoas smallint,	
	@Prioridade bit
)
AS
BEGIN
	DECLARE @now datetime; SET @now = GETDATE();
	DECLARE @id int; SET @id = 0;

	IF NOT EXISTS(SELECT * FROM dbo.ReservasDeMesas WHERE Nome = @Nome AND Telefone = @Telefone AND [Situacao] = 0)
	BEGIN
		INSERT dbo.ReservasDeMesas(Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao)
		VALUES(@now, @now, 0, @UsuarioID, 0, @UnidadeID, @Nome, @Telefone, @Pessoas, @Prioridade, 0);
		SET @id = @@IDENTITY;
	END;
	SELECT [id] = @id;
END;

GO

/****
* Função que adiciona uma nova reserva futura
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('sp_ReservasDeMesas_AdicionarFutura'))
BEGIN
	DROP PROCEDURE sp_ReservasDeMesas_AdicionarFutura;
END;

GO

CREATE PROCEDURE dbo.sp_ReservasDeMesas_AdicionarFutura
(
	@UsuarioID int,	
	@UnidadeID tinyint,	
	@Nome varchar(60),	
	@Telefone varchar(60),	
	@Pessoas smallint,	
	@Prioridade bit,
	@DataHora datetime
)
AS
BEGIN	
	DECLARE @id int; SET @id = 0;

	IF ((@DataHora > GETDATE()) AND (NOT EXISTS(SELECT * FROM dbo.ReservasDeMesas WHERE Nome = @Nome AND Telefone = @Telefone AND [Situacao] = 0)))
	BEGIN
		INSERT dbo.ReservasDeMesas(Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao)
		VALUES(@DataHora, @DataHora, 0, @UsuarioID, 0, @UnidadeID, @Nome, @Telefone, @Pessoas, @Prioridade, 0);
		SET @id = @@IDENTITY;
	END;
	SELECT [id] = @id;
END;

GO


/****
* Aplica a confirmação de uma reserva
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('sp_ReservasDeMesas_Confirmar'))
BEGIN
	DROP PROCEDURE sp_ReservasDeMesas_Confirmar;
END;

GO

CREATE PROCEDURE dbo.sp_ReservasDeMesas_Confirmar(@id int, @mesa int)
AS
BEGIN
	DECLARE @now datetime; SET @now = GETDATE();
	DECLARE @ok bit; SET @ok = 0;

	IF EXISTS(SELECT * FROM dbo.ReservasDeMesas WHERE id = @id AND [Situacao] = 0)
	BEGIN
		UPDATE  dbo.ReservasDeMesas
		SET 
			[Situacao] = 1,
			[Edicao] = @now,
			[Mesa] = @mesa
		WHERE id = @id;
		SET @ok = 1;
	END;

	SELECT [ok] = @ok;
END;

GO


/****
* Aplica o cancelamento de uma reserva
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('sp_ReservasDeMesas_Cancelar'))
BEGIN
	DROP PROCEDURE sp_ReservasDeMesas_Cancelar;
END;

GO

CREATE PROCEDURE dbo.sp_ReservasDeMesas_Cancelar(@id int)
AS
BEGIN
	DECLARE @now datetime; SET @now = GETDATE();
	DECLARE @ok bit; SET @ok = 0;

	IF EXISTS(SELECT * FROM dbo.ReservasDeMesas WHERE id = @id AND [Situacao] = 0)
	BEGIN
		UPDATE  dbo.ReservasDeMesas
		SET 
			[Situacao] = 2,
			[Edicao] = @now
		WHERE id = @id;
		SET @ok = 1;
	END;

	SELECT [ok] = @ok;
END;

GO


/****
* Aplica o cancelamento de todas as reservas de um atendente
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('sp_ReservasDeMesas_CancelarTodas'))
BEGIN
	DROP PROCEDURE sp_ReservasDeMesas_CancelarTodas;
END;

GO

CREATE PROCEDURE dbo.sp_ReservasDeMesas_CancelarTodas(@UsuarioID int)
AS
BEGIN
	DECLARE @now datetime; SET @now = GETDATE();
	DECLARE @ok bit; SET @ok = 0;

	IF EXISTS(SELECT * FROM dbo.ReservasDeMesas WHERE UsuarioID = @UsuarioID AND [Situacao] = 0)
	BEGIN
		UPDATE  dbo.ReservasDeMesas
		SET 
			[Situacao] = 2,
			[Edicao] = @now
		WHERE 
			UsuarioID = @UsuarioID
			AND [Situacao] = 0;
		SET @ok = 1;
	END;

	SELECT [ok] = @ok;
END;

GO


/****
* Lista todas as reservas de um atendente
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('fn_ReservasDeMesas_ListarReservas'))
BEGIN
	DROP FUNCTION fn_ReservasDeMesas_ListarReservas;
END;

GO

CREATE FUNCTION dbo.fn_ReservasDeMesas_ListarReservas(@UsuarioID int)
RETURNS @t TABLE (
	Id int, 
	Inclusao datetime, 
	Edicao datetime, 
	[Status] smallint, 
	UsuarioID int, 
	Ambiente tinyint, 
	UnidadeID tinyint,
	Nome varchar(60),
	Telefone varchar(60),
	Pessoas smallint,
	Prioridade bit,
	Situacao tinyint,
	Mesa int)
AS
BEGIN	

	INSERT @t(ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa)
	SELECT ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa 
	FROM dbo.ReservasDeMesas
	WHERE 
		(@UsuarioID = 0 OR UsuarioID = @UsuarioID)
		AND ISNULL([Situacao],0) = 0
	ORDER BY Prioridade DESC, Inclusao ASC

	RETURN;
END;

GO


/****
* Lista todas as reservas confirmadas de um atendente desde um momento (data/hora) inicial
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('fn_ReservasDeMesas_ListarReservasConfirmadas'))
BEGIN
	DROP FUNCTION fn_ReservasDeMesas_ListarReservasConfirmadas;
END;

GO

CREATE FUNCTION dbo.fn_ReservasDeMesas_ListarReservasConfirmadas(@UsuarioID int, @dataInicial datetime)
RETURNS @t TABLE (
	Id int, 
	Inclusao datetime, 
	Edicao datetime, 
	[Status] smallint, 
	UsuarioID int, 
	Ambiente tinyint, 
	UnidadeID tinyint,
	Nome varchar(60),
	Telefone varchar(60),
	Pessoas smallint,
	Prioridade bit,
	Situacao tinyint,
	Mesa int)
AS
BEGIN	

	INSERT @t(ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa)
	SELECT ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa 
	FROM dbo.ReservasDeMesas
	WHERE 
		(@UsuarioID = 0 OR UsuarioID = @UsuarioID)
		AND ISNULL([Situacao],0) = 1
		AND Inclusao >= ISNULL(@dataInicial, GETDATE() - 1)
	ORDER BY Prioridade DESC, Inclusao ASC

	RETURN;
END;

GO


/****
* Lista todas as reservas canceladas de um atendente desde um momento (data/hora) inicial
* Data da criação: 1/dez/2014 16:40
* Autor: Nelson
****/

IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('fn_ReservasDeMesas_ListarReservasCanceladas'))
BEGIN
	DROP FUNCTION fn_ReservasDeMesas_ListarReservasCanceladas;
END;

GO

CREATE FUNCTION dbo.fn_ReservasDeMesas_ListarReservasCanceladas(@UsuarioID int, @dataInicial datetime)
RETURNS @t TABLE (
	Id int, 
	Inclusao datetime, 
	Edicao datetime, 
	[Status] smallint, 
	UsuarioID int, 
	Ambiente tinyint, 
	UnidadeID tinyint,
	Nome varchar(60),
	Telefone varchar(60),
	Pessoas smallint,
	Prioridade bit,
	Situacao tinyint,
	Mesa int)
AS
BEGIN	

	INSERT @t(ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa)
	SELECT ID, Inclusao, Edicao, [Status], UsuarioID, Ambiente, UnidadeID, Nome, Telefone, Pessoas, Prioridade, Situacao, Mesa 
	FROM dbo.ReservasDeMesas
	WHERE 
		(@UsuarioID = 0 OR UsuarioID = @UsuarioID)
		AND ISNULL([Situacao],0) = 2
		AND Inclusao >= ISNULL(@dataInicial, GETDATE() - 1)
	ORDER BY Prioridade DESC, Inclusao ASC

	RETURN;
END;

GO


IF EXISTS(SELECT * FROM SysObjects WHERE id = OBJECT_ID('vw_PALM_AtendimentosAbertos2'))
BEGIN
	DROP VIEW vw_PALM_AtendimentosAbertos2;
END;

GO

IF NOT EXISTS(SELECT * FROM SysObjects o WHERE o.id = OBJECT_ID('vw_PALM_AtendimentosAbertos2'))
BEGIN

	EXEC sp_ExecuteSQL N'
	CREATE VIEW [dbo].[vw_PALM_AtendimentosAbertos2]
	AS
	SELECT DISTINCT
		[Unidade] = l.Unidade,
		[Atendimento] = l.Atendimento, 
		[HoraAbertura] = l.DataDaInclusão,
		[CheckIn] = ISNULL(a.CheckIn,0),
		[Conta_Impressa] = (case when (l.status & 32 > 0) then 1 else 0 end),
		[HoraConta] = (CASE WHEN (case when (l.status & 32 > 0) then 1 else 0 end) = 1 THEN l.DataDeEdição ELSE NULL END)
	FROM Lançamentos l INNER JOIN Atendimentos a ON l.Atendimento = a.Atendimento
	WHERE 
		((l.Unidade = a.Unidade) OR (a.Unidade IS NULL) OR (l.Unidade IS NULL))
		AND (l.datadeemissão is null) 
		AND (l.ConexãoDaEmissão is null)
		AND (l.Atendimento IS NOT NULL); ';

END;

GO

DECLARE @cmd NVARCHAR(MAX);
IF EXISTS(SELECT 1 FROM SysObjects t WHERE t.id = OBJECT_ID('Remoto_Pedidos_Historico'))
BEGIN
	SET @cmd = N'DROP TABLE [dbo].[Remoto_Pedidos_Historico]; ';
	EXEC sp_ExecuteSQL @cmd;
END;

IF NOT EXISTS(SELECT 1 FROM SysObjects t WHERE t.id = OBJECT_ID('Remoto_Pedidos_Historico'))
BEGIN
	SET @cmd = N'
		CREATE TABLE [dbo].[Remoto_Pedidos_Historico](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remoto_PedidosID] [uniqueidentifier] NOT NULL,
			[Opcional] [bit] NOT NULL,
			[DataHora] [datetime] NOT NULL,
			CONSTRAINT [PK_Remoto_Pedidos_Historico] PRIMARY KEY CLUSTERED 
			(
				[Id] ASC
			) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY];
		';
	EXEC sp_ExecuteSQL @cmd;

	SET @cmd = 
		'ALTER TABLE [dbo].[Remoto_Pedidos_Historico] ADD  CONSTRAINT [DF_Table_Remoto_Pedidos_Historico_Opcional]  DEFAULT (0) FOR [Opcional]; ';
	EXEC sp_ExecuteSQL @cmd;

	SET @cmd = 
		'ALTER TABLE [dbo].[Remoto_Pedidos_Historico] ADD  CONSTRAINT [DF_Remoto_Pedidos_Historico_DataHora]  DEFAULT (GETDATE()) FOR [DataHora]; ';
	EXEC sp_ExecuteSQL @cmd;

END;

GO



DECLARE @tb VARCHAR(255);
SET @tb = 'Produtos';
EXEC sp_CreateColumn @tb, 'ProdutoEncerrandoAtendimento', 'BIT NOT NULL DEFAULT(0)', null;

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vw_PALM_AtendimentosEncerrando]') AND type in (N'V'))
BEGIN
	DROP VIEW [dbo].[vw_PALM_AtendimentosEncerrando];
END;

GO

CREATE VIEW [vw_PALM_AtendimentosEncerrando]
AS
(
	SELECT 
		[UnidadeID] = a.Unidade, 
		[AtendimentoID] = a.Atendimento, 
		[HoraAbertura] = a.HoraAbertura, 
		[HoraConta] = a.HoraConta, 
		[ContaImpressa] = a.Conta_Impressa
	FROM vw_PALM_AtendimentosAbertos2 a 
		CROSS APPLY [dbo].[fn_PALM_Pedido_Listar](a.Unidade, a.Atendimento, 1, 1) p
		INNER JOIN Produtos p2 ON p.Codigo = p2.Código
	WHERE 
		p.Tipo = 'P'
		AND ISNULL(p2.ProdutoEncerrandoAtendimento,0) = 1
);

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_PALM_AtendimentoEncerrando]') AND type in (N'FN'))
BEGIN
	DROP FUNCTION [dbo].[fn_PALM_AtendimentoEncerrando];
END;

GO

CREATE FUNCTION fn_PALM_AtendimentoEncerrando(@unidadeID INT, @atendimentoID INT)
RETURNS BIT
AS
BEGIN
	DECLARE @r BIT; SET @r = 0;
	IF EXISTS(SELECT 1 FROM [vw_PALM_AtendimentosEncerrando] a WHERE UnidadeID = @unidadeID AND AtendimentoID = @atendimentoID)
		SET @r = 1;
	RETURN(@r);
END;

GO

IF NOT EXISTS(SELECT * FROM Produtos p WHERE p.ProdutoEncerrandoAtendimento = 1)
BEGIN
	ALTER TABLE Produtos DISABLE TRIGGER ALL
	UPDATE p
	SET p.ProdutoEncerrandoAtendimento = 1
	FROM Categorias c INNER JOIN Produtos p ON c.Código = p.Categoria
	WHERE (c.Descrição LIKE '%SOBREME%' OR c.Descrição LIKE '%CAF[E,É]%' OR c.Descrição LIKE '%LICOR%')
	ALTER TABLE Produtos ENABLE TRIGGER ALL;
END;

GO

ALTER VIEW [dbo].[vw_PALM_Cg_Produtos_Composicoes]
AS
(
	SELECT DISTINCT
		[CategoriaID] = ISNULL(Cat.CategoriaID,0),
		[CategoriaNome] = ISNULL(Cat.CategoriaNome,'OUTROS'),  
		[ProdutoID] = C.ProdutoID,
		[ProdutoNome] = D_Pai.ProdutoNome, 
		[SubProdutoID] = C.Produto2ID, 
		[SubProdutoNome] = D.ProdutoNome, 
		[Preco] = dbo.fn_GetPrecoDeVenda(c.ProdutoID, 1),
		[Fracionavel] = ISNULL(D.Fracionado,0),
		[Partes] = ISNULL(D_Pai.QDEItens, 1),
		[Tipo] = (
			CASE 
				WHEN C.TIPO = 5 THEN 'O'
				WHEN C.TIPO = 10 THEN 'A'
				WHEN C.TIPO = 15 THEN 'M'
				ELSE 'O'
			END), 
		
		[TemMontagem] = ISNULL(D.Montagem, 0), 
		[SubProdutoQuantidade] = C.QDE, 		
		[AceitaPrecoZero] = C.PrecoZero, 
		[Unidade] = PU.UnidadeID
	FROM
		vwProdutosComposicoes C JOIN
		vwProdutos D ON D.ProdutoID = C.Produto2ID JOIN
		vwProdutos D_Pai ON D_Pai.ProdutoID = C.ProdutoID JOIN
		vwProdutosUnidades PU ON D.ProdutoID = PU.ProdutoID OUTER APPLY
		(SELECT TOP 1 cc.CategoriaID, cc.CategoriaNome FROM vwCategorias cc WHERE cc.CategoriaID = ISNULL(C.GrupoDeOpcionais, D.CategoriaID)) AS Cat
	WHERE
		--(C.ProdutoID = 46) AND
		(C.Baixar = 0)
		AND (C.GrupoDeOpcionais > -1)
		AND ((D.Venda = 1) OR (C.Tipo = 1))
		AND (D.Ativo = 1)
		AND (C.Ativo = 1)		
		AND (c.Tipo IS NULL OR c.Tipo IN (5,10,15))
		AND (PU.Ativo = 1) 
	--	AND PU.UnidadeID = dbo.GetUnidadeLocal()
	--ORDER BY C.Tipo, C.GrupoDeOpcionais, D.CategoriaID, C.Produto2ID
);


GO

ALTER TABLE REMOTO_PEDIDOS ADD DeviceID varchar(20);

GO

IF NOT EXISTS(SELECT 1 FROM SysObjects t WHERE t.id = OBJECT_ID('RemotoAcompanhamentoProducao'))
BEGIN
CREATE TABLE dbo.RemotoAcompanhamentoProducao
	(
	Código int NOT NULL IDENTITY (1, 1),
	DataDeInclusão datetime NULL,
	DataDeEdição datetime NULL,
	DeviceID varchar(20) NULL,
	PedidoID int NULL,
	Status int NULL
	)  ON [PRIMARY]
END;

GO

ALTER TABLE dbo.RemotoAcompanhamentoProducao SET (LOCK_ESCALATION = TABLE)

GO

IF NOT EXISTS(SELECT 1 FROM SysObjects t WHERE t.id = OBJECT_ID('Remoto_Pagamentos'))
BEGIN
 CREATE TABLE dbo.Remoto_Pagamentos
	(
	Código int NOT NULL IDENTITY (1, 1),
	DataDaInclusão smalldatetime NOT NULL,
	DataDeEdição smalldatetime NOT NULL,
	Status int NOT NULL,
	Atendimento int NULL,
	Bandeira varchar(20) NULL,
	CodAutorizacaoTrans varchar(45) NULL,
	CodFormaPagamento int NULL,
	CodTipoFormaPagamento int NULL,
	FormaPagamento varchar(20) NULL,
	IntegradoraId varchar(45) NULL,
	MaskNumCartao varchar(20) NULL,
	NumParcelas int NULL,
	NumTerminal varchar(45) NULL,
	PagamentoTransId varchar(15) NULL,
	TipoFormaPagamento varchar(50) NULL,
	TipoIntegradora int NULL,
	ValorPago money NULL,
	Unidade int NULL,
	NSU varchar(6)
	)  ON [PRIMARY]

DECLARE @v sql_variant 
SET @v = N'Tabela de pagamentos efetuados pelas integradoras via dispositivos e chamadas remotas'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Remoto_Pagamentos', NULL, NULL
END;

GO

ALTER TABLE dbo.Remoto_Pedidos ADD CONSTRAINT
	PK_Remoto_Pedidos PRIMARY KEY CLUSTERED 
	(
	Código
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

ALTER TABLE dbo.Remoto_Pedidos SET (LOCK_ESCALATION = TABLE)

GO

ALTER TABLE dbo.Remoto_Pagamentos SET (LOCK_ESCALATION = TABLE)

GO

ALTER FUNCTION [dbo].[fn_GetLancamentoComissaoVendedor]
(
@LancamentoID BIGINT,
@Status SMALLINT
)
RETURNS MONEY
BEGIN
IF (@LancamentoID < 10000)
BEGIN
SELECT @LancamentoID = LancamentoID, @Status = Status
FROM vwLancamentos
WHERE
(Emissao IS NULL) AND
(Atendimento = @LancamentoID) AND	
(UnidadeID = dbo.GetUnidadeLocal());
IF (@LancamentoID IS NULL)
RETURN 0.00;
END;
IF (@Status IS NULL)
RETURN 0.00;
IF ((@Status & 64) = 0)
RETURN 0.00;
DECLARE @Retorno MONEY;
SELECT @Retorno = ROUND(SUM(VendedorComissaoValor), 2, 1) 
FROM vwPedidos
WHERE
(LancamentoID = @LancamentoID) AND
(Natureza = -1);
SET @Retorno = ISNULL(@Retorno,0);	
RETURN @Retorno;
END;

GO

ALTER FUNCTION [dbo].[fn_PALM_Adiantamentos](@Unidade INT, @Atendimento INT)
RETURNS @t TABLE(Lancamento INT, Adiantamento MONEY)
AS
BEGIN

DECLARE @Lancamento INT;
DECLARE @Adiantamento MONEY;

SELECT 
@Lancamento = L.Código
FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
WHERE 
(L.DataDeEmissão IS NULL) 
AND ((L.Atendimento = @Atendimento AND L.Unidade = @Unidade) OR @Atendimento = 0) 
AND (L.Atendimento IS NOT NULL)
AND ((L.Status % 2) = 0)
AND (P.Natureza = -1) 
AND (R.SubItem = 0)
AND (R.Fator > 0)

SELECT @Adiantamento = SUM(Valor)
FROM
 vwContas
WHERE
 (LancamentoID IN (@Lancamento))	
 AND (Natureza <> 0);

SET @Lancamento = ISNULL(@Lancamento,0);
SET @Adiantamento = ISNULL(@Adiantamento,0);

INSERT @t(Lancamento, Adiantamento)
SELECT [Lancamento] = @Lancamento, [Adiantamento] =  @Adiantamento

RETURN;
END;
GO
