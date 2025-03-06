#used artifactory to check for latest version and downloaded it using s3 bucket link
# Get user input for version
$versionInput = Read-Host "Enter the version (e.g., 2026.0.0)"
$version = "v$versionInput"

# Define the Artifactory URL based on the version
$artifactoryUrl = "https://artifactory.soti.net/artifactory/MobiControl/$version/"

# Get the directory listing from Artifactory
$response = Invoke-WebRequest -Uri $artifactoryUrl -UseBasicParsing

# Extract build numbers using regex (assuming build numbers are numerical)
$buildNumbers = $response.Links | Where-Object { $_.href -match '^\d+/$' } | ForEach-Object { $_.href -replace '/$','' }

# Convert to integers and find the latest build
$latestBuild = ($buildNumbers | Sort-Object {[int]$_} -Descending | Select-Object -First 1)

# Check if a build was found
if (-not $latestBuild) {
    Write-Output "No builds found for version $version. Please check the version or Artifactory URL."
    exit 1
}
Write-Output "Latest Build Number: $latestBuild"

# Construct the base URL for downloading
$versionWithoutVandDots = $versionInput -replace '\.', ''

# Start checking from the latest build and decrement if necessary
$buildToCheck = [int]$latestBuild


$downloadUrl = "https://soti-artifactory-mirror-bucket.s3.ap-south-1.amazonaws.com/MobiControl/$version/$buildToCheck/MobiControl${versionWithoutVandDots}Setup_${buildToCheck}_release.exe"

Write-Output "Downloading..."
$outputFile = "MobiControlSetup_${buildToCheck}.exe"
& "C:\Windows\System32\curl.exe" -o $outputFile $downloadUrl
Write-Output "Download completed: $outputFile"

