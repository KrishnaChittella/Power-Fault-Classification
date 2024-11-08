# Set the path to your folder
$folderPath = "G:\My Drive\insplad\defect_supervised\yoke-suspension\val\good"

# Get all files in the folder (non-recursive)
$allFiles = Get-ChildItem -Path $folderPath -File

# Calculate how many files to delete
$totalFiles = $allFiles.Count
$filesToKeep = 250
$filesToDelete = $totalFiles - $filesToKeep

# Check if we need to delete any files
if ($filesToDelete -le 0) {
    Write-Host "Folder contains $totalFiles files, which is less than or equal to the target of $filesToKeep files. No deletion needed."
    exit
}

# Randomly select files to delete
$filesToRemove = $allFiles | Get-Random -Count $filesToDelete

# Create a timestamp for the log file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $folderPath "deletion_log_$timestamp.txt"

# Log header
"File Deletion Log - $timestamp" | Out-File $logFile
"Total files before: $totalFiles" | Out-File $logFile -Append
"Files to keep: $filesToKeep" | Out-File $logFile -Append
"Files to delete: $filesToDelete" | Out-File $logFile -Append
"" | Out-File $logFile -Append
"Deleted files:" | Out-File $logFile -Append

# Delete files and log each deletion
foreach ($file in $filesToRemove) {
    try {
        Remove-Item $file.FullName -Force
        $file.Name | Out-File $logFile -Append
    }
    catch {
        "ERROR deleting $($file.Name): $($_.Exception.Message)" | Out-File $logFile -Append
    }
}

# Final count verification
$remainingFiles = (Get-ChildItem -Path $folderPath -File).Count
"" | Out-File $logFile -Append
"Remaining files: $remainingFiles" | Out-File $logFile -Append

Write-Host "Operation completed. $filesToDelete files have been deleted."
Write-Host "Log file created at: $logFile"
