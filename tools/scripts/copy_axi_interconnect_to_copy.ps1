# PowerShell Script to Copy AXI_Interconnect Files from AXI to AXI_COPY
# Based on Migration_Guide.md mapping
# Usage: .\copy_axi_interconnect_to_copy.ps1

param(
    [string]$SourcePath = "D:\AXI",
    [string]$DestPath = "D:\AXI_COPY"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Copying AXI_Interconnect Files" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Source: $SourcePath" -ForegroundColor Yellow
Write-Host "Destination: $DestPath" -ForegroundColor Yellow
Write-Host ""

$copied = 0
$skipped = 0
$failed = 0

# Define file mappings: Source -> Destination
$fileMappings = @(
    # Core Modules
    @("AXI_Interconnect_Full.v", "$DestPath\src\axi_interconnect\rtl\core\AXI_Interconnect_Full.v"),
    @("AXI_Interconnect.v", "$DestPath\src\axi_interconnect\rtl\core\AXI_Interconnect.v"),
    
    # Channel Controllers - Write
    @("AW_Channel_Controller_Top.v", "$DestPath\src\axi_interconnect\rtl\channel_controllers\write\AW_Channel_Controller_Top.v"),
    @("WD_Channel_Controller_Top.v", "$DestPath\src\axi_interconnect\rtl\channel_controllers\write\WD_Channel_Controller_Top.v"),
    @("BR_Channel_Controller_Top.v", "$DestPath\src\axi_interconnect\rtl\channel_controllers\write\BR_Channel_Controller_Top.v"),
    
    # Channel Controllers - Read
    @("Controller.v", "$DestPath\src\axi_interconnect\rtl\channel_controllers\read\Controller.v"),
    
    # Arbitration
    @("Qos_Arbiter.v", "$DestPath\src\axi_interconnect\rtl\arbitration\Qos_Arbiter.v"),
    @("Write_Arbiter.v", "$DestPath\src\axi_interconnect\rtl\arbitration\Write_Arbiter.v"),
    @("Write_Arbiter_RR.v", "$DestPath\src\axi_interconnect\rtl\arbitration\Write_Arbiter_RR.v"),
    
    # Decoders
    @("Write_Addr_Channel_Dec.v", "$DestPath\src\axi_interconnect\rtl\decoders\Write_Addr_Channel_Dec.v"),
    @("Write_Resp_Channel_Dec.v", "$DestPath\src\axi_interconnect\rtl\decoders\Write_Resp_Channel_Dec.v"),
    @("Write_Resp_Channel_Arb.v", "$DestPath\src\axi_interconnect\rtl\decoders\Write_Resp_Channel_Arb.v"),
    
    # Datapath - MUX
    @("AW_MUX_2_1.v", "$DestPath\src\axi_interconnect\rtl\datapath\mux\AW_MUX_2_1.v"),
    @("WD_MUX_2_1.v", "$DestPath\src\axi_interconnect\rtl\datapath\mux\WD_MUX_2_1.v"),
    @("Mux_2x1.v", "$DestPath\src\axi_interconnect\rtl\datapath\mux\Mux_2x1.v"),
    @("Mux_2x1_en.v", "$DestPath\src\axi_interconnect\rtl\datapath\mux\Mux_2x1_en.v"),
    @("BReady_MUX_2_1.v", "$DestPath\src\axi_interconnect\rtl\datapath\mux\BReady_MUX_2_1.v"),
    
    # Datapath - DEMUX
    @("Demux_1_2.v", "$DestPath\src\axi_interconnect\rtl\datapath\demux\Demux_1_2.v"),
    @("Demux_1x2.v", "$DestPath\src\axi_interconnect\rtl\datapath\demux\Demux_1x2.v"),
    @("Demux_1x2_en.v", "$DestPath\src\axi_interconnect\rtl\datapath\demux\Demux_1x2_en.v"),
    
    # Buffers
    @("Queue.v", "$DestPath\src\axi_interconnect\rtl\buffers\Queue.v"),
    @("Resp_Queue.v", "$DestPath\src\axi_interconnect\rtl\buffers\Resp_Queue.v"),
    
    # Handshake
    @("AW_HandShake_Checker.v", "$DestPath\src\axi_interconnect\rtl\handshake\AW_HandShake_Checker.v"),
    @("WD_HandShake.v", "$DestPath\src\axi_interconnect\rtl\handshake\WD_HandShake.v"),
    @("WR_HandShake.v", "$DestPath\src\axi_interconnect\rtl\handshake\WR_HandShake.v"),
    
    # Utils
    @("Raising_Edge_Det.v", "$DestPath\src\axi_interconnect\rtl\utils\Raising_Edge_Det.v"),
    @("Faling_Edge_Detc.v", "$DestPath\src\axi_interconnect\rtl\utils\Faling_Edge_Detc.v"),
    
    # Testbenches - Interconnect
    @("tb\interconnect_tb\AXI_Interconnect_tb.v", "$DestPath\tb\interconnect_tb\AXI_Interconnect_tb.v"),
    @("AXI_Interconnect_tb.v", "$DestPath\tb\interconnect_tb\AXI_Interconnect_tb.v"),
    @("Qos_Arbiter_tb.v", "$DestPath\tb\interconnect_tb\Qos_Arbiter_tb.v"),
    @("Write_Arbiter_tb.v", "$DestPath\tb\interconnect_tb\Write_Arbiter_tb.v"),
    @("Write_Arbiter_RR_tb.v", "$DestPath\tb\interconnect_tb\Write_Arbiter_RR_tb.v"),
    @("test_case1.v", "$DestPath\tb\interconnect_tb\test_case1.v"),
    @("test_case2.v", "$DestPath\tb\interconnect_tb\test_case2.v"),
    @("test_case3.v", "$DestPath\tb\interconnect_tb\test_case3.v"),
    @("test_case4.v", "$DestPath\tb\interconnect_tb\test_case4.v"),
    @("test_case5.v", "$DestPath\tb\interconnect_tb\test_case5.v"),
    
    # Testbenches - Utils
    @("Faling_Edge_Detc_tb.v", "$DestPath\tb\utils_tb\Faling_Edge_Detc_tb.v"),
    @("Raising_Edge_Det_tb.v", "$DestPath\tb\utils_tb\Raising_Edge_Det_tb.v")
)

# Also copy files from tb/utils_tb folder
$tbUtilsSource = Join-Path $SourcePath "tb\utils_tb"
if (Test-Path $tbUtilsSource) {
    $tbUtilsFiles = Get-ChildItem -Path $tbUtilsSource -Filter "*.v" -File
    foreach ($file in $tbUtilsFiles) {
        $destFile = Join-Path "$DestPath\tb\utils_tb" $file.Name
        $fileMappings += @($file.FullName, $destFile)
    }
}

# Copy files
foreach ($mapping in $fileMappings) {
    $sourceFile = $mapping[0]
    $destFile = $mapping[1]
    
    # Handle relative paths
    if (-not [System.IO.Path]::IsPathRooted($sourceFile)) {
        $sourceFile = Join-Path $SourcePath $sourceFile
    }
    
    try {
        if (Test-Path $sourceFile) {
            $destDir = Split-Path $destFile -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            Copy-Item -Path $sourceFile -Destination $destFile -Force
            Write-Host "Copied: $(Split-Path $sourceFile -Leaf)" -ForegroundColor Green
            $copied++
        } else {
            Write-Host "Skipped (not found): $sourceFile" -ForegroundColor Yellow
            $skipped++
        }
    } catch {
        Write-Host "Failed: $sourceFile" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

# Copy documentation
$docFiles = @(
    @("Readme_AXI_Interconnect", "$DestPath\docs\specifications\Readme_AXI_Interconnect")
)

foreach ($doc in $docFiles) {
    $sourceDoc = Join-Path $SourcePath $doc[0]
    $destDoc = $doc[1]
    
    try {
        if (Test-Path $sourceDoc) {
            $destDir = Split-Path $destDoc -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            Copy-Item -Path $sourceDoc -Destination $destDoc -Force
            Write-Host "Copied doc: $(Split-Path $sourceDoc -Leaf)" -ForegroundColor Green
            $copied++
        }
    } catch {
        Write-Host "Failed doc: $sourceDoc" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Copied:  $copied files" -ForegroundColor Green
Write-Host "Skipped: $skipped files" -ForegroundColor Yellow
Write-Host "Failed:  $failed files" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host ""
Write-Host "Copy operation complete!" -ForegroundColor Cyan
Write-Host ""

