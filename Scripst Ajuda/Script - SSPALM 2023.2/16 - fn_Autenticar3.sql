ALTER FUNCTION [dbo].[fn_Autenticar3](@user VARCHAR(255), @pass VARCHAR(255))
RETURNS @t TABLE(Administrador BIT, Autenticado BIT, UsuarioId INT)
AS
BEGIN
	DECLARE @admin BIT, @autenticado BIT, @UsuarioID INT;
	SET @admin = 0;
	SET @autenticado = 0;
	SET @UsuarioID = 0;
	IF (LEN(ISNULL(@pass,'')) > 0) AND EXISTS(SELECT 1 FROM Fornecedores WHERE nome = @user AND (dbo.CriptoStr255(senha,'') = @pass OR lower(dbo.CriptoStr255(senha,'')) = lower(dbo.CriptoStr255(@pass,''))) AND ((Ativo = 1 AND Vendedor = 1) OR (@user = 'ADMIN')))
	BEGIN
		SELECT @UsuarioID = Código FROM Fornecedores WHERE nome = @user AND (dbo.CriptoStr255(senha,'') = @pass OR lower(dbo.CriptoStr255(senha,'')) = lower(dbo.CriptoStr255(@pass,'')));
		SET @autenticado = 1;
		IF (EXISTS(SELECT * FROM Fornecedores f WHERE f.Nome = @user AND f.Código IN (SELECT ur.Usuário FROM Regras r INNER JOIN Usuários_Regras ur ON r.Código = ur.Regra WHERE r.Descrição = 'ADMINISTRADORES'))) OR (@User = 'ADMIN')
			SET @admin = 1;
	END;
	INSERT @T(Administrador, Autenticado, UsuarioID) SELECT @admin, @autenticado, @UsuarioID;
	RETURN;
END;