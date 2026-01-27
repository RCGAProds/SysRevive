# ============================================
# SYSREVIVE - WINDOWS SYSTEM REPAIR SCRIPT
# ============================================

# Color and format configuration
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# ============================================
# GLOBAL VARIABLES
# ============================================

$script:LogFile = Join-Path $PSScriptRoot "repair_powershell_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$script:StartTime = Get-Date

# ============================================
# LANGUAGE SELECTOR
# ============================================

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          SELECCION DE IDIOMA / LANGUAGE SELECTION         ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Español" -ForegroundColor White
Write-Host "  2. English" -ForegroundColor White
Write-Host ""

do {
    $langChoice = Read-Host "Select language / Seleccione idioma (1-2)"
} while ($langChoice -ne "1" -and $langChoice -ne "2")

$LANG = if ($langChoice -eq "1") { "es" } else { "en" }

# ============================================
# TRANSLATIONS DICTIONARY
# ============================================

$translations = @{
    es = @{
        banner_title = "SYSREVIVE - SCRIPT DE REPARACION DEL SISTEMA - WINDOWS"
        banner_subtitle = "Reparacion tras apagon o corrupcion de archivos"
        starting = "Iniciando proceso de reparacion del sistema..."
        phase1 = "FASE 1: System File Checker (SFC)"
        phase2 = "FASE 2: DISM - Reparacion de Imagen del Sistema"
        phase3 = "FASE 3: Verificacion Final SFC"
        phase4 = "FASE 4: Limpieza del Sistema"
        completed = "PROCESO DE REPARACION COMPLETADO"
        total_time = "Tiempo total de ejecucion"
        phase_time = "Tiempo de la fase"
        recommendations = "RECOMENDACIONES:"
        recommend1 = "Revise el archivo C:\Windows\Logs\CBS\CBS.log para detalles"
        recommend2 = "Revise el archivo C:\Windows\Logs\DISM\dism.log para detalles DISM"
        recommend3 = "Se recomienda reiniciar el sistema"
        recommend4 = "Revise el log del script en"
        restart_prompt = "¿Desea reiniciar el sistema ahora? (S/N)"
        restart_warning = "Reiniciando el sistema en 10 segundos..."
        restart_cancelled = "Reinicio cancelado. Presione Ctrl+C para detener si es necesario"
        restart_reminder = "Recuerde reiniciar manualmente para aplicar todos los cambios"
        press_enter = "Presione Enter para salir"
        creating_restore = "Creando punto de restauracion del sistema..."
        restore_success = "Punto de restauracion creado exitosamente"
        restore_failed = "No se pudo crear punto de restauracion"
        restore_warning = "Continuando sin punto de restauracion"
        free_space = "Espacio libre en disco C"
        low_space_warning = "ADVERTENCIA: Espacio en disco bajo. Se recomienda al menos 10GB libres"
        continue_prompt = "¿Desea continuar de todos modos? (S/N)"
        user_cancelled = "Proceso cancelado por el usuario"
        running_sfc = "Ejecutando SFC /scannow..."
        wait_message = "Este proceso puede tardar 05-30 minutos. Por favor, espere..."
        sfc_completed = "SFC completado exitosamente en"
        sfc_failed = "SFC finalizo con codigo de salida"
        verifying_image = "Verificando el estado de la imagen..."
        scanning_health = "Escaneando la salud de la imagen..."
        restoring_image = "Restaurando la imagen del sistema..."
        wait_message_long = "Este proceso puede tardar 10-40 minutos. Por favor, espere..."
        dism_success = "DISM completado exitosamente en"
        dism_failed = "DISM finalizo con codigo de salida"
        final_verification = "Ejecutando verificacion final con SFC..."
        cleaning_temp = "Limpiando archivos temporales y componentes..."
        cleanup_success = "Limpieza completada en"
        minutes = "minutos"
        yes_responses = @("S", "s", "SI", "si", "Si", "1")
        no_responses = @("N", "n", "NO", "no", "No", "0")
        warning_title = "INFORMACION IMPORTANTE"
        warning_duration = "DURACION ESTIMADA DEL PROCESO"
        warning_phases = "El proceso de reparacion consta de 4 fases:"
        warning_phase1_desc = "  • Fase 1 (SFC inicial): 05-30 minutos"
        warning_phase2_desc = "  • Fase 2 (DISM): 10-40 minutos"
        warning_phase3_desc = "  • Fase 3 (SFC final): 05-30 minutos"
        warning_phase4_desc = "  • Fase 4 (Limpieza): 01-10 minutos"
        warning_total = "TIEMPO TOTAL ESTIMADO: 20 minutos a 2 horas (Depende del rendimiento del disco)"
        warning_recommendations_title = "IMPORTANTE ANTES DE CONTINUAR:"
        warning_rec1 = "  [OK] Asegurese de tener el equipo conectado a la corriente"
        warning_rec2 = "  [OK] No apague ni reinicie el equipo durante el proceso"
        warning_rec3 = "  [OK] Cierre todas las aplicaciones abiertas"
        warning_rec4 = "  [OK] Guarde todo su trabajo antes de continuar"
        warning_rec5 = "  [OK] El equipo puede volverse lento durante el proceso"
        warning_continue = "¿Desea continuar con el proceso de reparacion? (S/N)"
        warning_cancelled = "Proceso cancelado por el usuario"
        log_created = "Archivo de log creado"
    }
    en = @{
        banner_title = "SYSREVIVE - SYSTEM REPAIR SCRIPT - WINDOWS"
        banner_subtitle = "Repair after power outage or file corruption"
        starting = "Starting system repair process..."
        phase1 = "PHASE 1: System File Checker (SFC)"
        phase2 = "PHASE 2: DISM - System Image Repair"
        phase3 = "PHASE 3: Final SFC Verification"
        phase4 = "PHASE 4: System Cleanup"
        completed = "REPAIR PROCESS COMPLETED"
        total_time = "Total execution time"
        phase_time = "Phase duration"
        recommendations = "RECOMMENDATIONS:"
        recommend1 = "Review the file C:\Windows\Logs\CBS\CBS.log for details"
        recommend2 = "Review the file C:\Windows\Logs\DISM\dism.log for DISM details"
        recommend3 = "System restart is recommended"
        recommend4 = "Review the script log at"
        restart_prompt = "Do you want to restart the system now? (Y/N)"
        restart_warning = "Restarting the system in 10 seconds..."
        restart_cancelled = "Restart cancelled. Press Ctrl+C to stop if needed"
        restart_reminder = "Remember to restart manually to apply all changes"
        press_enter = "Press Enter to exit"
        creating_restore = "Creating system restore point..."
        restore_success = "Restore point created successfully"
        restore_failed = "Could not create restore point"
        restore_warning = "Continuing without restore point"
        free_space = "Free space on drive C"
        low_space_warning = "WARNING: Low disk space. At least 10GB free is recommended"
        continue_prompt = "Do you want to continue anyway? (Y/N)"
        user_cancelled = "Process cancelled by user"
        running_sfc = "Running SFC /scannow..."
        wait_message = "This process may take 05-30 minutes. Please wait..."
        sfc_completed = "SFC completed successfully in"
        sfc_failed = "SFC finished with exit code"
        verifying_image = "Verifying image health..."
        scanning_health = "Scanning image health..."
        restoring_image = "Restoring system image..."
        wait_message_long = "This process may take 10-40 minutes. Please wait..."
        dism_success = "DISM completed successfully in"
        dism_failed = "DISM finished with exit code"
        final_verification = "Running final SFC verification..."
        cleaning_temp = "Cleaning temporary files and components..."
        cleanup_success = "Cleanup completed in"
        minutes = "minutes"
        yes_responses = @("Y", "y", "YES", "yes", "Yes", "1")
        no_responses = @("N", "n", "NO", "no", "No", "0")
        warning_title = "IMPORTANT INFORMATION"
        warning_duration = "ESTIMATED PROCESS DURATION"
        warning_phases = "The repair process consists of 4 phases:"
        warning_phase1_desc = "  • Phase 1 (Initial SFC): 05-30 minutes"
        warning_phase2_desc = "  • Phase 2 (DISM): 10-40 minutes"
        warning_phase3_desc = "  • Phase 3 (Final SFC): 05-30 minutes"
        warning_phase4_desc = "  • Phase 4 (Cleanup): 01-10 minutes"
        warning_total = "TOTAL ESTIMATED TIME: 20 minutes to 2 hours (Depends on disk performance)"
        warning_recommendations_title = "IMPORTANT BEFORE CONTINUING:"
        warning_rec1 = "  [OK] Make sure your computer is plugged into power"
        warning_rec2 = "  [OK] Do not turn off or restart during the process"
        warning_rec3 = "  [OK] Close all open applications"
        warning_rec4 = "  [OK] Save all your work before continuing"
        warning_rec5 = "  [OK] The computer may become slow during the process"
        warning_continue = "Do you want to continue with the repair process? (Y/N)"
        warning_cancelled = "Process cancelled by user"
        log_created = "Log file created"
    }
}

