/*
 * test_address_mapping.v : Simple test to verify address mapping fix
 * 
 * Tests that address from SERV (bit-serial format) is correctly mapped
 * to instruction memory address range
 */

`timescale 1ns/1ps

module test_address_mapping;

// Parameters
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter ID_WIDTH   = 4;
parameter CLK_PERIOD = 10;

// Clock and Reset
reg  ACLK;
reg  ARESETN;

// Wishbone Interface (simulating SERV output)
reg  [ADDR_WIDTH-1:0]   wb_adr;
reg                     wb_cyc;
wire [DATA_WIDTH-1:0]   wb_rdt;
wire                    wb_ack;

// AXI Interface
wire [ID_WIDTH-1:0]     M_AXI_arid;
wire [ADDR_WIDTH-1:0]   M_AXI_araddr;
wire [7:0]              M_AXI_arlen;
wire [2:0]              M_AXI_arsize;
wire [1:0]              M_AXI_arburst;
wire [1:0]              M_AXI_arlock;
wire [3:0]              M_AXI_arcache;
wire [2:0]              M_AXI_arprot;
wire [3:0]              M_AXI_arqos;
wire [3:0]              M_AXI_arregion;
wire                    M_AXI_arvalid;
reg                     M_AXI_arready;

wire [ID_WIDTH-1:0]     M_AXI_rid;
reg  [DATA_WIDTH-1:0]   M_AXI_rdata;
reg  [1:0]              M_AXI_rresp;
reg                     M_AXI_rlast;
reg                     M_AXI_rvalid;
wire                    M_AXI_rready;

// Clock generation
always begin
    ACLK = 1'b0;
    #(CLK_PERIOD/2);
    ACLK = 1'b1;
    #(CLK_PERIOD/2);
end

// DUT Instance
wb2axi_read #(
    .ADDR_WIDTH  (ADDR_WIDTH),
    .DATA_WIDTH  (DATA_WIDTH),
    .ID_WIDTH    (ID_WIDTH)
) u_dut (
    .ACLK        (ACLK),
    .ARESETN     (ARESETN),
    .wb_adr      (wb_adr),
    .wb_cyc      (wb_cyc),
    .wb_rdt      (wb_rdt),
    .wb_ack      (wb_ack),
    .M_AXI_arid  (M_AXI_arid),
    .M_AXI_araddr(M_AXI_araddr),
    .M_AXI_arlen (M_AXI_arlen),
    .M_AXI_arsize(M_AXI_arsize),
    .M_AXI_arburst(M_AXI_arburst),
    .M_AXI_arlock(M_AXI_arlock),
    .M_AXI_arcache(M_AXI_arcache),
    .M_AXI_arprot(M_AXI_arprot),
    .M_AXI_arqos (M_AXI_arqos),
    .M_AXI_arregion(M_AXI_arregion),
    .M_AXI_arvalid(M_AXI_arvalid),
    .M_AXI_arready(M_AXI_arready),
    .M_AXI_rid   (M_AXI_rid),
    .M_AXI_rdata (M_AXI_rdata),
    .M_AXI_rresp (M_AXI_rresp),
    .M_AXI_rlast (M_AXI_rlast),
    .M_AXI_rvalid(M_AXI_rvalid),
    .M_AXI_rready(M_AXI_rready)
);

// Test stimulus
initial begin
    ARESETN = 1'b0;
    wb_adr = 32'h0;
    wb_cyc = 1'b0;
    M_AXI_arready = 1'b0;
    M_AXI_rdata = 32'h0;
    M_AXI_rresp = 2'b00;
    M_AXI_rlast = 1'b1;
    M_AXI_rvalid = 1'b0;
    
    #(CLK_PERIOD * 10);
    ARESETN = 1'b1;
    #(CLK_PERIOD * 5);
    
    $display("=========================================");
    $display("Testing Address Mapping");
    $display("=========================================");
    
    // Test Case 1: Normal address (0x00000000)
    $display("\nTest Case 1: wb_adr = 0x00000000");
    wb_adr = 32'h00000000;
    wb_cyc = 1'b1;
    #(CLK_PERIOD);
    wait(M_AXI_arvalid);
    $display("  Expected: M_AXI_araddr = 0x00000000");
    $display("  Got:      M_AXI_araddr = 0x%08h", M_AXI_araddr);
    if (M_AXI_araddr == 32'h00000000) begin
        $display("  [PASS]");
    end else begin
        $display("  [FAIL]");
    end
    M_AXI_arready = 1'b1;
    #(CLK_PERIOD);
    M_AXI_arready = 1'b0;
    M_AXI_rvalid = 1'b1;
    M_AXI_rdata = 32'h00500093;
    #(CLK_PERIOD);
    M_AXI_rvalid = 1'b0;
    wb_cyc = 1'b0;
    #(CLK_PERIOD * 2);
    
    // Test Case 2: Bit-serial PC format (0x20006000)
    $display("\nTest Case 2: wb_adr = 0x20006000 (bit-serial format)");
    wb_adr = 32'h20006000;
    wb_cyc = 1'b1;
    #(CLK_PERIOD);
    wait(M_AXI_arvalid);
    $display("  Expected: M_AXI_araddr = 0x00006000 (masked and word-aligned)");
    $display("  Got:      M_AXI_araddr = 0x%08h", M_AXI_araddr);
    if (M_AXI_araddr == 32'h00006000) begin
        $display("  [PASS]");
    end else begin
        $display("  [FAIL]");
    end
    M_AXI_arready = 1'b1;
    #(CLK_PERIOD);
    M_AXI_arready = 1'b0;
    M_AXI_rvalid = 1'b1;
    M_AXI_rdata = 32'h00A00113;
    #(CLK_PERIOD);
    M_AXI_rvalid = 1'b0;
    wb_cyc = 1'b0;
    #(CLK_PERIOD * 2);
    
    // Test Case 3: Address with offset (0x00000004)
    $display("\nTest Case 3: wb_adr = 0x00000004");
    wb_adr = 32'h00000004;
    wb_cyc = 1'b1;
    #(CLK_PERIOD);
    wait(M_AXI_arvalid);
    $display("  Expected: M_AXI_araddr = 0x00000004");
    $display("  Got:      M_AXI_araddr = 0x%08h", M_AXI_araddr);
    if (M_AXI_araddr == 32'h00000004) begin
        $display("  [PASS]");
    end else begin
        $display("  [FAIL]");
    end
    M_AXI_arready = 1'b1;
    #(CLK_PERIOD);
    M_AXI_arready = 1'b0;
    M_AXI_rvalid = 1'b1;
    M_AXI_rdata = 32'h002081B3;
    #(CLK_PERIOD);
    M_AXI_rvalid = 1'b0;
    wb_cyc = 1'b0;
    #(CLK_PERIOD * 2);
    
    // Test Case 4: Address outside range (0x10000000) - should be masked
    $display("\nTest Case 4: wb_adr = 0x10000000 (outside instruction memory range)");
    wb_adr = 32'h10000000;
    wb_cyc = 1'b1;
    #(CLK_PERIOD);
    wait(M_AXI_arvalid);
    $display("  Expected: M_AXI_araddr = 0x00000000 (masked to instruction memory range)");
    $display("  Got:      M_AXI_araddr = 0x%08h", M_AXI_araddr);
    if (M_AXI_araddr == 32'h00000000) begin
        $display("  [PASS]");
    end else begin
        $display("  [FAIL]");
    end
    M_AXI_arready = 1'b1;
    #(CLK_PERIOD);
    M_AXI_arready = 1'b0;
    M_AXI_rvalid = 1'b1;
    M_AXI_rdata = 32'h00000000;
    #(CLK_PERIOD);
    M_AXI_rvalid = 1'b0;
    wb_cyc = 1'b0;
    #(CLK_PERIOD * 2);
    
    $display("\n=========================================");
    $display("Address Mapping Test Complete");
    $display("=========================================");
    #(CLK_PERIOD * 10);
    $finish;
end

endmodule

