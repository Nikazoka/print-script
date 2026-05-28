@echo off
mode con:cols=50 lines=15
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $W=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width; $H=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height; $code='using System; using System.Runtime.InteropServices; public class Win { [DllImport(\"user32.dll\")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr h, int X, int Y, int cx, int cy, uint uFlags); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); }'; Add-Type -TypeDefinition $code; [Win]::SetWindowPos([Win]::GetConsoleWindow(), [IntPtr]::Zero, ($W-450)/2, ($H-300)/2, 0, 0, 5);"
cls
title Ferramentas
chcp 437 >nul
chcp 65001 > nul
setlocal enabledelayedexpansion
call :update
call :bloq
:: *********************************************************************************
:: ********************************** METODO MENU **********************************
:: *********************************************************************************
:menu
cls
echo v0.4
echo            ╔═══════════════════════════╗
echo            ║    Selecione uma opção    ║
echo            ╠═══════════════════════════╣
echo            ║ 1 - Atualizar impressora  ║
echo            ╠═══════════════════════════╣
echo            ║ 2 - Limpar cache chrome   ║
echo            ╠═══════════════════════════╣
echo            ║ 3 - Reset timer anydesk   ║
echo            ╚═══════════════════════════╝
echo.           
set /p opcao=Digite um número   »   
if "%opcao%" equ "1" goto att
if "%opcao%" equ "2" goto cac
if "%opcao%" equ "3" goto any
if "%opcao%" equ "n8n" goto n8n
if "%opcao%" equ "flush" goto flush
cls
echo Opção errada! Pressione qualquer tecla para voltar ao menu...
pause >nul
goto menu
:: *********************************************************************************
:: ************************** METODO ATUALIZAR IMPRESSORA **************************
:: *********************************************************************************
:att
cls
echo O navegador será encerrado pra atualização!
echo.
set /p r=Deseja continuar? » S/N 
    if /i "%r%" equ "S" goto att-y
    if /i "%r%" equ "N" goto menu   
    call :erroEnt
goto att
:att-y
cls
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
    echo.
    echo [ERRO] Falha ao baixar o arquivo. Verifique a conexao.
    echo.
    pause
    exit /b
)
powershell -Command "Expand-Archive -Path '%ARQUIVO_ZIP%' -DestinationPath '%PASTA_DESTINO%' -Force"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERRO] Erro ao extrair os arquivos. O arquivo baixado pode estar corrompido.
    if exist "%ARQUIVO_ZIP%" del "%ARQUIVO_ZIP%"
    echo.
    pause
    goto menu
)
if exist "%ARQUIVO_ZIP%" del "%ARQUIVO_ZIP%"
goto menu
:: *********************************************************************************
:: *************************** METODO LIMPAR CACHE CHROME **************************
:: *********************************************************************************
:cac
cls
echo Após a limpeza do cache será necessário realizar  novamente o login nos sistemas.
echo.
set /p r=Deseja continuar? » S/N 
    if /i "%r%" equ "S" goto cac-y
    if /i "%r%" equ "N" goto menu  
    call :erroEnt
goto cac
:cac-y
cls
echo Limpando o cache
taskkill /F /IM chrome.exe /T >nul 2>&1
ping 127.0.0.1 -n 1 >nul
cls
echo Limpando o cache.
del /q /s /f "%localappdata%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
ping 127.0.0.1 -n 1 >nul
cls
echo Limpando o cache..
del /q /s /f "%localappdata%\Google\Chrome\User Data\Default\Network\Cookies" >nul 2>&1
ping 127.0.0.1 -n 1 >nul
cls
echo Cache Limpo!
timeout 3 >nul
goto menu
:: *********************************************************************************
:: ****************************** METODO RESET ANYDESK *****************************
:: *********************************************************************************
:any
cls
echo Será necessário reiniciar o computador!
set /p r=Deseja continuar? » S/N 
    if /i "%r%" equ "S" goto any-y
    if /i "%r%" equ "N" goto menu  
    call :erroEnt
