# Check if azurite.exe is already running
$azuriteProcess = Get-Process azurite -ErrorAction SilentlyContinue
if ($azuriteProcess) {
    Write-Error "Azurite is already running. Exiting script."
    exit 1 # Exit with an error code
}

# Define placeholders for Program Files directory
$programFiles = ${env:ProgramFiles} # Use environment variable for Program Files

# Define possible Azurite installation paths for different Visual Studio editions
$azuritePaths = @(
    "$programFiles\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe",
    "$programFiles\Microsoft Visual Studio\2022\Professional\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe",
    "$programFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe"
)

# Iterate through the paths to find and run Azurite
foreach ($path in $azuritePaths) {
    if (Test-Path $path) {
        Write-Host "Found Azurite at: $path"
        
        # Get the current working directory
        $workingDir = Get-Location
        
        # Run Azurite with the specified parameters
        & $path --location "$workingDir\data" "$workingDir\debug.log" --skipApiVersionCheck
        
        # Exit the loop after successfully starting Azurite
        Write-Host "Azurite started successfully. Exiting script."
        break
    } else {
        Write-Host "Azurite not found at: $path"
    }
}

# If Azurite was not found in any of the paths, produce an error
if (-not (Get-Process azurite -ErrorAction SilentlyContinue)) {
    Write-Error "Azurite could not be found in any of the expected locations. Exiting script."
    exit 1 # Exit with an error code
}
