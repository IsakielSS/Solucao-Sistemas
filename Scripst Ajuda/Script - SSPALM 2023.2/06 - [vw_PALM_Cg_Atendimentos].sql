ALTER VIEW [dbo].[vw_PALM_Cg_Atendimentos]
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
	(Tipo IN (1,5)) AND (Ativo = 1 OR (Status & 1) = 0) AND Ativo = 1
 

GO