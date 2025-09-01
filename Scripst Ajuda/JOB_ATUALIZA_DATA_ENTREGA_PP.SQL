UPDATE
R
SET
R.entrega=P.entrega
FROM
vwlancamentos L join
vwpedidos P
ON L.lancamentoid = P.lancamentoid
join vwpedidosprodutos R
ON P.pedidoid =R.pedidoid
WHERE
P.entrega is not null
and R.entrega is null
and L.emissao > DATEADD(DAY, -1, GETDATE());
GO

UPDATE	
P
SET
P.entrega=R.entrega
FROM
vwlancamentos L join
vwpedidos P
ON L.lancamentoid = P.lancamentoid
join vwpedidosprodutos R
ON P.pedidoid =R.pedidoid
WHERE
R.entrega is not null
and P.entrega is null
And L.emissao is not null
and R.entrega > DATEADD(DAY, -1, GETDATE());
GO