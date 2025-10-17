update vwLancamentos 
	set
	ContigenciaTipo = null,
	DFESituacao = null,
	DFEMensagem = null,
	NFEContingencia = null,
	PreChave = null,
	PreNFSerie = null,
	PreNF = null,
	DFETentativa = null,
	NFEAmbiente = null,
	NFEStatus = null,
	NFEChave = null,
	nfe = null,
	nf = null
where LancamentoID =


delete from  LancamentosDFELog where LancamentoID =