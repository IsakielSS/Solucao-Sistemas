	ALTER VIEW [dbo].[vw_PALM_AtendimentosAbertos2]
	AS
	SELECT DISTINCT
		[LancamentoID] = l.Código,
		[Unidade] = l.Unidade,
		[Atendimento] = l.Atendimento, 
		[HoraAbertura] = l.DataDaInclusão,
		[CheckIn] = ISNULL(a.CheckIn,0),
		[Tipo] = a.Tipo,
		[Conta_Impressa] = (case when (l.status & 32 > 0) then 1 else 0 end),
		[HoraConta] = (CASE WHEN (case when (l.status & 32 > 0) then 1 else 0 end) = 1 THEN l.DataDeEdição ELSE NULL END)
	FROM Lançamentos l INNER JOIN Atendimentos a ON l.Atendimento = a.Atendimento
	WHERE 
		((l.Unidade = a.Unidade) OR (a.Unidade IS NULL) OR (l.Unidade IS NULL))
		AND (l.datadeemissão is null) 
		AND (l.ConexãoDaEmissão is null)
		AND (l.Atendimento IS NOT NULL); 

GO