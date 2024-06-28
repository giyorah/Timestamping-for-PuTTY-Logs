# Configuration options
$timestampFormat = "yyyy-MM-dd HH:mm:ss" # Modify the format of the timestamps
$checkInterval   = 1                     # Adjust the interval (in seconds) between log file checks

Write-Host "`n--------- Welcome! ---------`n(Press Ctrl+C twice to exit)`n" `
-ForegroundColor Cyan

Write-Host "`n --> Important note!" -ForegroundColor Yellow
Write-Host "     Please ensure that the working directory you provide contains a"
Write-Host "     shortcut (.lnk) to a PuTTY's stored session, which MUST be set to log"
Write-Host "     the session to a file named 'log.txt' in the same directory."
Write-Host "" # Empty line for separation
Write-Host " --> The timestamped log file (ts_log.txt) will be created in this directory.`n" -ForegroundColor White


# Prompt for the working directory
while ($true) {
    $workingDirectory = Read-Host -Prompt 'Enter the working directory (e.g., C:\Users\user\Desktop)'

    # Check if the user entered anything
    if (-not [string]::IsNullOrEmpty($workingDirectory)) {
        if (Test-Path $workingDirectory) {
            break  # Exit the loop if the directory is valid
        } else {
            Write-Host "Error: The specified directory does not exist. Please try again.`n" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Error: You must enter a directory. Please try again.`n" -ForegroundColor Red
    }
}

# Construct the log file paths based on the working directory
$originalLogPath = Join-Path $workingDirectory 'log.txt'
$timestampedLogPath = Join-Path $workingDirectory 'ts_log.txt'

# Prompt for the program name (without extension)
while ($true) {
    $programName = Read-Host -Prompt "Enter the name of the shortcut to PuTTY's stored session"
    $programPath = Join-Path $workingDirectory ($programName + '.lnk') # Add .lnk extension

    if (Test-Path $programPath) {
        break  # Exit the loop if the program shortcut is found
    } else {
        Write-Host "Error: The specified shortcut (.lnk) does not exist in the working directory. Try again." -ForegroundColor Red
    }
}
# Now we have $originalLogPath, $timestampedLogPath, and $programPath

# Check for existing PuTTY processes and terminate them if found
$existingProcess = Get-Process -Name 'putty' -ErrorAction SilentlyContinue
if ($existingProcess) {
    Write-Host "Existing PuTTY process(es) found. Terminating..." -ForegroundColor Red
    $existingProcess | ForEach-Object { $_.Kill() }
    Start-Sleep -Seconds 2  # Wait for the process to fully terminate
    Write-Host "Existing process(es) terminated.`n" -ForegroundColor Red
    Start-Sleep -Seconds 1
}

# Clear the existing ts_log.txt file if it exists
if (Test-Path $timestampedLogPath) {
    Clear-Content $timestampedLogPath
}

# Function to add timestamp to a line
function Add-Timestamp($line) {
    $timestamp = Get-Date -Format $timestampFormat
    return "$timestamp    $line"
}

# Start the process and capture its handle
$process = Start-Process $programPath -WindowStyle Hidden -PassThru

# Wait a few seconds for the process to start
Start-Sleep -Seconds 2

try {
    $reader = [System.IO.File]::Open($originalLogPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
    $streamReader = New-Object System.IO.StreamReader($reader)

    while ($true) {
        $line = $streamReader.ReadLine()
        
        if ($line -ne $null) {
            $timestampedLine = Add-Timestamp $line
            
            # Write to the log file
            Add-Content -Path $timestampedLogPath -Value $timestampedLine
            
            # Print to the terminal
            Write-Host $timestampedLine
        } else {
            Start-Sleep $checkInterval
        }
    }
}
finally {
    # Clean up resources
    if ($streamReader) { $streamReader.Dispose() }
    if ($reader) { $reader.Dispose() }
    
    # Terminate the process
    if ($process -and -not $process.HasExited) {
        $process.Kill()
        Write-Host "PuTTY process terminated." -ForegroundColor Yellow
    }
}