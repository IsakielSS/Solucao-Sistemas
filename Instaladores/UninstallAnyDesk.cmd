@ECHO OFF
CHCP 65001 > nul
CD /d %~dp0

REM UninstallAnyDesk.cmd
REM -----------------------------------------------
REM Desinstala o AnyDesk e remover todas as pastas
REM Ultima alteração: 2025-04-14

REM Desinstalação do AnyDesk

SET ANYDESK=AnyDesk_8.0.13.0.exe

IF EXIST "%ANYDESK%" (
    IF EXIST "%PROGRAMFILES%\AnyDesk\" (
        "%ANYDESK%" --remove
        ECHO AnyDesk Desinstalado.
    ) ELSE IF EXIST "%PROGRAMFILES(X86)%\AnyDesk\" (
        "%ANYDESK%" --remove
        ECHO AnyDesk Desinstalado.
    ) ELSE (
        ECHO Nenhuma das pastas de instalação do AnyDesk foi encontrada!
    )
) ELSE (
    ECHO "%ANYDESK%" não existe!
)

REM Exclusão de arquivos

IF EXIST "%PROGRAMFILES%\AnyDesk\" (
	RD /s /q "%PROGRAMFILES%\AnyDesk\"
	ECHO "%PROGRAMFILES%\AnyDesk\" excluido.
) ELSE (
	ECHO "%PROGRAMFILES%\AnyDesk\" não existe!
)

IF EXIST "%PROGRAMFILES(X86)%\AnyDesk\" (
	RD /s /q "%PROGRAMFILES(X86)%\AnyDesk\"
	ECHO "%PROGRAMFILES(X86)%\AnyDesk\" excluido.
) ELSE (
	ECHO "%PROGRAMFILES(X86)%\AnyDesk\" não existe!
)

IF EXIST "%APPDATA%\AnyDesk\" (
	RD /s /q "%APPDATA%\AnyDesk\"
	ECHO "%APPDATA%\AnyDesk\" excluido.
) ELSE (
	ECHO "%APPDATA%\AnyDesk\" não existe!
)

IF EXIST "%PROGRAMDATA%\AnyDesk\" (
	RD /s /q "%PROGRAMDATA%\AnyDesk\"
	ECHO "%PROGRAMDATA%\AnyDesk\" excluido.
) ELSE (
	ECHO "%PROGRAMDATA%\AnyDesk\" não existe!
)

PAUSE
