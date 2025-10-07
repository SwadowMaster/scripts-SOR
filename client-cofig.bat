::Script SOR WindowServer config - Alejandro Santana, 2ºSMR
::            FUCIONALIDADES
::Asigna las IP estáticas de los clientes.
::Asigna el nombre de los clientes.
::Asigna las IP automáticas (DHCP) de los clientes.
@echo off
:: Allow to use vairbles with !-!
setlocal enabledelayedexpansion

Echo Basic windows client config SOR - Alejandro Santana
::Ask for IP address of the client
set /p IP_CLIENT=Enter IP address of the client: 
set /p MASK=Enter subnet mask: 
set /p GATEWAY=Enter default gateway: 

::Ask for interface name
set /p INTERFACE_NAME=Enter name to assign as interface name: 

::Ask for client name
set /p NAME_CLIENT=Enter client name: 

::Assign IP address and interface name
netsh int ip set address name=!INTERFACE_NAME! source=static addr=!IP_CLIENT! mask=!MASK! gateway=!GATEWAY!

::Assign client name
wmic path Win32_ComputerSystem where "name='!NAME_CLIENT!'" call rename name=!NAME_CLIENT!
for /f "tokens=2 delims=:" %%a in ('netsh int ip show config name ^!INTERFACE_NAME! ^| findstr /i "IP Address"') do (
    if "%%a" == "IP Address" (
        echo La IP de este equipo es %%b
    )
)
pause
