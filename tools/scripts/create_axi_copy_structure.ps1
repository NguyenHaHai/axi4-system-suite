# PowerShell Script to Create Complete AXI_COPY Project Structure
# Based on Complete_Folder_Structure.md
# Usage: .\create_axi_copy_structure.ps1

param(
    [string]$RootPath = "D:\AXI_COPY"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creating AXI_COPY Project Structure" -ForegroundColor Cyan
Write-Host "Based on Complete_Folder_Structure.md" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Root Path: $RootPath" -ForegroundColor Yellow
Write-Host ""

# Define all folders from Complete_Folder_Structure.md
$folders = @(
    # Documentation
    "docs\specifications",
    "docs\user_guides",
    "docs\design_notes",
    "docs\api_reference",
    "docs\changelog",
    
    # Source - AXI Interconnect
    "src\axi_interconnect\rtl\core",
    "src\axi_interconnect\rtl\channel_controllers\write",
    "src\axi_interconnect\rtl\channel_controllers\read",
    "src\axi_interconnect\rtl\arbitration",
    "src\axi_interconnect\rtl\decoders",
    "src\axi_interconnect\rtl\datapath\mux",
    "src\axi_interconnect\rtl\datapath\demux",
    "src\axi_interconnect\rtl\buffers",
    "src\axi_interconnect\rtl\handshake",
    "src\axi_interconnect\rtl\utils",
    "src\axi_interconnect\rtl\includes",
    
    # Source - AXI Stream
    "src\axi_stream\rtl\interfaces",
    "src\axi_stream\rtl\fifo",
    "src\axi_stream\rtl\register",
    "src\axi_stream\rtl\mux",
    "src\axi_stream\rtl\demux",
    "src\axi_stream\rtl\adapter",
    "src\axi_stream\rtl\switch",
    "src\axi_stream\rtl\includes",
    
    # Source - AXI Bridge
    "src\axi_bridge\rtl\axi4_to_stream",
    "src\axi_bridge\rtl\stream_to_axi4",
    "src\axi_bridge\rtl\clock_domain",
    "src\axi_bridge\rtl\width_converter",
    
    # Source - Common
    "src\common\rtl\fifo",
    "src\common\rtl\utils",
    "src\common\rtl\lint",
    
    # Source - Full System
    "src\axi_full\rtl",
    "src\axi_full\rtl\includes",
    
    # Testbenches
    "tb\interconnect_tb\vip",
    "tb\stream_tb\vip",
    "tb\bridge_tb",
    "tb\utils_tb",
    "tb\common",
    
    # Simulation
    "sim\modelsim",
    "sim\vivado",
    "sim\vcs",
    "sim\verilator",
    "sim\waveforms",
    "sim\logs",
    
    # Synthesis
    "synthesis\constraints",
    "synthesis\scripts\quartus",
    "synthesis\scripts\vivado",
    "synthesis\scripts\synplify",
    "synthesis\reports",
    "synthesis\netlists",
    
    # FPGA
    "fpga\constraints",
    "fpga\scripts",
    "fpga\bitstreams",
    "fpga\reports",
    "fpga\logs",
    
    # Verification
    "verification\uvm\test",
    "verification\uvm\env",
    "verification\uvm\seq",
    "verification\formal",
    "verification\coverage",
    
    # Software
    "software\drivers\linux",
    "software\drivers\baremetal",
    "software\applications",
    "software\scripts",
    
    # Tools
    "tools\scripts",
    "tools\lint",
    "tools\utilities",
    
    # IP and Build
    "ip\axi_interconnect_ip",
    "ip\axi_stream_ip",
    "ip\axi_bridge_ip",
    "build\obj",
    "build\work",
    "build\cache",
    
    # GitHub
    ".github\workflows"
)

$created = 0
$existing = 0
$failed = 0

foreach ($folder in $folders) {
    $path = Join-Path $RootPath $folder
    if (-not (Test-Path $path)) {
        try {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "Created: $folder" -ForegroundColor Green
            $created++
        } catch {
            Write-Host "Failed:  $folder" -ForegroundColor Red
            Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
            $failed++
        }
    } else {
        Write-Host "Exists:  $folder" -ForegroundColor Gray
        $existing++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Created:  $created folders" -ForegroundColor Green
Write-Host "Existing: $existing folders" -ForegroundColor Gray
Write-Host "Failed:   $failed folders" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host ""
Write-Host "Structure creation complete!" -ForegroundColor Cyan
Write-Host ""

# Create .gitkeep files
$gitkeepFolders = @(
    "sim\waveforms",
    "synthesis\reports",
    "synthesis\netlists",
    "fpga\bitstreams",
    "ip\axi_interconnect_ip",
    "ip\axi_stream_ip",
    "ip\axi_bridge_ip"
)

Write-Host "Creating .gitkeep files..." -ForegroundColor Yellow
foreach ($folder in $gitkeepFolders) {
    $path = Join-Path $RootPath $folder
    $gitkeep = Join-Path $path ".gitkeep"
    if (-not (Test-Path $gitkeep)) {
        New-Item -ItemType File -Path $gitkeep -Force | Out-Null
        Write-Host "  Created: $folder\.gitkeep" -ForegroundColor Green
    }
}

# Create README files
Write-Host ""
Write-Host "Creating README files..." -ForegroundColor Yellow

$readmeContent = @{
    "$RootPath" = "# AXI_COPY Project`n`nThis is a complete copy of AXI project structure."
    "$RootPath\docs" = "# Documentation`n`nProject documentation goes here."
    "$RootPath\src" = "# Source Code`n`nRTL source files organized by module type."
    "$RootPath\tb" = "# Testbenches`n`nTestbench files for verification."
    "$RootPath\sim" = "# Simulation`n`nSimulation scripts and results."
}

foreach ($readmePath in $readmeContent.Keys) {
    $readmeFile = Join-Path $readmePath "README.md"
    if (-not (Test-Path $readmeFile)) {
        $content = $readmeContent[$readmePath]
        Set-Content -Path $readmeFile -Value $content
        $relativePath = $readmePath.Replace($RootPath, "")
        if ($relativePath -eq "") { $relativePath = "\" }
        Write-Host "  Created README.md in $relativePath" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AXI_COPY Structure Created Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Copy source files from D:\AXI to appropriate folders" -ForegroundColor White
Write-Host "2. Update file paths in scripts and filelists" -ForegroundColor White
Write-Host "3. Configure ModelSim project" -ForegroundColor White
Write-Host ""
