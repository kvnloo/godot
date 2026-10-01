param(
    [string]$OutputPath = ("godot-input-env-{0}.txt" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
)

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("captured_at=$((Get-Date).ToString('o'))")

function Add-Result {
    param([string]$Label, [scriptblock]$Command)
    $lines.Add("")
    $lines.Add("$ $Label")
    try {
        $lines.Add(((& $Command 2>&1 | Out-String).TrimEnd()))
    } catch {
        $lines.Add("ERROR: $($_.Exception.Message)")
    }
}

Add-Result "git rev-parse HEAD" { git rev-parse HEAD }
Add-Result "Windows" { Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber }
Add-Result "CPU" { Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors }
Add-Result "GPU" { Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, CurrentRefreshRate }
Add-Result "Mouse devices" { Get-CimInstance Win32_PointingDevice | Select-Object Name, Manufacturer, DeviceID }

$lines | Set-Content -Path $OutputPath -Encoding utf8
Write-Host "wrote $OutputPath"
