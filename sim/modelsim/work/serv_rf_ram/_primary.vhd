library verilog;
use verilog.vl_types.all;
entity serv_rf_ram is
    generic(
        width           : integer := 0;
        csr_regs        : integer := 4;
        depth           : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_waddr         : in     vl_logic_vector;
        i_wdata         : in     vl_logic_vector;
        i_wen           : in     vl_logic;
        i_raddr         : in     vl_logic_vector;
        i_ren           : in     vl_logic;
        o_rdata         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of csr_regs : constant is 1;
    attribute mti_svvh_generic_type of depth : constant is 3;
end serv_rf_ram;
