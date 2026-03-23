$packageName = "keepass-keepasshttp"
$url = "https://github.com/alan-null/keepasshttp/releases/download/v2.2.0.0/KeePassHttp.plgx"
$checksum = "fe1f743ac4733db121b28dae048b77f2aeb49d4bcc40823ffd3d68a0f66c7760"
$checksumType = "sha256"

$programUninstallEntryName = "KeePass Password Safe 2."

$is64bit = [Environment]::Is64BitOperatingSystem
if ($is64bit) {
  $registryPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
}
else {
  $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
}

$installPath = (
  Get-ItemProperty $registryPath |
  Select-Object DisplayName, InstallLocation |
  Where-Object { $_.DisplayName -like "$programUninstallEntryName*" } |
  Select-Object -First 1
).InstallLocation.TrimEnd('\')

if (!$installPath) {
  throw "Could not locate KeePass Password Safe 2.x installation location."
}

# Cleanup plugin from both old and new locations
foreach ($legacyPath in @("$installPath\KeePassHttp.plgx", "$installPath\Plugins\KeePassHttp.plgx")) {
  if (Test-Path $legacyPath) { Remove-Item $legacyPath -Force }
}

$pluginsDir = "$installPath\Plugins"
if (!(Test-Path $pluginsDir)) {
  New-Item -ItemType Directory -Path $pluginsDir | Out-Null
}

Get-ChocolateyWebFile -PackageName $packageName `
  -FileFullPath "$pluginsDir\KeePassHttp.plgx" `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType $checksumType