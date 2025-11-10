# ============================================================================
# PowerShell Script to Generate .qsf Entries from filelist.f
# Usage: .\generate_qsf_from_filelist.ps1
#
# This script reads ModelSim filelist.f and generates Quartus .qsf entries
# ============================================================================

$filelistPath = "..\modelsim\filelist.f"
$outputPath = "qsf_entries.txt"

if (-not (Test-Path $filelistPath)) {
    Write-Host "Error: Filelist not found at $filelistPath" -ForegroundColor Red
    exit 1
}

Write-Host "Reading filelist: $filelistPath" -ForegroundColor Green

$qsfEntries = @()
$qsfEntries += "# Generated from filelist.f"
$qsfEntries += "# Auto-generated - Do not edit manually"
$qsfEntries += ""

Get-Content $filelistPath | ForEach-Object {
    $line = $_.Trim()
    
    # Skip comments and empty lines
    if ($line -match "^#" -or $line -eq "") {
        return
    }
    
    # Match Verilog files
    if ($line -match "^\.\./src.*\.v$") {
        # Convert path from ModelSim format to Quartus format
        $quartusPath = $line -replace "^\.\./", "../../../"
        $qsfEntries += "set_global_assignment -name VERILOG_FILE $quartusPath"
    }
}

# Write to output file
$qsfEntries | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "`nGenerated $($qsfEntries.Count - 3) file entries" -ForegroundColor Green
Write-Host "Output saved to: $outputPath" -ForegroundColor Green
Write-Host "`nYou can copy these entries to AXI_PROJECT.qsf" -ForegroundColor Yellow