$t = $translations[$LANG]

# ============================================
# LOGGING FUNCTIONS
# ============================================

function Write-Log {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type] $Message"
    Add-Content -Path $script:LogFile -Value $logEntry -Encoding UTF8
}

function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $prefix = switch ($Type) {
        "Info"    { "[INFO]"; $color = "Cyan" }
        "Success" { "[OK]"; $color = "Green" }
        "Warning" { "[WARN]"; $color = "Yellow" }
        "Error"   { "[ERROR]"; $color = "Red" }
        "Process" { "[RUN]"; $color = "Magenta" }
        default   { "[INFO]"; $color = "White" }
    }
    
    $output = "[$timestamp] $prefix $Message"
    Write-Host $output -ForegroundColor $color
    Write-Log -Message $Message -Type $Type.ToUpper()
}

# ============================================
# HELPER FUNCTIONS
# ============================================

function Format-Duration {
    param([TimeSpan]$Duration)
    
    if ($Duration.TotalHours -ge 1) {
        return $Duration.ToString("hh\:mm\:ss")
    } else {
        return $Duration.ToString("mm\:ss")
    }
}

function New-RestorePoint {
    Write-Status $t.creating_restore "Process"
    try {
        Enable-ComputerRestore -Drive "$env:SystemDrive" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Pre-System-Repair-$(Get-Date -Format 'yyyyMMdd-HHmmss')" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Status $t.restore_success "Success"
        return $true
    } catch {
        Write-Status "$($t.restore_failed): $($_.Exception.Message)" "Error"
        Write-Status $t.restore_warning "Warning"
        return $false
    }
}

