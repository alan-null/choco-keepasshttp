$packageName = "keepass-keepasshttp"
$programUninstallEntryName = "KeePass Password Safe 2."

$registryPath = if ([Environment]::Is64BitOperatingSystem) {
  "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
}
else {
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
}

$installPath = (
  Get-ItemProperty $registryPath |
  Select-Object DisplayName, InstallLocation |
  Where-Object { $_.DisplayName -like "$programUninstallEntryName*" } |
  Select-Object -First 1
).InstallLocation.TrimEnd('\')

if (!$installPath) {
  Write-Warning "Could not locate KeePass installation. Plugin files may need manual cleanup."
  return
}

foreach ($path in @("$installPath\KeePassHttp.plgx", "$installPath\Plugins\KeePassHttp.plgx")) {
  if (Test-Path $path) {
    Remove-Item $path -Force
    Write-Host "Removed: $path"
  }
  else {
    Write-Verbose "Not found, skipping: $path"
  }
}