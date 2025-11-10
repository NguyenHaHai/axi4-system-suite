/*
 * wb2axi_read_tb.v : Testbench for wb2axi_read module
 * 
 * Test cases:
 * 1. Basic read transaction without cnt_done
 * 2. Read transaction with cnt_done signal
 * 3. Address capture timing with cnt_done
 * 4. Multiple transactions
 * 5. Address pattern verification
 */

`timescale 1ns / 1ps

module wb2axi_read_tb;

    // Parameters
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter ID_WIDTH   = 4;
    parameter CLK_PERIOD = 10;

    // Signals
    reg  ACLK;
    reg  ARESETN;
    
    // Wishbone Interface
    reg  [ADDR_WIDTH-1:0] wb_adr;
    reg                   wb_cyc;
    wire [DATA_WIDTH-1:0] wb_rdt;
    wire                  wb_ack;
    
    // Counter done signal
    reg                   i_cnt_done;
    
    // AXI4 Read Address Channel
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
    
    // AXI4 Read Data Channel
    reg  [ID_WIDTH-1:0]     M_AXI_rid;
    reg  [DATA_WIDTH-1:0]   M_AXI_rdata;
    reg  [1:0]              M_AXI_rresp;
    reg                     M_AXI_rlast;
    reg                     M_AXI_rvalid;
    wire                    M_AXI_rready;

    // Instantiate DUT
    wb2axi_read #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .ID_WIDTH   (ID_WIDTH)
    ) uut (
        .ACLK              (ACLK),
        .ARESETN           (ARESETN),
        .wb_adr            (wb_adr),
        .wb_cyc            (wb_cyc),
        .i_cnt_done        (i_cnt_done),
        .wb_rdt            (wb_rdt),
        .wb_ack            (wb_ack),
        .M_AXI_arid        (M_AXI_arid),
        .M_AXI_araddr      (M_AXI_araddr),
        .M_AXI_arlen       (M_AXI_arlen),
        .M_AXI_arsize      (M_AXI_arsize),
        .M_AXI_arburst     (M_AXI_arburst),
        .M_AXI_arlock      (M_AXI_arlock),
        .M_AXI_arcache     (M_AXI_arcache),
        .M_AXI_arprot      (M_AXI_arprot),
        .M_AXI_arqos       (M_AXI_arqos),
        .M_AXI_arregion    (M_AXI_arregion),
        .M_AXI_arvalid     (M_AXI_arvalid),
        .M_AXI_arready     (M_AXI_arready),
        .M_AXI_rid         (M_AXI_rid),
        .M_AXI_rdata       (M_AXI_rdata),
        .M_AXI_rresp       (M_AXI_rresp),
        .M_AXI_rlast       (M_AXI_rlast),
        .M_AXI_rvalid      (M_AXI_rvalid),
        .M_AXI_rready      (M_AXI_rready)
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
        $display("wb2axi_read Testbench Started");
        $display("=========================================");
        
        // Initialize
        ARESETN = 1'b0;
        wb_adr = 32'h0;
        wb_cyc = 1'b0;
        i_cnt_done = 1'b0;
        M_AXI_arready = 1'b0;
        M_AXI_rid = 4'h0;
        M_AXI_rdata = 32'h0;
        M_AXI_rresp = 2'b00;
        M_AXI_rlast = 1'b0;
        M_AXI_rvalid = 1'b0;
        
        // Reset
        #(CLK_PERIOD * 5);
        ARESETN = 1'b1;
        #(CLK_PERIOD * 2);
        
        // Test Case 1: Basic transaction without cnt_done (should not capture address)
        $display("\n=== Test Case 1: Transaction without cnt_done ===");
        test_case_1();
        
        #(CLK_PERIOD * 10);
        
        // Test Case 2: Transaction with cnt_done (should capture address)
        $display("\n=== Test Case 2: Transaction with cnt_done ===");
        test_case_2();
        
        #(CLK_PERIOD * 10);
        
        // Test Case 3: Address capture timing - cnt_done comes after wb_cyc
        $display("\n=== Test Case 3: cnt_done comes after wb_cyc ===");
        test_case_3();
        
        #(CLK_PERIOD * 10);
        
        // Test Case 4: Multiple transactions
        $display("\n=== Test Case 4: Multiple transactions ===");
        test_case_4();
        
        #(CLK_PERIOD * 10);
        
        // Test Case 5: Address pattern verification
        $display("\n=== Test Case 5: Address pattern verification ===");
        test_case_5();
        
        #(CLK_PERIOD * 10);
        
        $display("\n=========================================");
        $display("All Tests Completed");
        $display("=========================================");
        $finish;
    end

    // Test Case 1: Basic transaction without cnt_done
    task test_case_1;
        begin
            $display("Test Case 1: wb_cyc=1, cnt_done=0 - Address should NOT be captured");
            wb_adr = 32'h00000000;
            wb_cyc = 1'b1;
            i_cnt_done = 1'b0;
            M_AXI_arready = 1'b0;
            
            #(CLK_PERIOD * 5);
            
            if (M_AXI_arvalid == 1'b0) begin
                $display("  [PASS] M_AXI_arvalid = 0 (address not captured)");
            end else begin
                $display("  [FAIL] M_AXI_arvalid = 1 (address captured without cnt_done)");
            end
            
            wb_cyc = 1'b0;
            #(CLK_PERIOD * 2);
        end
    endtask

    // Test Case 2: Transaction with cnt_done
    task test_case_2;
        begin
            $display("Test Case 2: wb_cyc=1, cnt_done=1 - Address should be captured");
            wb_adr = 32'h00000004;
            wb_cyc = 1'b1;
            i_cnt_done = 1'b1;
            M_AXI_arready = 1'b0;
            
            #(CLK_PERIOD);
            
            if (M_AXI_arvalid == 1'b1 && M_AXI_araddr == 32'h00000004) begin
                $display("  [PASS] Address captured: M_AXI_araddr = 0x%08h", M_AXI_araddr);
            end else begin
                $display("  [FAIL] Address not captured correctly: M_AXI_arvalid = %0d, M_AXI_araddr = 0x%08h", 
                         M_AXI_arvalid, M_AXI_araddr);
            end
            
            // Complete transaction
            M_AXI_arready = 1'b1;
            #(CLK_PERIOD);
            M_AXI_arready = 1'b0;
            M_AXI_rvalid = 1'b1;
            M_AXI_rdata = 32'h12345678;
            M_AXI_rlast = 1'b1;
            #(CLK_PERIOD);
            M_AXI_rvalid = 1'b0;
            M_AXI_rlast = 1'b0;
            
            wait(wb_ack);
            #(CLK_PERIOD);
            wb_cyc = 1'b0;
            i_cnt_done = 1'b0;
            #(CLK_PERIOD * 2);
        end
    endtask

    // Test Case 3: cnt_done comes after wb_cyc
    task test_case_3;
        begin
            $display("Test Case 3: wb_cyc asserted first, then cnt_done - Address should be captured when cnt_done=1");
            wb_adr = 32'h00000008;
            wb_cyc = 1'b1;
            i_cnt_done = 1'b0;
            M_AXI_arready = 1'b0;
            
            #(CLK_PERIOD * 5);
            
            if (M_AXI_arvalid == 1'b0) begin
                $display("  [PASS] Address not captured yet (cnt_done=0)");
            end else begin
                $display("  [FAIL] Address captured too early");
            end
            
            // Now assert cnt_done
            i_cnt_done = 1'b1;
            #(CLK_PERIOD);
            
            if (M_AXI_arvalid == 1'b1 && M_AXI_araddr == 32'h00000008) begin
                $display("  [PASS] Address captured when cnt_done=1: M_AXI_araddr = 0x%08h", M_AXI_araddr);
            end else begin
                $display("  [FAIL] Address not captured: M_AXI_arvalid = %0d, M_AXI_araddr = 0x%08h", 
                         M_AXI_arvalid, M_AXI_araddr);
            end
            
            // Complete transaction
            M_AXI_arready = 1'b1;
            #(CLK_PERIOD);
            M_AXI_arready = 1'b0;
            M_AXI_rvalid = 1'b1;
            M_AXI_rdata = 32'hABCDEF00;
            M_AXI_rlast = 1'b1;
            #(CLK_PERIOD);
            M_AXI_rvalid = 1'b0;
            M_AXI_rlast = 1'b0;
            
            wait(wb_ack);
            #(CLK_PERIOD);
            wb_cyc = 1'b0;
            i_cnt_done = 1'b0;
            #(CLK_PERIOD * 2);
        end
    endtask

    // Test Case 4: Multiple transactions
    task test_case_4;
        integer i;
        begin
            $display("Test Case 4: Multiple transactions with different addresses");
            for (i = 0; i < 5; i = i + 1) begin
                wb_adr = 32'h00000000 + (i * 4);
                wb_cyc = 1'b1;
                i_cnt_done = 1'b1;
                M_AXI_arready = 1'b0;
                
                #(CLK_PERIOD);
                
                if (M_AXI_arvalid == 1'b1 && M_AXI_araddr == (32'h00000000 + (i * 4))) begin
                    $display("  [PASS] Transaction %0d: Address = 0x%08h", i, M_AXI_araddr);
                end else begin
                    $display("  [FAIL] Transaction %0d: Expected 0x%08h, Got 0x%08h", 
                             i, (32'h00000000 + (i * 4)), M_AXI_araddr);
                end
                
                // Complete transaction
                M_AXI_arready = 1'b1;
                #(CLK_PERIOD);
                M_AXI_arready = 1'b0;
                M_AXI_rvalid = 1'b1;
                M_AXI_rdata = 32'h00000000 + i;
                M_AXI_rlast = 1'b1;
                #(CLK_PERIOD);
                M_AXI_rvalid = 1'b0;
                M_AXI_rlast = 1'b0;
                
                wait(wb_ack);
                #(CLK_PERIOD);
                wb_cyc = 1'b0;
                i_cnt_done = 1'b0;
                #(CLK_PERIOD * 2);
            end
        end
    endtask

    // Test Case 5: Address pattern verification
    task test_case_5;
        begin
            $display("Test Case 5: Verify address pattern (0x0, 0x4, 0x8, 0xc...)");
            wb_cyc = 1'b1;
            i_cnt_done = 1'b1;
            M_AXI_arready = 1'b0;
            
            // Test address 0x00000000
            wb_adr = 32'h00000000;
            #(CLK_PERIOD);
            if (M_AXI_araddr == 32'h00000000) begin
                $display("  [PASS] Address 0x00000000: M_AXI_araddr = 0x%08h", M_AXI_araddr);
            end else begin
                $display("  [FAIL] Address 0x00000000: Expected 0x00000000, Got 0x%08h", M_AXI_araddr);
            end
            complete_transaction();
            
            // Test address 0x00000004
            wb_adr = 32'h00000004;
            #(CLK_PERIOD);
            if (M_AXI_araddr == 32'h00000004) begin
                $display("  [PASS] Address 0x00000004: M_AXI_araddr = 0x%08h", M_AXI_araddr);
            end else begin
                $display("  [FAIL] Address 0x00000004: Expected 0x00000004, Got 0x%08h", M_AXI_araddr);
            end
            complete_transaction();
            
            // Test address 0x00000008
            wb_adr = 32'h00000008;
            #(CLK_PERIOD);
            if (M_AXI_araddr == 32'h00000008) begin
                $display("  [PASS] Address 0x00000008: M_AXI_araddr = 0x%08h", M_AXI_araddr);
            end else begin
                $display("  [FAIL] Address 0x00000008: Expected 0x00000008, Got 0x%08h", M_AXI_araddr);
            end
            complete_transaction();
        end
    endtask

    // Helper task to complete a transaction
    task complete_transaction;
        begin
            M_AXI_arready = 1'b1;
            #(CLK_PERIOD);
            M_AXI_arready = 1'b0;
            M_AXI_rvalid = 1'b1;
            M_AXI_rdata = 32'hDEADBEEF;
            M_AXI_rlast = 1'b1;
            #(CLK_PERIOD);
            M_AXI_rvalid = 1'b0;
            M_AXI_rlast = 1'b0;
            
            wait(wb_ack);
            #(CLK_PERIOD);
            wb_cyc = 1'b0;
            i_cnt_done = 1'b0;
            #(CLK_PERIOD * 2);
        end
    endtask

    // Monitor
    always @(posedge ACLK) begin
        if (M_AXI_arvalid && M_AXI_arready) begin
            $display("[%0t] AXI Address Handshake: addr=0x%08h", $time, M_AXI_araddr);
        end
        if (M_AXI_rvalid && M_AXI_rready) begin
            $display("[%0t] AXI Read Data: data=0x%08h", $time, M_AXI_rdata);
        end
        if (wb_ack) begin
            $display("[%0t] Wishbone ACK: rdt=0x%08h", $time, wb_rdt);
        end
    end

endmodule