function Test-DiskSpace {
    $drive = Get-PSDrive -Name C -ErrorAction SilentlyContinue
    if (-not $drive) {
        Write-Status "Could not check disk space" "Warning"
        return $true
    }
    
    $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
    Write-Status "$($t.free_space): $freeSpaceGB GB" "Info"
    
    if ($freeSpaceGB -lt 10) {
        Write-Status $t.low_space_warning "Warning"
        do {
            $continue = Read-Host "  $($t.continue_prompt)"
        } while ($continue -notin $t.yes_responses -and $continue -notin $t.no_responses)
        
        if ($continue -in $t.no_responses) {
            Write-Status $t.user_cancelled "Warning"
            return $false
        }
    }
    return $true
}

# ============================================
# INITIAL WARNING AND CONFIRMATION
# ============================================

Clear-Host

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║               $($t.warning_title.PadRight(43)) ║" -ForegroundColor Yellow
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "  $($t.warning_duration)" -ForegroundColor Cyan
Write-Host "  $("=" * 59)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  $($t.warning_phases)" -ForegroundColor White
Write-Host "$($t.warning_phase1_desc)" -ForegroundColor Gray
Write-Host "$($t.warning_phase2_desc)" -ForegroundColor Gray
Write-Host "$($t.warning_phase3_desc)" -ForegroundColor Gray
Write-Host "$($t.warning_phase4_desc)" -ForegroundColor Gray
Write-Host ""
Write-Host "  $($t.warning_total)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  $("=" * 59)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  $($t.warning_recommendations_title)" -ForegroundColor Cyan
Write-Host ""
Write-Host "$($t.warning_rec1)" -ForegroundColor White
Write-Host "$($t.warning_rec2)" -ForegroundColor White
Write-Host "$($t.warning_rec3)" -ForegroundColor White
Write-Host "$($t.warning_rec4)" -ForegroundColor White
Write-Host "$($t.warning_rec5)" -ForegroundColor White
Write-Host ""
Write-Host "  $("=" * 59)" -ForegroundColor DarkGray
Write-Host ""