goto any
:any-y
cls
del /f "%ALLUSERSPROFILE%\AnyDesk\service.conf"
del /f "%APPDATA%\AnyDesk\service.conf"
del /f /a /q "%ALLUSERSPROFILE%\AnyDesk\*"
del /f /a /q "%APPDATA%\AnyDesk\*"
cls
<nul set /p ="Reiniciando em 3"
ping -n 2 127.0.0.1 >nul
cls
<nul set /p ="Reiniciando em 2"
ping -n 2 127.0.0.1 >nul
cls
<nul set /p ="Reiniciando em 1"
ping -n 2 127.0.0.1 >nul     
shutdown /r /f /t 0
:: *********************************************************************************
:: ********************************* FIM DO RESET **********************************
:: *********************************************************************************

:: *********************************************************************************
:: ***************************** ATUALIZAÇÃO DO SCRIPT *****************************
:: *********************************************************************************
:update
set "URL_SCRIPT=https://raw.githubusercontent.com/Nikazoka/print-script/refs/heads/main/Ferramentas.bat?v=%RANDOM%"
set "ARQUIVO_TEMP=%TEMP%\script_novo.bat"
curl -s -L -o "%ARQUIVO_TEMP%" "%URL_SCRIPT%"
if not exist "%ARQUIVO_TEMP%" (
    echo [Aviso] Falha ao verificar atualizacoes. Iniciando versao offline...
    goto :menu
)
    fc "%~f0" "%ARQUIVO_TEMP%" > nul
if %ERRORLEVEL% neq 0 (
    echo [Atualizador] Nova versao encontrada! Aplicando atualizacao...
    copy /y "%ARQUIVO_TEMP%" "%~f0" > nul
    del "%ARQUIVO_TEMP%"
    echo [Atualizador] Script atualizado! Reiniciando...
    timeout /t 2 > nul
    start "" "%~f0"
    exit
) else (
    echo [Atualizador] Voce ja esta usando a versao mais   recente.
    del "%ARQUIVO_TEMP%"
)
ping 127.0.0.1 -n 2 >nul
exit /b
:: *********************************************************************************
:: ************************************ BLOQUEIO ***********************************
:: *********************************************************************************
::LEQ (Menor ou igual a)
::GEQ (Maior ou igual a)
:bloq
cd /d "%~dp0"
reg query HKEY_USERS\S-1-5-19 >NUL || (
    echo Por favor, execute como administrador.
    pause >NUL
    exit
)
set "b=%time:~0,2%"
set "b=%b: =%"
if %b% GEQ 7 ( 
    if %b% LEQ 12 (
        exit /b
    ) 
)
if %b% GEQ 14 ( 
    if %b% LEQ 17 (
        exit /b
    )
)
echo Disponível entre 7h - 12h e 14h - 17h
echo Pressione qualquer tecla para fechar...
pause >nul
exit
:: *********************************************************************************
:: ************************************ ENTRADA ************************************
:: *********************************************************************************
:erroEnt
    cls
    <nul set /p ="ERRO, digite apenas S ou N."
    ping -n 2 127.0.0.1 >nul
    cls
    <nul set /p ="ERRO, digite apenas S ou N.."
    ping -n 2 127.0.0.1 >nul
    cls
    <nul set /p ="ERRO, digite apenas S ou N..."
    ping -n 2 127.0.0.1 >nul     
    cls
exit /b
:: *********************************************************************************
:: ************************************** N8N **************************************
:: *********************************************************************************
:n8n
docker compose exec -u node n8n n8n user-management:reset
docker compose restart n8n
timeout /t 5
start http://localhost:5678
echo Processo concluido!
ping 127.0.0.1 -n 2 >nul
goto menu
:: *********************************************************************************
:: ************************************* FLUSH *************************************
:: *********************************************************************************
:flush
echo Limpando o cache...
ipconfig /flushdns >nul
ping 127.0.0.1 -n 1 >nul
cls
echo Limpando o cache.
ipconfig /release >nul
ping 127.0.0.1 -n 1 >nul
cls
echo Limpando o cache..
ipconfig /renew >nul
ping 127.0.0.1 -n 1 >nul
cls
echo Cache Limpo!
ping 127.0.0.1 -n 2 >nul
goto menu