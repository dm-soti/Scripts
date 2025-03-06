# PowerShell script for silent installation
Write-Output "Silent Installation started"

# Change directory to where the file is downloaded
Set-Location "C:\Path\To\Downloaded\File"

# Run the installer with silent mode and prerequisite flag
Start-Process -FilePath ".\MobiControl.exe" -ArgumentList "/s `"C:\Windows\Temp\Automation\Silent.JSON`" /prereq" -Wait -NoNewWindow

Write-Output "Installation completed"
