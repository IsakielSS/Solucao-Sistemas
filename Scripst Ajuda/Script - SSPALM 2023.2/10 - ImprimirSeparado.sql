ALTER  FUNCTION [dbo].[fn_PALM_Pedido_CheckStatus](@pUnidade INT, @pAtendimento INT, @VerTotal BIT, @VerComissao BIT)
RETURNS @Pedidos TABLE(Unidade INT,	Atendimento INT, Tipo CHAR(1), Codigo INT, Descricao VARCHAR(100), Qde NUMERIC(10,2), UN VARCHAR(10), Total NUMERIC(10,2),	Linha VARCHAR(400))
AS
BEGIN
	--Exibir produtos com configuração de Agrupado
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
		AND (Pr.ImprimirSeparado = 0)
	GROUP BY L.Unidade, L.Atendimento, R.Produto, Pr.Descrição, Pr.UNE;
	
	--Exibir produtos com configuração de Desagrupado
	INSERT @pedidos(Unidade, Atendimento, Tipo, Codigo, Descricao, Qde, UN, Total)
	SELECT 
		L.Unidade, 
		L.Atendimento,
		'P' as [Tipo],
		R.Produto as [Codigo], 
		Pr.Descrição AS Descricao, 
		CAST(ROUND(R.QDE, 2) AS NUMERIC(10,2)) AS Qde, 
		Pr.UNE AS UN, 
		CAST(ROUND(R.PreçoTotal, 2) AS NUMERIC(10,2)) AS Total
	FROM ((Lançamentos L INNER JOIN Pedidos P ON L.Código = P.Lançamento) INNER JOIN Pedidos_Produtos R ON P.Código = R.Pedido) INNER JOIN Produtos Pr ON R.Produto = Pr.Código
	WHERE 
		(L.DataDeEmissão IS NULL) 
		AND ((L.Atendimento = @pAtendimento AND L.Unidade = @pUnidade) OR @pAtendimento = 0) 
		AND (L.Atendimento IS NOT NULL)
		AND ((L.Status % 2) = 0)
		AND (P.Natureza = -1) 
		AND (R.SubItem = 0)
		AND (R.Fator > 0)
		AND (Pr.ImprimirSeparado = 1);

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


