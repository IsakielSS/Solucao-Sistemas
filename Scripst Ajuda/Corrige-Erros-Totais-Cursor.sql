

DECLARE @LANCAMENTO INT = XXX
DECLARE @VALOR_TOTAL_PRODUTOS_PP REAL
DECLARE @VALOR_DESCONTO_TOTAL_PRODUTOS_PP REAL
DECLARE @TOTAL_DO_CONTAS REAL
DECLARE @NUMERO_SERIE INT
DECLARE @PROXIMO_NUMERO_SEQUENCIA_NFCE INT

-- Calcular o valor total dos produtos com desconto e arredondar para 2 casas decimais
SET @VALOR_TOTAL_PRODUTOS_PP = (
    SELECT ROUND(SUM((COALESCE(QDE, 0) * COALESCE(PREÇO, 0)) - COALESCE(DESCONTO, 0)), 2)
    FROM PEDIDOS_PRODUTOS
    WHERE LANCAMENTO = @LANCAMENTO AND SUBITEM = 0 AND STATUS % 2 = 0 AND FATOR = 1
);

-- Calcular o total de descontos dos produtos (arredondado)
SET @VALOR_DESCONTO_TOTAL_PRODUTOS_PP = (
    SELECT ROUND(SUM(COALESCE(DESCONTO, 0)), 2)
    FROM PEDIDOS_PRODUTOS
    WHERE LANCAMENTO = @LANCAMENTO AND SUBITEM = 0 AND STATUS % 2 = 0 AND FATOR = 1
);

-- Obter o número de série da nota fiscal
SET @NUMERO_SERIE = (
    SELECT CF.NFCEAMBPRODUCAOSERIE
    FROM LANÇAMENTOS L
    JOIN CONEXÕES C ON L.CONEXÃODAEMISSÃO = C.CÓDIGO
    JOIN COMPUTADORESCONFIGFISCAL CF ON C.COMPUTADOR = CF.COMPUTADORID
    WHERE L.CÓDIGO = @LANCAMENTO
);

PRINT('Numero SÉRIE:');
PRINT(@NUMERO_SERIE);

-- Obter o próximo número de sequência da nota fiscal
SET @PROXIMO_NUMERO_SEQUENCIA_NFCE = (
    SELECT CF.NFCEAMBPRODUCAONUMERO
    FROM LANÇAMENTOS L
    JOIN CONEXÕES C ON L.CONEXÃODAEMISSÃO = C.CÓDIGO
    JOIN COMPUTADORESCONFIGFISCAL CF ON C.COMPUTADOR = CF.COMPUTADORID
    WHERE L.CÓDIGO = @LANCAMENTO
) + 1;

PRINT('Numero NF-e:');
PRINT(@PROXIMO_NUMERO_SEQUENCIA_NFCE);

-- Recalcule o total das contas após possíveis ajustes
SET @TOTAL_DO_CONTAS = (
    SELECT ROUND(SUM(COALESCE(ValorDaConta, 0)), 2)
    FROM contas
    WHERE Lançamento = @LANCAMENTO AND status % 2 = 0
);

-- Ajuste a primeira conta para que o total das contas seja igual ao valor dos produtos
DECLARE @DIFERENCA REAL = @VALOR_TOTAL_PRODUTOS_PP - @TOTAL_DO_CONTAS;
DECLARE @CONTAID INT;
SELECT TOP 1 @CONTAID = código FROM contas WHERE Lançamento = @LANCAMENTO AND status % 2 = 0;
IF @CONTAID IS NOT NULL AND @DIFERENCA <> 0
BEGIN
    UPDATE contas
    SET ValorDaConta = ROUND(ValorDaConta + @DIFERENCA, 2),
        ValorPago = ROUND(ValorPago + @DIFERENCA, 2)
    WHERE código = @CONTAID;
END;
-- Recalcula o total das contas
SET @TOTAL_DO_CONTAS = @VALOR_TOTAL_PRODUTOS_PP;

-- Calcule o total pago em dinheiro
DECLARE @DINHEIRO REAL = (
    SELECT ROUND(SUM(COALESCE(ValorPago, 0)), 2)
    FROM contas
    WHERE Lançamento = @LANCAMENTO AND status % 2 = 0 AND FormaDePagamento = 1
);

