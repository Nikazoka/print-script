@echo off
title Ferramentas
reg query HKEY_USERS\S-1-5-19 >NUL || (
    echo Por favor, execute como administrador.
    pause >NUL
    exit
)
chcp 437 >nul
chcp 65001 > nul
setlocal enabledelayedexpansion
mode con:cols=50 lines=15
set "URL_SCRIPT=https://raw.githubusercontent.com/Nikazoka/print-script/refs/heads/main/Ferramentas.bat"
set "ARQUIVO_TEMP=%TEMP%\script_novo.bat"
curl -s -L -o "%ARQUIVO_TEMP%" "%URL_SCRIPT%"
if not exist "%ARQUIVO_TEMP%" (
    echo [Aviso] Falha ao verificar atualizacoes. Iniciando versao offline...
    goto :menu
)
if %ERRORLEVEL% neq 0 (
    echo [Atualizador] Nova versao encontrada! Aplicando atualizacao...
    copy /y "%ARQUIVO_TEMP%" "%~f0" > nul
    del "%ARQUIVO_TEMP%"
    echo [Atualizador] Script atualizado! Reiniciando...
    timeout /t 2 > nul
    start "" "%~f0"
    exit
) else (
    echo [Atualizador] Voce ja esta usando a versao mais recente.
    del "%ARQUIVO_TEMP%"
)
pause
:menu
cls
echo v0.1
echo            ╔═══════════════════════════╗
echo            ║    Selecione uma opção    ║
echo            ╠═══════════════════════════╣
echo            ║ 1 - Atualizar impressora  ║
echo            ╠═══════════════════════════╣
echo            ║ 2 - Limpar cache chrome   ║
echo            ╠═══════════════════════════╣
echo            ║ 3 - Reset anydesk         ║
echo            ╚═══════════════════════════╝
echo.           
set /p opcao=Digite um número   »   
if "%opcao%" equ "1" goto att
if "%opcao%" equ "2" goto cac
if "%opcao%" equ "3" goto any
cls
echo Opção errada^^! Pressione qualquer tecla para voltar ao menu...
pause >nul
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
    goto menu
)
if exist "%ARQUIVO_ZIP%" del "%ARQUIVO_ZIP%"
cls
goto menu
:cac
cls
echo Após a limpeza do cache será necessário realizar  novamente o login nos sistemas.
echo.
set /p r=Deseja continuar? » S/N 
    if /i "%r%" equ "S" goto cac-y
    if /i "%r%" equ "N" goto menu  
    cls
    for /l %%i in (1,-1,0) do (   
        <nul set /p ="ERRO, digite apenas S ou N."
        ping -n 2 127.0.0.1 >nul
        cls
          <nul set /p ="ERRO, digite apenas S ou N.."
        ping -n 2 127.0.0.1 >nul
        cls
         <nul set /p ="ERRO, digite apenas S ou N..."
        ping -n 2 127.0.0.1 >nul
        cls     
    )
goto cac
:cac-y
echo.
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
echo Cache Limpo^^!
timeout 3 >nul
goto menu
:any
cls
echo.
set /p r=Deseja reiniciar o contador limite do anydesk? » S/N 
    if /i "%r%" equ "S" goto any-y
    if /i "%r%" equ "N" goto menu  
    cls
    for /l %%i in (1,-1,0) do (   
        <nul set /p ="ERRO, digite apenas S ou N."
        ping -n 2 127.0.0.1 >nul
        cls
          <nul set /p ="ERRO, digite apenas S ou N.."
        ping -n 2 127.0.0.1 >nul
        cls
         <nul set /p ="ERRO, digite apenas S ou N..."
        ping -n 2 127.0.0.1 >nul
        cls     
    )
goto any
:any-y
call :stop_any
del /f "%ALLUSERSPROFILE%\AnyDesk\service.conf"
del /f "%APPDATA%\AnyDesk\service.conf"
:: Salva o user.conf atual no TEMP
copy /y "%APPDATA%\AnyDesk\user.conf" "%temp%\"
:: Remove miniaturas antigas
rd /s /q "%temp%\thumbnails" 2>NUL
:: Copia as miniaturas atuais para o TEMP
xcopy /c /e /h /r /y /i /k "%APPDATA%\AnyDesk\thumbnails" "%temp%\thumbnails"
:: Remove todos os arquivos da pasta do AnyDesk (tanto do perfil do sistema quanto do usuário)
del /f /a /q "%ALLUSERSPROFILE%\AnyDesk\*"
del /f /a /q "%APPDATA%\AnyDesk\*"
call :start_any
:lic
:: Aguarda até o arquivo system.conf conter a linha "ad.anynet.id="
:wait_lic
find "ad.anynet.id=" "%ALLUSERSPROFILE%\AnyDesk\system.conf" >nul 2>&1
if %errorlevel% neq 0 (
    timeout /t 1 >nul
    goto wait_lic
)
:: Restaura os arquivos de configuração
call :stop_any
move /y "%temp%\user.conf" "%APPDATA%\AnyDesk\user.conf" >nul 2>&1
xcopy /c /e /h /r /y /i /k "%temp%\thumbnails" "%APPDATA%\AnyDesk\thumbnails" >nul 2>&1
rd /s /q "%temp%\thumbnails" >nul 2>&1
call :start_any
echo *********
echo Concluído.
echo(
goto :eof
:: ================================
:: START ANYDESK
:: ================================
:start_any
echo Iniciando serviço AnyDesk...
:: Se já estiver rodando, não tenta iniciar de novo
sc query AnyDesk | find "RUNNING" >nul
if %errorlevel%==0 (
    echo Serviço já está em execução.
    goto open_any
)
sc start AnyDesk >nul 2>&1
:: Aguarda até 15 segundos para subir
set count=0
:wait_start
sc query AnyDesk | find "RUNNING" >nul
if %errorlevel%==0 goto open_any
timeout /t 1 >nul
set /a count+=1
if %count% lss 15 goto wait_start
echo Falha ao iniciar serviço.
goto :eof
:open_any
echo Abrindo executável...
set "AnyDesk1=%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
set "AnyDesk2=%ProgramFiles%\AnyDesk\AnyDesk.exe"
if exist "%AnyDesk1%" start "" "%AnyDesk1%"
if exist "%AnyDesk2%" start "" "%AnyDesk2%"
exit /b
:: ================================
:: STOP ANYDESK
:: ================================
:stop_any
echo Parando serviço AnyDesk...
:: Se já estiver parado
sc query AnyDesk | find "STOPPED" >nul
if %errorlevel%==0 goto kill_proc
sc stop AnyDesk >nul 2>&1
:: Aguarda até parar
set count=0
:wait_stop
sc query AnyDesk | find "STOPPED" >nul
if %errorlevel%==0 goto kill_proc
timeout /t 1 >nul
set /a count+=1
if %count% lss 15 goto wait_stop
echo Serviço não respondeu corretamente.
:kill_proc
taskkill /f /im "AnyDesk.exe" >nul 2>&1
goto menu
