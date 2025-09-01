UPDATE LANÇAMENTOS SET 
    Status = 0, NFE = 'S', NFE_Status = 'A', NFE_Motivo = 'Autorizado o uso da NF-e', 
    NFE_Ambiente = 1, DFESituacao = 30, DFEMensagem = 'Impresso com Sucesso.', NFEImpressa = 1, DFETentativa = 1, NFECancelamento = NULL,
    NFECancelamentoConexaoID = NULL, NFECancelamentoMotivo = NULL
    WHERE NF = 