do {
    $confirmContinue = Read-Host "  $($t.warning_continue)"
} while ($confirmContinue -notin $t.yes_responses -and $confirmContinue -notin $t.no_responses)

if ($confirmContinue -in $t.no_responses) {
    Write-Host ""
    Write-Host "  $($t.warning_cancelled)" -ForegroundColor Red
    Write-Host ""
    Read-Host "  $($t.press_enter)"
    exit 0
}

Clear-Host

# ============================================
# INITIALIZE LOG FILE
# ============================================

try {
    "=" * 80 | Out-File -FilePath $script:LogFile -Encoding UTF8
    "SYSREVIVE - WINDOWS SYSTEM REPAIR SCRIPT - EXECUTION LOG" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
    "=" * 80 | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
    "" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
    Write-Log "Script started" "INFO"
    Write-Log "Language selected: $LANG" "INFO"
    Write-Log "Log file: $script:LogFile" "INFO"
    "" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
} catch {
    Write-Warning "Could not create log file: $($_.Exception.Message)"
}

# ============================================
# BANNER
# ============================================

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     $($t.banner_title.PadRight(53))║" -ForegroundColor Cyan
Write-Host "║     $($t.banner_subtitle.PadRight(53))║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Status "$($t.log_created): $script:LogFile" "Info"
Write-Status $t.starting "Info"
Write-Host ""

# ============================================
# PRELIMINARY CHECKS
# ============================================

if (-not (Test-DiskSpace)) {
    Read-Host $t.press_enter
    exit 1
}

New-RestorePoint | Out-Null

Write-Host ""

# ============================================
# PHASE 1: INITIAL SFC
# ============================================

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  $($t.phase1)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

Write-Status $t.running_sfc "Process"
Write-Status $t.wait_message "Info"
Write-Host ""

$phase1Start = Get-Date
Write-Log "PHASE 1 started: SFC initial scan" "INFO"

$sfcProcess = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -PassThru -NoNewWindow
$sfcExitCode = $sfcProcess.ExitCode

$phase1End = Get-Date
$phase1Duration = $phase1End - $phase1Start

Write-Host ""
if ($sfcExitCode -eq 0) {
    Write-Status "$($t.sfc_completed) $(Format-Duration $phase1Duration)" "Success"
    Write-Log "PHASE 1 completed successfully - Duration: $(Format-Duration $phase1Duration)" "SUCCESS"
} else {
    Write-Status "$($t.sfc_failed) $sfcExitCode - $(Format-Duration $phase1Duration)" "Warning"
    Write-Log "PHASE 1 completed with warnings - Exit code: $sfcExitCode - Duration: $(Format-Duration $phase1Duration)" "WARNING"
}

# ============================================
# PHASE 2: DISM REPAIR
# ============================================

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  $($t.phase2)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

$phase2Start = Get-Date
Write-Log "PHASE 2 started: DISM repair" "INFO"

Write-Status $t.verifying_image "Process"
DISM.exe /Online /Cleanup-Image /CheckHealth | Out-Null
Write-Host ""

Write-Status $t.scanning_health "Process"
DISM.exe /Online /Cleanup-Image /ScanHealth | Out-Null
Write-Host ""

Write-Status $t.restoring_image "Process"
Write-Status $t.wait_message_long "Info"
Write-Host ""

$dismProcess = Start-Process -FilePath "DISM.exe" -ArgumentList "/Online", "/Cleanup-Image", "/RestoreHealth" -Wait -PassThru -NoNewWindow
$dismExitCode = $dismProcess.ExitCode

$phase2End = Get-Date
$phase2Duration = $phase2End - $phase2Start

Write-Host ""
if ($dismExitCode -eq 0) {
    Write-Status "$($t.dism_success) $(Format-Duration $phase2Duration)" "Success"
    Write-Log "PHASE 2 completed successfully - Duration: $(Format-Duration $phase2Duration)" "SUCCESS"
} else {
    Write-Status "$($t.dism_failed) $dismExitCode - $(Format-Duration $phase2Duration)" "Warning"
    Write-Log "PHASE 2 completed with warnings - Exit code: $dismExitCode - Duration: $(Format-Duration $phase2Duration)" "WARNING"
}

