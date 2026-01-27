@echo off
:: ============================================
:: SYSREVIVE - WINDOWS REPAIR SCRIPT LAUNCHER
:: ============================================

:: Configure UTF-8 encoding and console window
chcp 65001 >nul 2>&1
color 0A
mode con: cols=100 lines=35
title SysRevive - Windows System Repair Tool

:: Global variables
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%repair_windows.ps1"

:: Generate timestamp for log file
set "TIMESTAMP=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "LOG_FILE=%SCRIPT_DIR%repair_log_%TIMESTAMP%.txt"

:: Execute main function and exit with its code
call :main
exit /b %errorlevel%

:: ============================================
:: FUNCTION: Check administrator privileges
:: ============================================
:check_admin
>nul 2>&1 fsutil dirty query %systemdrive% || (
    call :print_error "ADMIN_REQUIRED"
    exit /b 1
)
goto :eof

:: ============================================
:: FUNCTION: Check if PowerShell is installed
:: ============================================
:check_powershell
where powershell.exe >nul 2>&1 || (
    call :print_error "POWERSHELL_MISSING"
    exit /b 1
)
goto :eof

:: ============================================
:: FUNCTION: Check if PS1 script file exists
:: ============================================
:check_ps1_file
if not exist "%PS_SCRIPT%" (
    call :print_error "PS1_NOT_FOUND"
    exit /b 1
)
goto :eof

:: ============================================
:: FUNCTION: Print error messages
:: ============================================
:print_error
cls
echo.
echo ================================================================================
echo                              [ERROR] ERROR DETECTADO
echo ================================================================================
echo.

if "%~1"=="ADMIN_REQUIRED" (
    echo  [ES] Este script REQUIERE permisos de ADMINISTRADOR
    echo  [EN] This script REQUIRES ADMINISTRATOR privileges
    echo.
    echo  [ES] SOLUCION: Haz clic derecho ^> "Ejecutar como administrador"
    echo  [EN] SOLUTION: Right-click ^> "Run as administrator"
)

if "%~1"=="POWERSHELL_MISSING" (
    echo  [ES] PowerShell NO esta instalado en este sistema
    echo  [EN] PowerShell is NOT installed on this system
    echo.
    echo  [ES] SOLUCION: Instalar PowerShell desde microsoft.com
    echo  [EN] SOLUTION: Install PowerShell from microsoft.com
)

if "%~1"=="PS1_NOT_FOUND" (
    echo  [ES] ERROR: No se encuentra "repair_windows.ps1"
    echo  [EN] ERROR: File "repair_windows.ps1" not found
    echo.
    echo  [ES] Ubicacion esperada: %PS_SCRIPT%
    echo  [EN] Expected location: %PS_SCRIPT%
    echo.
    echo  [ES] SOLUCION: Colocar ambos archivos en la misma carpeta
    echo  [EN] SOLUTION: Place both files in the same folder
)

echo.
echo ================================================================================
echo.
echo [%date% %time%] ERROR: %~1 >> "%LOG_FILE%" 2>nul
pause
exit /b 1

:: ============================================
:: FUNCTION: Print header
:: ============================================
:print_header
cls
echo.
echo ================================================================================
echo              [TOOL] SYSREVIVE - WINDOWS SYSTEM REPAIR TOOL
echo ================================================================================
echo.
echo  [ES] Iniciando verificaciones del sistema...
echo  [EN] Starting system checks...
echo.
echo ================================================================================
echo.
goto :eof

:: ============================================
:: FUNCTION: Log message
:: ============================================
:log_message
echo [%date% %time%] %~1 >> "%LOG_FILE%"
goto :eof

:: ============================================
:: MAIN FUNCTION
:: ============================================
:main
call :print_header

:: Initialize log file
echo ================================================================================ > "%LOG_FILE%"
echo SYSREVIVE - WINDOWS SYSTEM REPAIR TOOL - Execution Log >> "%LOG_FILE%"
echo ================================================================================ >> "%LOG_FILE%"
call :log_message "Script started"
call :log_message "Log file: %LOG_FILE%"
echo.

:: Step 1: Check administrator privileges
echo  [1/3] [ES] Verificando permisos de administrador...
echo  [1/3] [EN] Checking administrator privileges...
call :check_admin
if errorlevel 1 exit /b 1
echo        [OK] Administrator privileges confirmed
call :log_message "[OK] Administrator check passed"
echo.

:: Step 2: Check PowerShell installation
echo  [2/3] [ES] Verificando instalacion de PowerShell...
echo  [2/3] [EN] Checking PowerShell installation...
call :check_powershell
if errorlevel 1 exit /b 1
echo        [OK] PowerShell found
call :log_message "[OK] PowerShell check passed"
echo.

:: Step 3: Check PS1 script file exists
echo  [3/3] [ES] Verificando archivo de reparacion...
echo  [3/3] [EN] Checking repair script file...
call :check_ps1_file
if errorlevel 1 exit /b 1
echo        [OK] Repair script found
call :log_message "[OK] PS1 script file check passed"
echo.

echo ================================================================================
echo  [ES] [RUN] Ejecutando script de reparacion...
echo  [EN] [RUN] Running repair script...
echo ================================================================================
echo.
call :log_message "Starting PowerShell repair script execution"

:: Execute PowerShell with error handling
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "& { " ^
    "    $ErrorActionPreference = 'Stop'; " ^
    "    try { " ^
    "        & '%PS_SCRIPT%' " ^
    "    } catch { " ^
    "        Write-Host '[ERROR] PowerShell exception:' $_.Exception.Message; " ^
    "        exit 1 " ^
    "    } " ^
    "}"

set "EXIT_CODE=%errorlevel%"

:: Log result
call :log_message "Script finished - Exit code: %EXIT_CODE%"
call :log_message "================================================================================"

:: Display result
echo.
echo ================================================================================
if %EXIT_CODE% equ 0 (
    echo  [OK] [ES] Reparacion completada exitosamente
    echo  [OK] [EN] Repair completed successfully
    call :log_message "[SUCCESS] Repair completed successfully"
) else (
    echo  [ERROR] [ES] Error durante la reparacion - Codigo: %EXIT_CODE%
    echo  [ERROR] [EN] Error during repair - Code: %EXIT_CODE%
    echo.
    echo  [ES] Consulta el log: %LOG_FILE%
    echo  [EN] Check log file: %LOG_FILE%
    call :log_message "[FAILURE] Repair failed with code %EXIT_CODE%"
)
echo ================================================================================
echo.
echo  [ES] Presiona cualquier tecla para salir...
echo  [EN] Press any key to exit...
pause >nul
exit /b %EXIT_CODE%