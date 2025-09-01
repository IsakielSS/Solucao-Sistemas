ALTER VIEW [dbo].[vw_PALM_Atendimentos]
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
(Status & 1) = 0 AND
Ativo = 1