-- Calcule o troco corretamente
DECLARE @TROCO REAL = 0;
IF (@DINHEIRO > @VALOR_TOTAL_PRODUTOS_PP)
BEGIN
    SET @TROCO = ROUND(@DINHEIRO - @VALOR_TOTAL_PRODUTOS_PP, 2);
END
ELSE
BEGIN
    SET @TROCO = 0;
END

UPDATE lançamentos
SET TROCO = @TROCO
WHERE código = @LANCAMENTO;

-- Atualizar os dados fiscais na tabela lançamentos
UPDATE lançamentos
SET
    NF = NULL,
    NFSÉRIE = NULL,
    NFE_CHAVE = NULL,
    PRENF = @PROXIMO_NUMERO_SEQUENCIA_NFCE,
    NFE_DT_AUTORIZACAO = NULL,
    PRENFSERIE = @NUMERO_SERIE,
    NFE_STATUS = 'R',
    NFE_MOTIVO = NULL,
    NFEPROTOCOLO = NULL,
    PRECHAVE = NULL,
    DFEMENSAGEM = NULL,
    DFESITUACAO = 250,
    NFECONTINGENCIA = NULL,
    CONTIGENCIATIPO = NULL
WHERE código = @LANCAMENTO;

-- Deletar os logs associados ao lançamento
DELETE FROM LANCAMENTOSDFELOG
WHERE LANCAMENTOID = @LANCAMENTO;

-- Buscar ConexãoDaEmissão do lançamento
DECLARE @CONECAO INT;
SELECT @CONECAO = ConexãoDaEmissão FROM LANÇAMENTOS WHERE CÓDIGO = @LANCAMENTO;

-- Buscar a primeira ContaCorrente disponível
DECLARE @CONTACORRENTE INT;
SELECT TOP 1 @CONTACORRENTE = Código FROM ContasCorrentes;

-- Demais variáveis
DECLARE @VALOR_TOTAL_PRODUTOS MONEY;
SET @VALOR_TOTAL_PRODUTOS = (
    SELECT ROUND(SUM((COALESCE(QDE, 0) * COALESCE(PREÇO, 0)) - COALESCE(DESCONTO, 0)), 2)
    FROM PEDIDOS_PRODUTOS
    WHERE LANCAMENTO = @LANCAMENTO AND SUBITEM = 0 AND STATUS % 2 = 0 AND FATOR = 1
);

DECLARE @DATA_ATUAL DATETIME = GETDATE();
DECLARE @DATA_VENCIMENTO DATETIME = CAST(CONVERT(date, @DATA_ATUAL) AS DATETIME);
DECLARE @NATUREZA SMALLINT = 1; -- Ajuste conforme necessário
DECLARE @STATUS SMALLINT = 0;
DECLARE @FORMA_PAGAMENTO TINYINT = 1; -- Sempre 1 (dinheiro)

IF NOT EXISTS (
    SELECT 1 FROM Contas WHERE Lançamento = @LANCAMENTO AND Status % 2 = 0
)
BEGIN
    INSERT INTO [dbo].[Contas] (
        [DataDaInclusão],
        [DataDeEdição],
        [Conexão],
        [Lançamento],
        [Natureza],
        [Status],
        [DataDeVencimento],
        [ValorDaConta],
        [FormaDePagamento],
        [DataDeRecebimento],
        [ConexãoDoRecebimento],
        [DataDePagamento],
        [ConexãoDoPagamento],
        [Acréscimos],
        [Descontos],
        [ValorPago],
        [ContaCorrente],
        [SP],
        [Parcela],
        [Parcelas]
    )
    VALUES (
        @DATA_ATUAL,
        @DATA_ATUAL,
        @CONECAO,
        @LANCAMENTO,
        @NATUREZA,
        @STATUS,
        @DATA_VENCIMENTO,
        @VALOR_TOTAL_PRODUTOS,
        @FORMA_PAGAMENTO,
        @DATA_ATUAL,
        @CONECAO,
        @DATA_ATUAL,
        @CONECAO,
        0.00,
        0.00,
        @VALOR_TOTAL_PRODUTOS,
        @CONTACORRENTE,
        1,
        1,
        1
    );
END
