function Download-Installer-BITS {
    param (
        [string]$url,
        [string]$outputPath
    )

    Write-Host "Downloading Visual Studio installer from $url using BITS..."

    try {
        if (Test-Path $outputPath) {
            Remove-Item $outputPath -Force
        }

        # Create a BITS transfer job
        $job = Start-BitsTransfer -Source $url -Destination $outputPath -Description "Downloading Visual Studio Installer" -ErrorAction Stop

        # If the job object is not null, log progress
        if ($job) {
            Write-Host "BITS download job created. Monitoring progress..."

            # Wait for the download to complete
            while ($job.JobState -eq "Transferring") {
                Start-Sleep -Seconds 5
                $progress = ($job.BytesTransferred / $job.BytesTotal) * 100
                Write-Host ("Progress: {0:N2}%" -f $progress)
            }

            # Verify the download completed successfully
            if ($job.JobState -ne "Transferred") {
                Write-Error "BITS transfer failed. Job State: $($job.JobState). Exiting."
                Remove-BitsTransfer -BitsJob $job
                exit
            }

            # Complete the job
            Complete-BitsTransfer -BitsJob $job
            Write-Host "Installer downloaded successfully to $outputPath."
        } else {
            Write-Error "Failed to create BITS transfer job. Exiting."
            exit
        }
    } catch {
        Write-Error "Failed to download Visual Studio installer using BITS: $_"
        exit
    }

    # Validate file size
    $fileSize = (Get-Item $outputPath).Length
    if ($fileSize -lt 1000000) {
        Write-Error "Downloaded installer appears to be corrupted or incomplete (file size: $fileSize bytes). Exiting."
        exit
    }
    Write-Host "Installer size validated: $fileSize bytes."
}
