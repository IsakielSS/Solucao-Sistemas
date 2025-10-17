PACOTE DE OTIMIZAÇÃO DO BANCO
---------------
1 - DIMINUIR LOG
---------------
ALTER DATABASE Gerencial SET RECOVERY SIMPLE
go
DBCC SHRINKFILE(2)
go
EXEC sp_helpdb Gerencial
go
ALTER DATABASE Gerencial SET RECOVERY FULL
go
---------------
2 - DIMINUIR ESPAÇAMENTO DE TABELAS
---------------
EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? REBUILD';
DECLARE @DBNAME SYSNAME;
SET @DBNAME = DB_NAME();
DBCC SHRINKDATABASE(@DBNAME);
---------------
3 - REINDEXAR AS TABELAS
---------------
SELECT
OBJECT_NAME(B.object_id)
AS Nome_Tabela, B.name
AS Nome_Indice, A.index_type_desc
AS Tipo_Indice, A.avg_fragmentation_in_percent,
'DBCC DBREINDEX ('+ OBJECT_NAME(B.object_id)+ ',' + B.name + ',70)'
FROM
sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') A INNER JOIN sys.indexes B
WITH(NOLOCK) ON B.object_id = A.object_id
AND B.index_id = A.index_id
WHERE
A.avg_fragmentation_in_percent > 70
AND OBJECT_NAME(B.object_id) NOT LIKE '[_]%'
AND A.index_type_desc != 'HEAP'
ORDER BY
A.avg_fragmentation_in_percent DESC
---------------