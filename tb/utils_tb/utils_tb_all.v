`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: Utils Testbench Suite
// Module Name: utils_tb_all
// Project Name: AXI Interconnect
// Target Devices: 
// Tool Versions: 
// Description: Top-level testbench that runs all utils testbenches
// 
// Dependencies: All utils modules and their testbenches
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module utils_tb_all;
    
    // This testbench instantiates all utils testbenches
    // Run each testbench sequentially
    
    initial begin
        $display("==========================================");
        $display("UTILS TESTBENCH SUITE");
        $display("==========================================");
        $display("\nStarting all utility module testbenches...\n");
    end
    
    // Note: In a real simulation, you would run each testbench separately
    // or use a scripting tool to run them sequentially.
    // This module serves as documentation for which testbenches exist.
    
    // Available Testbenches:
    // 1. Raising_Edge_Det_tb.v
    // 2. Faling_Edge_Detc_tb.v
    // 3. Mux_2x1_tb.v
    // 4. Demux_1_2_tb.v
    // 5. Demux_1x2_tb.v
    // 6. Mux_2x1_en_tb.v
    // 7. Demux_1x2_en_tb.v
    // 8. BReady_MUX_2_1_tb.v
    
    initial begin
        $display("To run individual testbenches:");
        $display("  vsim Raising_Edge_Det_tb");
        $display("  vsim Faling_Edge_Detc_tb");
        $display("  vsim Mux_2x1_tb");
        $display("  vsim Demux_1_2_tb");
        $display("  vsim Demux_1x2_tb");
        $display("  vsim Mux_2x1_en_tb");
        $display("  vsim Demux_1x2_en_tb");
        $display("  vsim BReady_MUX_2_1_tb");
        $display("\nOr use a script to run all testbenches automatically.");
        
        #10;
        $finish;
    end

endmodule

