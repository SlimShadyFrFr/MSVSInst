Command: Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SlimShadyFrFr/MSVSInst/main/install.ps1" -OutFile "$env:TEMP\install.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\install.ps1"
