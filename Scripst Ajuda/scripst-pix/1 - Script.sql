alter table integracao.fila alter column UUID varchar(50) null
alter table lançamentos add  Integradora bigint null
update Produtos set Disponível = 0 where Tipo ='G'
UPDATE Produtos SET Comissionado = 0,Arredonda = 0 WHERE Tipo IN ('G','X')