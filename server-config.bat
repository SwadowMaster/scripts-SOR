::Script SOR WindowServer config - Alejandro Santana, 2ºSMR
::            FUCIONALIDADES
::Asigna las IP estáticas del Servidor.
::Asigna el nombre del Servidor.
::Configurar servicios.
::Activar detección de redes.
::Instalar y configurar servicio de Enrutamiento.
::Instalar y configurar servicio de DHCP.
::Consultar concesión de direcciones en Servidor DHCP

@echo off
:: Allow to use vairbles with !-!
setlocal enabledelayedexpansion

Echo Basic windows server config with DHCP SOR - Alejandro Santana
::Request server info before set
set /p IP_SERVER=Enter IP address of the server: 
set /p MASK=Enter subnet mask: 
set /p GATEWAY=Enter default gateway: 
set /p INTERFACE_NAME=Name to assign as interfacename: 
netsh int ip set address name=!INTERFACE_NAME! source=static addr=!IP_SERVER! mask=!MASK! gateway=!GATEWAY!

::Server name assignation
::https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/renaming-a-computer-using-wmic-and-how-to-get-around-that/ba-p/396043
set /p NAME_SERVER=Enter server Name: 
wmic path Win32_ComputerSystem where "name='!NAME_SERVER!'" call rename name=!NAME_SERVER!

::Config services
netsh firewall set service type=fileandprint opmode=enable
netsh firewall set service type=upnp opmode=enable

::To enable red detections 
netsh advfirewall set allprofiles state on

::Install and config "router services"
netsh routing ip nat install
netsh routing ip nat add global
netsh routing ip nat add interface name=!INTERFACE_NAME! addr=!IP_SERVER!

::Install and reuse same variables at the start
netsh dhcp install
set /p SCOPE_NAME=Ente name for DHCP: 
netsh dhcp server scope add name=!SCOPE_NAME! start=!IP_SERVER! end=!IP_SERVER! mask=!MASK! state=active

::Show al info 
netsh dhcp server show scope

pause