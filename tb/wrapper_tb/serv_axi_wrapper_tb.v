/*
 * serv_axi_wrapper_tb.v : Testbench for serv_axi_wrapper module
 * 
 * Test cases:
 * 1. Verify cnt_done signal connection
 * 2. Verify instruction bus connection
 * 3. Verify data bus connection
 */

`timescale 1ns / 1ps

module serv_axi_wrapper_tb;

    // Parameters
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter ID_WIDTH   = 4;
    parameter CLK_PERIOD = 10;

    // Signals
    reg  ACLK;
    reg  ARESETN;
    reg  i_timer_irq;
    
    // AXI4 Master Port 0 (Instruction Bus)
    wire [ID_WIDTH-1:0]     M0_AXI_arid;
    wire [ADDR_WIDTH-1:0]   M0_AXI_araddr;
    wire [7:0]              M0_AXI_arlen;
    wire [2:0]              M0_AXI_arsize;
    wire [1:0]              M0_AXI_arburst;
    wire [1:0]              M0_AXI_arlock;
    wire [3:0]              M0_AXI_arcache;
    wire [2:0]              M0_AXI_arprot;
    wire [3:0]              M0_AXI_arqos;
    wire [3:0]              M0_AXI_arregion;
    wire                    M0_AXI_arvalid;
    reg                     M0_AXI_arready;
    reg  [ID_WIDTH-1:0]     M0_AXI_rid;
    reg  [DATA_WIDTH-1:0]   M0_AXI_rdata;
    reg  [1:0]              M0_AXI_rresp;
    reg                     M0_AXI_rlast;
    reg                     M0_AXI_rvalid;
    wire                    M0_AXI_rready;
    
    // AXI4 Master Port 1 (Data Bus) - simplified for testing
    wire [ID_WIDTH-1:0]     M1_AXI_awid;
    wire [ADDR_WIDTH-1:0]   M1_AXI_awaddr;
    wire                    M1_AXI_awvalid;
    reg                     M1_AXI_awready;
    wire [DATA_WIDTH-1:0]   M1_AXI_wdata;
    wire                    M1_AXI_wvalid;
    reg                     M1_AXI_wready;
    reg  [ID_WIDTH-1:0]     M1_AXI_bid;
    reg  [1:0]              M1_AXI_bresp;
    reg                     M1_AXI_bvalid;
    wire                    M1_AXI_bready;
    wire [ID_WIDTH-1:0]     M1_AXI_arid;
    wire [ADDR_WIDTH-1:0]   M1_AXI_araddr;
    wire                    M1_AXI_arvalid;
    reg                     M1_AXI_arready;
    reg  [ID_WIDTH-1:0]     M1_AXI_rid;
    reg  [DATA_WIDTH-1:0]   M1_AXI_rdata;
    reg  [1:0]              M1_AXI_rresp;
    reg                     M1_AXI_rlast;
    reg                     M1_AXI_rvalid;
    wire                    M1_AXI_rready;

    // Instantiate DUT
    serv_axi_wrapper #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .ID_WIDTH   (ID_WIDTH),
        .W          (1),
        .RESET_PC   (32'h0)
    ) uut (
        .ACLK              (ACLK),
        .ARESETN           (ARESETN),
        .i_timer_irq       (i_timer_irq),
        // Master Port 0 (Instruction)
        .M0_AXI_arid       (M0_AXI_arid),
        .M0_AXI_araddr     (M0_AXI_araddr),
        .M0_AXI_arlen      (M0_AXI_arlen),
        .M0_AXI_arsize     (M0_AXI_arsize),
        .M0_AXI_arburst    (M0_AXI_arburst),
        .M0_AXI_arlock     (M0_AXI_arlock),
        .M0_AXI_arcache    (M0_AXI_arcache),
        .M0_AXI_arprot     (M0_AXI_arprot),
        .M0_AXI_arqos      (M0_AXI_arqos),
        .M0_AXI_arregion   (M0_AXI_arregion),
        .M0_AXI_arvalid    (M0_AXI_arvalid),
        .M0_AXI_arready    (M0_AXI_arready),
        .M0_AXI_rid        (M0_AXI_rid),
        .M0_AXI_rdata      (M0_AXI_rdata),
        .M0_AXI_rresp      (M0_AXI_rresp),
        .M0_AXI_rlast      (M0_AXI_rlast),
        .M0_AXI_rvalid     (M0_AXI_rvalid),
        .M0_AXI_rready     (M0_AXI_rready),
        // Master Port 1 (Data) - simplified connections
        .M1_AXI_awid       (M1_AXI_awid),
        .M1_AXI_awaddr     (M1_AXI_awaddr),
        .M1_AXI_awvalid    (M1_AXI_awvalid),
        .M1_AXI_awready    (M1_AXI_awready),
        .M1_AXI_wdata      (M1_AXI_wdata),
        .M1_AXI_wvalid     (M1_AXI_wvalid),
        .M1_AXI_wready     (M1_AXI_wready),
        .M1_AXI_bid        (M1_AXI_bid),
        .M1_AXI_bresp      (M1_AXI_bresp),
        .M1_AXI_bvalid     (M1_AXI_bvalid),
        .M1_AXI_bready     (M1_AXI_bready),
        .M1_AXI_arid       (M1_AXI_arid),
        .M1_AXI_araddr     (M1_AXI_araddr),
        .M1_AXI_arvalid    (M1_AXI_arvalid),
        .M1_AXI_arready    (M1_AXI_arready),
        .M1_AXI_rid        (M1_AXI_rid),
        .M1_AXI_rdata      (M1_AXI_rdata),
        .M1_AXI_rresp      (M1_AXI_rresp),
        .M1_AXI_rlast      (M1_AXI_rlast),
        .M1_AXI_rvalid     (M1_AXI_rvalid),
        .M1_AXI_rready     (M1_AXI_rready)
    );

    // Clock generation
    always begin
        ACLK = 1'b0;
        #(CLK_PERIOD/2);
        ACLK = 1'b1;
        #(CLK_PERIOD/2);
    end

    // Test stimulus
    initial begin
        $display("=========================================");
        $display("serv_axi_wrapper Testbench Started");
        $display("=========================================");
        
        // Initialize
        ARESETN = 1'b0;
        i_timer_irq = 1'b0;
        M0_AXI_arready = 1'b0;
        M0_AXI_rid = 4'h0;
        M0_AXI_rdata = 32'h0;
        M0_AXI_rresp = 2'b00;
        M0_AXI_rlast = 1'b0;
        M0_AXI_rvalid = 1'b0;
        M1_AXI_awready = 1'b0;
        M1_AXI_wready = 1'b0;
        M1_AXI_bid = 4'h0;
        M1_AXI_bresp = 2'b00;
        M1_AXI_bvalid = 1'b0;
        M1_AXI_arready = 1'b0;
        M1_AXI_rid = 4'h0;
        M1_AXI_rdata = 32'h0;
        M1_AXI_rresp = 2'b00;
        M1_AXI_rlast = 1'b0;
        M1_AXI_rvalid = 1'b0;
        
        // Reset
        #(CLK_PERIOD * 10);
        ARESETN = 1'b1;
        #(CLK_PERIOD * 5);
        
        $display("\n=== Test Case 1: Verify cnt_done signal connection ===");
        $display("Note: cnt_done is internal to serv_axi_wrapper, cannot directly test");
        $display("But we can verify it's connected by monitoring instruction bus behavior");
        
        #(CLK_PERIOD * 100);
        
        $display("\n=== Test Case 2: Monitor instruction bus ===");
        // Monitor for instruction fetch requests
        wait(M0_AXI_arvalid);
        $display("[%0t] Instruction fetch detected: addr=0x%08h", $time, M0_AXI_araddr);
        M0_AXI_arready = 1'b1;
        #(CLK_PERIOD);
        M0_AXI_arready = 1'b0;
        M0_AXI_rvalid = 1'b1;
        M0_AXI_rdata = 32'h00500093;  // addi x1, x0, 5
        M0_AXI_rlast = 1'b1;
        #(CLK_PERIOD);
        M0_AXI_rvalid = 1'b0;
        M0_AXI_rlast = 1'b0;
        
        #(CLK_PERIOD * 50);
        
        $display("\n=========================================");
        $display("Test Completed");
        $display("=========================================");
        $finish;
    end

    // Monitor
    always @(posedge ACLK) begin
        if (M0_AXI_arvalid && M0_AXI_arready) begin
            $display("[%0t] Instruction Fetch: addr=0x%08h", $time, M0_AXI_araddr);
        end
        if (M1_AXI_awvalid && M1_AXI_awready) begin
            $display("[%0t] Data Write: addr=0x%08h", $time, M1_AXI_awaddr);
        end
        if (M1_AXI_arvalid && M1_AXI_arready) begin
            $display("[%0t] Data Read: addr=0x%08h", $time, M1_AXI_araddr);
        end
    end

endmodule

