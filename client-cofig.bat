::Script SOR WindowServer config - Alejandro Santana, 2ºSMR
::          FUNCIONALIDADES
::Asigns static IPs to the clients.
::Asigns the name of the clients.
::Asigns automatic IPs (DHCP) to the clients.
@echo off
:: Allow to use vairbles with !-!
setlocal enabledelayedexpansion

:MENU
cls
echo ========================================
echo    Configurador basico para Clientes Windows - SOR
echo    Hecho por Alejandro Santana - 2ºSMR
echo ========================================
echo.
echo Por favor, elige una opcion:
echo   1. Configurar la red (IP Fija o DHCP)
echo   2. Cambiar el nombre del equipo
echo   3. Salir
echo.
set /p MAIN_OPT=Que quieres hacer (1/2/3)?: 

if "%MAIN_OPT%"=="1" goto CONFIG_NET
if "%MAIN_OPT%"=="2" goto CONFIG_HOSTNAME
if "%MAIN_OPT%"=="3" exit /b
echo Opcion no valida
pause
goto MENU

::-----------------------------------------------------
:CONFIG_NET
cls
Echo ========================================
Echo    Configurador de red para clientes
Echo ========================================

::Show network interfaces detected in the system
echo.
echo Buscando las tarjetas de red...
set i=0
for /f "skip=3 tokens=4*" %%A in ('netsh interface show interface') do (
    if not "%%A"=="" (
        set /a i+=1
        set "iface[!i!]=%%A %%B"
        echo   !i!. %%A %%B
    )
)

if %i%==0 (
    echo No hay ninguna tarjeta de red
    pause
    goto MENU
)

::Ask the user to select one interface
echo.
set /p INTERFACE_NUM=Dime el numero de la tarjeta que quieres configurar: 
set "INTERFACE_NAME=!iface[%INTERFACE_NUM%]!"
if "!INTERFACE_NAME!"=="" (
    echo Ese numero no vale
    pause
    goto MENU
)
echo Has elegido: "!INTERFACE_NAME!"
echo.

::Ask for network configuration mode
echo Como quieres configurar la red:
echo   1. IP Fija (Estatica)
echo   2. DHCP (Automatica)
set /p OPTION=Elige una opcion (1/2): 

if "%OPTION%"=="1" (
    ::Static IP configuration
    echo.
    set /p IP_CLIENT=Mete la direccion IP del cliente: 
    set /p MASK=Mascara de subred: 
    set /p GATEWAY=Puerta de enlace: 

    echo Vale, configurando la IP en "!INTERFACE_NAME!"...
    netsh interface ipv4 set address name="!INTERFACE_NAME!" static !IP_CLIENT! !MASK! !GATEWAY!
    if %errorlevel% neq 0 (
        echo Uupsi, ha habido un error. Revisa los datos que has metido
        pause
        goto MENU
    )
) else if "%OPTION%"=="2" (
    ::DHCP configuration
    echo Activando DHCP para "!INTERFACE_NAME!"...
    netsh interface ipv4 set address name="!INTERFACE_NAME!" source=dhcp
    netsh interface ipv4 set dnsservers name="!INTERFACE_NAME!" source=dhcp
) else (
    echo Opcion incorrecta
    pause
    goto MENU
)

::Show the IP configuration
echo.
echo Te muestro como ha quedado la configuracion IP:
for /f "tokens=2 delims=:" %%A in ('netsh interface ipv4 show config name^="!INTERFACE_NAME!" ^| findstr "IP Address"') do (
    echo La direccion IP de este equipo es%%A
)

echo.
echo Configuracion de red terminada con exito
pause
goto MENU

::-----------------------------------------------------
:CONFIG_HOSTNAME
cls
echo ========================================
echo    Configuracion del Nombre del Equipo
echo ========================================
echo.

set /p NAME_CLIENT=Escribe el nombre nuevo para el cliente: 

:: Validate characters (avoid invalid ones)
echo Comprobando si el nombre tiene caracteres raros...
echo !NAME_CLIENT! | findstr /R "[\\/:*?\"^<^>^|]"
if %errorlevel%==0 (
    echo El nombre tiene caracteres no validos, prueba otra vez
    pause
    goto MENU
)

:: Assign the client name using PowerShell (modern method)
echo Cambiando el nombre del PC a "!NAME_CLIENT!"...
powershell.exe -ExecutionPolicy Bypass -Command "Rename-Computer -NewName '!NAME_CLIENT!' -Force | Out-Null"

:: Check if the PowerShell command was successful
if %errorlevel% equ 0 (
    echo El cambio de nombre ha funcionado bien
    echo OJO: El nuevo nombre se vera cuando reinicies el equipo
    echo.
    set /p REBOOT="Quieres reiniciar ahora para aplicar el nombre? (s/n):"
    if /i "!REBOOT!"=="s" (
        echo Reiniciando en 5 segundos...
        shutdown /r /t 5 /c "Reiniciando para aplicar el nuevo nombre del equipo"
        exit /b
    ) else (
        echo Acuerdate de reiniciar luego para que se cambie el nombre
    )
) else (
    echo Ha fallado el cambio de nombre.
    echo Asegurate de que estas ejecutando esto como Administrador
    echo Puede que el nombre sea invalido o ha pasado otra cosa
    pause
)

goto MENU