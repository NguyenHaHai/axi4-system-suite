# PowerShell Script to Create Testbench Structure
# Tạo cấu trúc testbench tương ứng với source structure

param(
    [string]$TbPath = "D:\AXI\tb\interconnect_tb"
)

Write-Host "Creating testbench structure..." -ForegroundColor Cyan

$folders = @(
    "core",                          # Top-level testbenches
    "channel_controllers\write",    # Write channel controller testbenches
    "channel_controllers\read",     # Read channel controller testbenches
    "arbitration",                   # Arbitration testbenches
    "decoders",                      # Decoder testbenches
    "datapath\mux",                  # MUX testbenches
    "datapath\demux",                # DEMUX testbenches
    "buffers",                       # Buffer/Queue testbenches
    "handshake",                     # Handshake testbenches
    "utils",                         # Utility testbenches
    "vip",                           # Verification IP
    "common"                         # Common testbench utilities
)

foreach ($folder in $folders) {
    $path = Join-Path $TbPath $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Created: $folder" -ForegroundColor Green
    }
}

Write-Host "Testbench structure created!" -ForegroundColor Green

