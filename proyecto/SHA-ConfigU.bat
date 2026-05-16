@echo off
title SHA-ConfigU - Configuracion de Restricciones y Perfiles
cls

:: ===============================================================
::                  VARIABLES DE CONFIGURACION
:: ===============================================================

:: 1. NOMBRE DE TU SERVIDOR (Para la ruta del perfil movil)
:: IMPORTANTE: Cambia "SERVIDOR-AD" por el nombre real de tu servidor (ej: SERVER-01)
set "SERVER_NAME=SERVIDOR-AD"

:: 2. NOMBRE DE LA CARPETA COMPARTIDA DE PERFILES
set "SHARE_NAME=Perfiles"

:: 3. LISTA DE EQUIPOS (MÁQUINAS CLIENTE)
:: Cambia estos nombres por los nombres reales de tus maquinas virtuales
:: Windows 11 (Para Academia y Guadalinfo - 5 PCs)
set "PCS_W11=W11-01,W11-02,W11-03,W11-04,W11-05"

:: Windows 10 (Para Biblioteca - 2 PCs)
set "PCS_W10=W10-01,W10-02"

:: ===============================================================
::              PREPARACION DEL ENTORNO
:: ===============================================================

echo [INFO] Creando carpeta para Perfiles Moviles en C:\Perfiles...
if not exist "C:\Perfiles" (
    mkdir "C:\Perfiles"
    :: Compartir la carpeta para que sea accesible por red
    net share %SHARE_NAME%=C:\Perfiles /GRANT:Todos,FULL
    echo [OK] Carpeta creada y compartida como \\%SERVER_NAME%\%SHARE_NAME%
) else (
    echo [INFO] La carpeta C:\Perfiles ya existe.
)
echo.

:: ===============================================================
:: 1. CONFIGURACION GUADALINFO
:: ===============================================================
:: Horario: 9:00 a 15:00 de Lunes a Sabado
:: PCs: Solo los 5 de Windows 11
:: Perfil: Movil

echo [1/3] Configurando usuarios de GUADALINFO...
if exist usu-guadalinfo.txt (
    for /F "tokens=*" %%i in (usu-guadalinfo.txt) do (
        echo    - Configurando %%i
        
        :: 1. Restriccion de Horario (M-Sa = Lunes a Sabado)
        :: Nota: Si tu Windows esta en Espanol, quizas necesites usar L-S en vez de M-Sa
        net user "%%i" /time:M-Sa,09:00-15:00
        
        :: 2. Restriccion de Equipos (Solo desde los W11)
        net user "%%i" /workstations:%PCS_W11%
        
        :: 3. Ruta de Perfil Movil
        net user "%%i" /profilepath:\\%SERVER_NAME%\%SHARE_NAME%\%%i
    )
) else (
    echo [ERROR] No se encuentra usu-guadalinfo.txt
)
echo.

:: ===============================================================
:: 2. CONFIGURACION ACADEMIA
:: ===============================================================
:: Horario: 17:00 a 21:00 de Lunes a Viernes
:: PCs: Solo los 5 de Windows 11 (Comparten PCs con Guadalinfo pero distinta hora)
:: Perfil: Movil

echo [2/3] Configurando usuarios de ACADEMIA...
if exist usu-academia.txt (
    for /F "tokens=*" %%i in (usu-academia.txt) do (
        echo    - Configurando %%i
        
        :: 1. Restriccion de Horario (M-F = Lunes a Viernes)
        net user "%%i" /time:M-F,17:00-21:00
        
        :: 2. Restriccion de Equipos (Solo desde los W11)
        net user "%%i" /workstations:%PCS_W11%
        
        :: 3. Ruta de Perfil Movil
        net user "%%i" /profilepath:\\%SERVER_NAME%\%SHARE_NAME%\%%i
    )
) else (
    echo [ERROR] No se encuentra usu-academia.txt
)
echo.

:: ===============================================================
:: 3. CONFIGURACION BIBLIOTECA
:: ===============================================================
:: Horario Complejo:
::   - 10:00 a 14:00 (Lunes a Sabado)
::   - 17:00 a 21:00 (Lunes a Viernes)
:: PCs: Solo los 2 de Windows 10
:: Perfil: Movil

echo [3/3] Configurando usuarios de BIBLIOTECA...
if exist usu-biblioteca.txt (
    for /F "tokens=*" %%i in (usu-biblioteca.txt) do (
        echo    - Configurando %%i
        
        :: 1. Restriccion de Horario Combinado
        :: Sintaxis: Dia,Hora;Dia,Hora...
        :: M-F (Lun-Vie) turno manana y tarde + Sa (Sab) turno manana
        net user "%%i" /time:M-F,10:00-14:00;M-F,17:00-21:00;Sa,10:00-14:00
        
        :: 2. Restriccion de Equipos (Solo desde los W10)
        net user "%%i" /workstations:%PCS_W10%
        
        :: 3. Ruta de Perfil Movil
        net user "%%i" /profilepath:\\%SERVER_NAME%\%SHARE_NAME%\%%i
    )
) else (
    echo [ERROR] No se encuentra usu-biblioteca.txt
)

echo.
echo ===============================================================
echo CONFIGURACION FINALIZADA.
echo ===============================================================
echo Comprueba si ha habido errores de "Nombre de equipo no valido".
echo Si es asi, edita el script y corrige las variables PCS_W11 y PCS_W10.
pause