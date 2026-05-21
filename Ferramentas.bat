@echo off

chcp 65001 > nul
setlocal enabledelayedexpansion
mode con:cols=50 lines=15 


:menu
cls
echo ╔═══════════════════════════╗
echo ║    Selecione uma opção    ║
echo ╠═══════════════════════════╣
echo ║ 1 - Atualizar impressora  ║
echo ╠═══════════════════════════╣
echo ║ 2 - Limpar cache chrome   ║
echo ╠═══════════════════════════╣
echo ║ 3 - Reset anydesk         ║
echo ╚═══════════════════════════╝
echo.  
set /p opcao=Digite um número » 

if %opcao% equ 1 goto att
if %opcao% equ 2 goto cache

echo Opcao errada!
pause
goto menu

:att
set "DRIVE_FILE_ID=1mLtq2N-dy6ZUCH30QtxjbCXT6H3ZDNpC"
set "PASTA_DESTINO=%USERPROFILE%\Documents\extensão"
set "ARQUIVO_ZIP=%TEMP%\atualizacao_%RANDOM%.zip"

if not exist "%PASTA_DESTINO%" (
    echo [AVISO] A pasta de destino nao existe. Criando em: "%PASTA_DESTINO%"
    mkdir "%PASTA_DESTINO%"
    echo.
)

taskkill /F /IM chrome.exe /T > nul 2>&1
timeout /t 2 /nobreak > nul

set "URL_DOWNLOAD=https://docs.google.com/uc?export=download&id=%DRIVE_FILE_ID%&confirm=t"

curl -L -g -o "%ARQUIVO_ZIP%" "%URL_DOWNLOAD%"

if %ERRORLEVEL% neq 0 (
    color 0C
    echo.
    echo [ERRO] Falha ao baixar o arquivo. Verifique a conexao.
    echo.
    pause
    exit /b
)

powershell -Command "Expand-Archive -Path '%ARQUIVO_ZIP%' -DestinationPath '%PASTA_DESTINO%' -Force"

if %ERRORLEVEL% neq 0 (
    color 0C
    echo.
    echo [ERRO] Erro ao extrair os arquivos. O arquivo baixado pode estar corrompido.
    if exist "%ARQUIVO_ZIP%" del "%ARQUIVO_ZIP%"
    echo.
    pause
    exit /b
)

if exist "%ARQUIVO_ZIP%" del "%ARQUIVO_ZIP%"