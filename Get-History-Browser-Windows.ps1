# Set error action preference to SilentlyContinue
Set-Variable -Name ErrorActionPreference -Value SilentlyContinue

# Create a temporary directory
New-Item -Path "C:\windows\Temp\ftech_temp" -ItemType Directory -Force -ErrorAction SilentlyContinue

# Remove existing report.csv file
Remove-Item -Path "C:\windows\Temp\ftech_temp\report.csv" -Force

# Download BrowsingHistoryView tool
Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/browsinghistoryview-x64.zip" -OutFile "C:\windows\Temp\ftech_temp\browsinghistoryview-x64.zip"

# Extract the downloaded archive
Expand-Archive "C:\windows\Temp\ftech_temp\browsinghistoryview-x64.zip" -DestinationPath "C:\windows\Temp\ftech_temp" -Force

# Fetch browsing history for the latest 6 users
echo "[+] INFO: Fetching Latest 6 Users Chrome, Edge History"
$results = Get-ChildItem -Directory -Path "C:\Users\$_" -ErrorAction SilentlyContinue -Force | Sort LastWriteTime -Descending | Select-Object -First 6 | ForEach-Object {
    if (($_).Name -notmatch 'public|default|\$') {
        echo '-------------------------';
        echo "[+] INFO: Displaying History for HostName: $env:computername User: $_ MSEdge/Chrome  "
        echo '-------------------------';
        Start-Process -FilePath "C:\windows\Temp\ftech_temp\BrowsingHistoryView.exe" -ArgumentList "/HistorySource 4 /HistorySourceFolder `"C:\users\$_\`" /VisitTimeFilterType 3 /VisitTimeFilterValue 2 /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 /scomma `"C:\windows\Temp\ftech_temp\temp_report.csv`" /sort `"Visit Time`"" -Wait -Verbose -WindowStyle Hidden
        Import-Csv "C:\windows\Temp\ftech_temp\temp_report.csv" | Select-Object -ExpandProperty URL | Get-Unique -AsString
    }
}

# Create a CSV file with only the URL field
$results | Select-Object @{Name='URL'; Expression={$_}} | Export-Csv -Path "C:\windows\Temp\ftech_temp\report.csv" -Append -NoTypeInformation

