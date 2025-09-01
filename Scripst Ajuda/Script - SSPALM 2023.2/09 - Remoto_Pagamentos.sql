/****** Object:  Table [dbo].[Remoto_Pagamentos]    Script Date: 06/12/2018 11:14:42 ******/
DROP TABLE [dbo].[Remoto_Pagamentos]
GO

CREATE TABLE [dbo].[Remoto_Pagamentos](
	[Código] [int] IDENTITY(1,1) NOT NULL,
	[DataDaInclusão] [smalldatetime] NOT NULL,
	[DataDeEdição] [smalldatetime] NOT NULL,
	[Status] [int] NOT NULL,
	[Atendimento] [int] NULL,
	[Bandeira] [varchar](100) NULL,
	[CodAutorizacaoTrans] [varchar](100) NULL,
	[CodFormaPagamento] [varchar](100) NULL,
	[CodTipoFormaPagamento] [int] NULL,
	[FormaPagamento] [varchar](100) NULL,
	[IntegradoraId] [varchar](100) NULL,
	[MaskNumCartao] [varchar](100) NULL,
	[NumParcelas] [int] NULL,
	[NumTerminal] [varchar](100) NULL,
	[PagamentoTransId] [varchar](100) NULL,
	[TipoFormaPagamento] [varchar](100) NULL,
	[TipoIntegradora] [varchar](100) NULL,
	[ValorPago] [money] NULL,
	[Unidade] [int] NULL,
	[NSU] [varchar](100) NULL,
	[Guiid] [varchar](100) NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de pagamentos efetuados pelas integradoras via dispositivos e chamadas remotas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Remoto_Pagamentos'
GO