# ============================================
# PHASE 3: FINAL SFC VERIFICATION
# ============================================

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  $($t.phase3)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

$phase3Start = Get-Date
Write-Log "PHASE 3 started: Final SFC verification" "INFO"

Write-Status $t.final_verification "Process"
$sfcFinalProcess = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -PassThru -NoNewWindow
$sfcFinalExitCode = $sfcFinalProcess.ExitCode

$phase3End = Get-Date
$phase3Duration = $phase3End - $phase3Start

Write-Host ""
if ($sfcFinalExitCode -eq 0) {
    Write-Status "$($t.sfc_completed) $(Format-Duration $phase3Duration)" "Success"
    Write-Log "PHASE 3 completed successfully - Duration: $(Format-Duration $phase3Duration)" "SUCCESS"
} else {
    Write-Status "$($t.sfc_failed) $sfcFinalExitCode - $(Format-Duration $phase3Duration)" "Warning"
    Write-Log "PHASE 3 completed with warnings - Exit code: $sfcFinalExitCode - Duration: $(Format-Duration $phase3Duration)" "WARNING"
}

# ============================================
# PHASE 4: SYSTEM CLEANUP
# ============================================

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  $($t.phase4)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

$phase4Start = Get-Date
Write-Log "PHASE 4 started: System cleanup" "INFO"

Write-Status $t.cleaning_temp "Process"
DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null

$phase4End = Get-Date
$phase4Duration = $phase4End - $phase4Start

Write-Host ""
Write-Status "$($t.cleanup_success) $(Format-Duration $phase4Duration)" "Success"
Write-Log "PHASE 4 completed - Duration: $(Format-Duration $phase4Duration)" "SUCCESS"

# ============================================
# FINAL SUMMARY
# ============================================

$totalDuration = $phase4End - $script:StartTime

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              $($t.completed.PadRight(43))║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Status "$($t.total_time): $(Format-Duration $totalDuration)" "Success"
Write-Log "=" * 80 "INFO"
Write-Log "REPAIR PROCESS COMPLETED" "SUCCESS"
Write-Log "Total duration: $(Format-Duration $totalDuration)" "INFO"
Write-Log "Phase 1 (SFC Initial): $(Format-Duration $phase1Duration)" "INFO"
Write-Log "Phase 2 (DISM): $(Format-Duration $phase2Duration)" "INFO"
Write-Log "Phase 3 (SFC Final): $(Format-Duration $phase3Duration)" "INFO"
Write-Log "Phase 4 (Cleanup): $(Format-Duration $phase4Duration)" "INFO"
Write-Log "=" * 80 "INFO"

Write-Host ""
Write-Status $t.recommendations "Info"
Write-Host "  • $($t.recommend1)" -ForegroundColor White
Write-Host "  • $($t.recommend2)" -ForegroundColor White
Write-Host "  • $($t.recommend3)" -ForegroundColor White
Write-Host "  • $($t.recommend4): $script:LogFile" -ForegroundColor White
Write-Host ""

# ============================================
# RESTART PROMPT
# ============================================

do {
    $restart = Read-Host $t.restart_prompt
} while ($restart -notin $t.yes_responses -and $restart -notin $t.no_responses)

if ($restart -in $t.yes_responses) {
    Write-Status $t.restart_warning "Warning"
    Write-Log "System restart initiated by user" "INFO"
    Start-Sleep -Seconds 3
    
    try {
        shutdown /r /t 10 /c "System repair completed - Restarting"
        Write-Host ""
        Write-Host "  $($t.restart_cancelled)" -ForegroundColor Yellow
    } catch {
        Write-Status "Could not initiate restart: $($_.Exception.Message)" "Error"
        Write-Status $t.restart_reminder "Warning"
    }
} else {
    Write-Status $t.restart_reminder "Warning"
    Write-Log "User chose not to restart" "INFO"
}

Write-Host ""
Read-Host $t.press_enter

Write-Log "Script finished" "INFO"
exit 0