::Script SOR WindowServer config - Version Corregida y Modernizada por Gemini
:: =====================================================================
:: FUNCIONALIDADES:
:: 1. Asignar IP estatica al Servidor
:: 2. Asignar nombre al Servidor
:: 3. Instalar roles (Enrutamiento y DHCP)
:: 4. Configurar Firewall y Deteccion de Redes
:: 5. Configurar el servicio DHCP (crear ambito)
:: 6. Consultar concesiones DHCP
:: =====================================================================

@echo off
setlocal enabledelayedexpansion

:MENU
cls
echo ======================================================
echo    Configurador Tocho de Windows Server - SOR
echo          por Alejandro Santana
echo ======================================================
echo.
echo   1. Poner IP Fija
echo   2. Cambiar Nombre del Servidor
echo   3. Instalar Servicios (Router y DHCP)
echo   4. Arreglar el Firewall para ver otros PCs
echo   5. Montar el DHCP (crear el rango de IPs)
echo   6. Chivarme de quien tiene IP
echo   7. Salir
echo.
set /p "CHOICE=Venga, dime que quieres hacer: "

if "%CHOICE%"=="1" goto SET_IP
if "%CHOICE%"=="2" goto SET_HOSTNAME
if "%CHOICE%"=="3" goto INSTALL_ROLES
if "%CHOICE%"=="4" goto CONFIG_FIREWALL
if "%CHOICE%"=="5" goto CONFIG_DHCP
if "%CHOICE%"=="6" goto SHOW_LEASES
if "%CHOICE%"=="7" exit /b
echo Esa opcion no existe, figura.
pause
goto MENU

:: ======================================================
:SET_IP
cls
echo --- 1. CONFIGURAR IP ESTATICA ---
echo.
echo A ver que tarjetas de red tienes por aqui...
set i=0
for /f "skip=3 tokens=4*" %%A in ('netsh interface show interface') do (
    if not "%%A"=="" (
        set /a i+=1
        set "iface[!i!]=%%A %%B"
        echo   !i!. %%A %%B
    )
)
if %i%==0 (
    echo No he encontrado ninguna tarjeta de red.
    pause
    goto MENU
)
echo.
set /p "INTERFACE_NUM=Elige el numero de la tarjeta que vas a usar: "
set "INTERFACE_NAME=!iface[%INTERFACE_NUM%]!"
if "!INTERFACE_NAME!"=="" (
    echo Numero de tarjeta no valido.
    pause
    goto SET_IP
)

echo.
echo Has elegido "!INTERFACE_NAME!". Ahora dame los datos:
echo.
set /p "IP_SERVER=IP para el servidor: "
set /p "MASK=Mascara de subred: "
set /p "GATEWAY=Puerta de enlace (el router): "
set /p "DNS=Servidor DNS (puedes poner la misma IP del servidor): "
echo.
echo Configurando la IP en "!INTERFACE_NAME!"...
netsh interface ipv4 set address name="!INTERFACE_NAME!" static !IP_SERVER! !MASK! !GATEWAY!
netsh interface ipv4 set dns name="!INTERFACE_NAME!" static !DNS!

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Algo ha salido mal. Revisa los datos o si eres Administrador.
) else (
    echo.
    echo ¡Listo! IP configurada.
)
pause
goto MENU

:: ======================================================
:SET_HOSTNAME
cls
echo --- 2. CAMBIAR NOMBRE DEL SERVIDOR ---
echo.
set /p "NAME_SERVER=Dime el nombre nuevo para el servidor: "
echo.
echo Cambiando el nombre a "!NAME_SERVER!"...
powershell.exe -ExecutionPolicy Bypass -Command "Rename-Computer -NewName '!NAME_SERVER!' -Force | Out-Null"

if %errorlevel% equ 0 (
    echo.
    echo ¡Nombre cambiado! Pero tienes que reiniciar para que se vea el cambio.
    set /p "REBOOT=Quieres reiniciar ahora (s/n)? "
    if /i "!REBOOT!"=="s" (
        shutdown /r /t 5 /c "Reinicio para aplicar el nuevo nombre del servidor."
    )
) else (
    echo.
    echo ERROR: No se pudo cambiar el nombre. ¿Lo estas ejecutando como Administrador?
)
pause
goto MENU

:: ======================================================
:INSTALL_ROLES
cls
echo --- 3. INSTALAR SERVICIOS (ENRUTAMIENTO Y DHCP) ---
echo.
echo Voy a instalar DHCP y Enrutamiento. Esto puede tardar un ratillo, ten paciencia...
powershell.exe -Command "Install-WindowsFeature DHCP, Routing -IncludeManagementTools"

if %errorlevel% equ 0 (
    echo.
    echo ¡Servicios instalados! Ya eres un profesional.
) else (
    echo.
    echo ERROR: No se han podido instalar los servicios.
)
pause
goto MENU

:: ======================================================
:CONFIG_FIREWALL
cls
echo --- 4. ARREGLAR EL FIREWALL ---
echo.
echo Abriendo el firewall para que puedas ver otros equipos y compartir archivos...
powershell.exe -Command "Enable-NetFirewallRule -DisplayGroup 'Network Discovery'"
powershell.exe -Command "Enable-NetFirewallRule -DisplayGroup 'File and Printer Sharing'"

if %errorlevel% equ 0 (
    echo.
    echo Firewall configurado. Ahora los PCs se deberian ver.
) else (
    echo.
    echo ERROR: No se pudo configurar el firewall.
)
pause
goto MENU

:: ======================================================
:CONFIG_DHCP
cls
echo --- 5. MONTAR EL DHCP ---
echo OJO: Para esto, ya deberias haber puesto una IP fija.
echo.
echo Necesito los datos para el rango de IPs que vas a repartir:
echo.
set /p "SCOPE_START=IP inicial del rango: "
set /p "SCOPE_END=IP final del rango: "
set /p "SCOPE_MASK=Mascara de subred para el rango: "
set /p "SCOPE_ROUTER=IP del router que le daras a los clientes: "
set /p "SCOPE_DNS=IP del DNS que le daras a los clientes: "
echo.
echo Creando el ambito DHCP...
powershell.exe -Command "Add-DhcpServerv4Scope -Name 'AmbitoSOR' -StartRange !SCOPE_START! -EndRange !SCOPE_END! -SubnetMask !SCOPE_MASK!; Set-DhcpServerv4OptionValue -DnsServer !SCOPE_DNS! -Router !SCOPE_ROUTER!"

if %errorlevel% equ 0 (
    echo.
    echo ¡Ambito DHCP creado y funcionando! Ya puedes repartir IPs como un campeon.
) else (
    echo.
    echo ERROR: No se pudo crear el ambito. ¿Instalaste el servicio DHCP antes?
)
pause
goto MENU

:: ======================================================
:SHOW_LEASES
cls
echo --- 6. CHIVARME DE QUIEN TIENE IP ---
echo.
echo Estas son las IPs que ha repartido tu DHCP:
echo.
powershell.exe -Command "Get-DhcpServerv4Lease -ComputerName localhost -AllLeases"
echo.
pause
goto MENU
