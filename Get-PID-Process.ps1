# Use Get-Process to retrieve information about processes
$processes = Get-Process

# Display process information
$processes | Select-Object Id, ProcessName | Select-String "<process-name>"


