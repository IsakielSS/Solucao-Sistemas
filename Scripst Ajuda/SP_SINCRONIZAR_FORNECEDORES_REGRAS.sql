-- STORED PROCEDURE PARA SINCRONIZAÇÃO AUTOMÁTICA
-- Execute: EXEC SP_SINCRONIZAR_FORNECEDORES_REGRAS
-- 
-- =============================================
-- PONTOS QUE VOCÊ PRECISA ALTERAR:
-- =============================================
-- 1. LINHA 18: @MatrizServer - Nome do servidor da matriz
-- 2. LINHA 19: @MatrizDatabase - Nome do banco da matriz (se diferente)
-- 3. LINHA 20: Nome da tabela na matriz (se diferente)
-- 4. LINHA 21: Nome da tabela na filial (se diferente)
-- 5. LINHA 22-26: Nomes das colunas (se diferentes)
-- =============================================

USE [TorreDoSol_Conveniencia]  -- << ALTERAR: Nome do banco da filial se diferente
GO

CREATE OR ALTER PROCEDURE SP_SINCRONIZAR_FORNECEDORES_REGRAS
    @MatrizServer NVARCHAR(100) = 'SEU_SERVIDOR_MATRIZ',  -- << ALTERAR: Nome do servidor da matriz
    @MatrizDatabase NVARCHAR(100) = 'NOME_BANCO_MATRIZ'          -- << ALTERAR: Nome do banco da matriz se diferente
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @RegistrosRemovidos INT = 0
    DECLARE @RegistrosInseridos INT = 0
    DECLARE @TotalFinal INT = 0
    
    BEGIN TRY
        PRINT '=== SINCRONIZAÇÃO FORNECEDORES_REGRAS ==='
        PRINT 'Matriz: ' + @MatrizServer + '.' + @MatrizDatabase
        PRINT 'Filial: ' + DB_NAME()
        PRINT 'Data/Hora: ' + CONVERT(VARCHAR(50), GETDATE(), 121)
        PRINT ''
        
        -- 1. Desabilitar triggers
        PRINT '1. Desabilitando triggers...'
        DISABLE TRIGGER ALL ON Fornecedores_Regras  -- << ALTERAR: Nome da tabela na filial se diferente
        
        -- 2. Limpar dados existentes
        PRINT '2. Limpando dados existentes...'
        DELETE FROM Fornecedores_Regras  -- << ALTERAR: Nome da tabela na filial se diferente
        SET @RegistrosRemovidos = @@ROWCOUNT
        PRINT '   - Registros removidos: ' + CAST(@RegistrosRemovidos AS VARCHAR(10))
        
        -- 3. Inserir dados da matriz
        PRINT '3. Inserindo dados da matriz...'
        SET @SQL = '
        INSERT INTO Fornecedores_Regras (Fornecedor, Regra, DataDeEdiçao, Conexao, Status)  -- << ALTERAR: Nomes das colunas se diferentes
        SELECT 
            Fornecedor, 
            Regra, 
            GETDATE() AS DataDeEdiçao,  -- << ALTERAR: Nome da coluna se diferente
            Conexao, 
            Status
        FROM [' + @MatrizServer + '].[' + @MatrizDatabase + '].[dbo].[Fornecedores_Regras]'  -- << ALTERAR: Nome da tabela na matriz se diferente
        
        EXEC sp_executesql @SQL
        SET @RegistrosInseridos = @@ROWCOUNT
        PRINT '   - Registros inseridos: ' + CAST(@RegistrosInseridos AS VARCHAR(10))
        
        -- 4. Reabilitar triggers
        PRINT '4. Reabilitando triggers...'
        ENABLE TRIGGER ALL ON Fornecedores_Regras  -- << ALTERAR: Nome da tabela na filial se diferente
        
        -- 5. Verificar resultado
        PRINT '5. Verificação final: ' + CAST(@TotalFinal AS VARCHAR(10)) + ' registros na filial'
        SELECT @TotalFinal = COUNT(*) FROM Fornecedores_Regras  -- << ALTERAR: Nome da tabela na filial se diferente
        
        PRINT ''
        PRINT '=== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ==='
        PRINT 'Registros removidos: ' + CAST(@RegistrosRemovidos AS VARCHAR(10))
        PRINT 'Registros inseridos: ' + CAST(@RegistrosInseridos AS VARCHAR(10))
        PRINT 'Total na filial: ' + CAST(@TotalFinal AS VARCHAR(10))
        
        -- Retornar resultado
        SELECT 
            @RegistrosRemovidos AS RegistrosRemovidos,
            @RegistrosInseridos AS RegistrosInseridos,
            @TotalFinal AS TotalNaFilial,
            'SUCESSO' AS Status
        
    END TRY
    BEGIN CATCH
        -- Reabilitar triggers em caso de erro
        ENABLE TRIGGER ALL ON Fornecedores_Regras  -- << ALTERAR: Nome da tabela na filial se diferente
        
        PRINT '=== ERRO NA SINCRONIZAÇÃO ==='
        PRINT 'Erro: ' + ERROR_MESSAGE()
        PRINT 'Linha: ' + CAST(ERROR_LINE() AS VARCHAR(10))
        
        -- Retornar erro
        SELECT 
            0 AS RegistrosRemovidos,
            0 AS RegistrosInseridos,
            0 AS TotalNaFilial,
            'ERRO: ' + ERROR_MESSAGE() AS Status
    END CATCH
END
GO

-- =============================================
-- COMO USAR:
-- =============================================
-- 1. Execute este script na FILIAL para criar a SP
-- 2. Altere os pontos marcados com << ALTERAR
-- 3. Para sincronizar, execute:
--    EXEC SP_SINCRONIZAR_FORNECEDORES_REGRAS
-- 
-- =============================================
-- EXEMPLO DE ALTERAÇÕES NECESSÁRIAS:
-- =============================================
-- Se o servidor da matriz for 'SRV-MATRIZ':
--    @MatrizServer NVARCHAR(100) = 'SRV-MATRIZ'
--
-- Se o banco da matriz for 'MatrizDB':
--    @MatrizDatabase NVARCHAR(100) = 'MatrizDB'
--
-- Se a tabela na matriz for 'Fornecedores_Regras_Matriz':
--    FROM [' + @MatrizServer + '].[' + @MatrizDatabase + '].[dbo].[Fornecedores_Regras_Matriz]
--
-- Se a tabela na filial for 'Fornecedores_Regras_Filial':
--    DELETE FROM Fornecedores_Regras_Filial
--    INSERT INTO Fornecedores_Regras_Filial
--    DISABLE TRIGGER ALL ON Fornecedores_Regras_Filial
--    ENABLE TRIGGER ALL ON Fornecedores_Regras_Filial
-- ============================================= 