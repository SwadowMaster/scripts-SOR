@echo off
title Script de Creacion y Organizacion SHA-119
cls

:: --- VARIABLES DEL DOMINIO ---
:: Cambia esto si tu dominio o contenedor de origen cambia
set "DOMINIO=dc=SHA-119,dc=Servicios"
set "ORIGEN=cn=Users"

echo ========================================================
echo      INICIANDO CONFIGURACION PARA SHA-119.Servicios
echo ========================================================
echo.

:: ---------------------------------------------------------
:: 1. PROCESANDO ACADEMIA
:: ---------------------------------------------------------
echo [1/3] Procesando ACADEMIA...
echo  - Creando OU y Grupo...
dsadd ou "ou=SHA-Academia,%DOMINIO%" 2>nul
dsadd group "cn=SHA-Academia,ou=SHA-Academia,%DOMINIO%" -secgrp yes -scope g 2>nul

echo  - Creando usuarios (pass: 1234), moviendo y agregando al grupo...
if exist usu-academia.txt (
    for /F "tokens=*" %%i in (usu-academia.txt) do (
        echo    Procesando usuario: %%i
        
        :: 1. Crear usuario (Ocultamos error si ya existe con 2>nul)
        net user "%%i" 1234 /add /domain >nul 2>nul

        :: 2. Mover usuario de Users a la nueva OU
        dsmove "cn=%%i,%ORIGEN%,%DOMINIO%" -newparent "ou=SHA-Academia,%DOMINIO%" >nul 2>nul
        
        :: 3. Anadir usuario al grupo
        dsmod group "cn=SHA-Academia,ou=SHA-Academia,%DOMINIO%" -addmbr "cn=%%i,ou=SHA-Academia,%DOMINIO%"
    )
    echo    > Hecho.
) else (
    echo    ERROR: No se encuentra el archivo usu-academia.txt
)
echo.

:: ---------------------------------------------------------
:: 2. PROCESANDO GUADALINFO
:: ---------------------------------------------------------
echo [2/3] Procesando GUADALINFO...
echo  - Creando OU y Grupo...
dsadd ou "ou=SHA-Guadalinfo,%DOMINIO%" 2>nul
dsadd group "cn=SHA-Guadalinfo,ou=SHA-Guadalinfo,%DOMINIO%" -secgrp yes -scope g 2>nul

echo  - Creando usuarios (pass: 1234), moviendo y agregando al grupo...
if exist usu-guadalinfo.txt (
    for /F "tokens=*" %%i in (usu-guadalinfo.txt) do (
        echo    Procesando usuario: %%i
        
        :: 1. Crear usuario
        net user "%%i" 1234 /add /domain >nul 2>nul
        
        :: 2. Mover usuario
        dsmove "cn=%%i,%ORIGEN%,%DOMINIO%" -newparent "ou=SHA-Guadalinfo,%DOMINIO%" >nul 2>nul
        
        :: 3. Anadir al grupo
        dsmod group "cn=SHA-Guadalinfo,ou=SHA-Guadalinfo,%DOMINIO%" -addmbr "cn=%%i,ou=SHA-Guadalinfo,%DOMINIO%"
    )
    echo    > Hecho.
) else (
    echo    ERROR: No se encuentra el archivo usu-guadalinfo.txt
)
echo.

:: ---------------------------------------------------------
:: 3. PROCESANDO BIBLIOTECA
:: ---------------------------------------------------------
echo [3/3] Procesando BIBLIOTECA...
echo  - Creando OU y Grupo...
dsadd ou "ou=SHA-Biblioteca,%DOMINIO%" 2>nul
dsadd group "cn=SHA-Biblioteca,ou=SHA-Biblioteca,%DOMINIO%" -secgrp yes -scope g 2>nul

echo  - Creando usuarios (pass: 1234), moviendo y agregando al grupo...
if exist usu-biblioteca.txt (
    for /F "tokens=*" %%i in (usu-biblioteca.txt) do (
        echo    Procesando usuario: %%i
        
        :: 1. Crear usuario
        net user "%%i" 1234 /add /domain >nul 2>nul
        
        :: 2. Mover usuario
        dsmove "cn=%%i,%ORIGEN%,%DOMINIO%" -newparent "ou=SHA-Biblioteca,%DOMINIO%" >nul 2>nul
        
        :: 3. Anadir al grupo
        dsmod group "cn=SHA-Biblioteca,ou=SHA-Biblioteca,%DOMINIO%" -addmbr "cn=%%i,ou=SHA-Biblioteca,%DOMINIO%"
    )
    echo    > Hecho.
) else (
    echo    ERROR: No se encuentra el archivo usu-biblioteca.txt
)
echo.
echo --------------------------------------------------------
echo.

:: ---------------------------------------------------------
:: 4. VERIFICACION FINAL
:: ---------------------------------------------------------
echo ========================================================
echo                VERIFICACION DE RESULTADOS
echo ========================================================
echo.

echo MIEMBROS DEL GRUPO SHA-ACADEMIA:
dsget group "cn=SHA-Academia,ou=SHA-Academia,%DOMINIO%" -members
echo.
echo -------------------------------------------
echo MIEMBROS DEL GRUPO SHA-GUADALINFO:
dsget group "cn=SHA-Guadalinfo,ou=SHA-Guadalinfo,%DOMINIO%" -members
echo.
echo -------------------------------------------
echo MIEMBROS DEL GRUPO SHA-BIBLIOTECA:
dsget group "cn=SHA-Biblioteca,ou=SHA-Biblioteca,%DOMINIO%" -members
echo.

echo ========================================================
echo PROCESO COMPLETADO. 
echo Si ves los usuarios listados arriba, todo ha salido bien.
pause