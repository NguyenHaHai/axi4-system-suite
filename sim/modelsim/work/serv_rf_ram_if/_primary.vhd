library verilog;
use verilog.vl_types.all;
entity serv_rf_ram_if is
    generic(
        width           : integer := 8;
        W               : integer := 1;
        reset_strategy  : string  := "MINI";
        csr_regs        : integer := 4;
        B               : vl_notype;
        raw             : vl_notype;
        l2w             : vl_notype;
        aw              : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_rst           : in     vl_logic;
        i_wreq          : in     vl_logic;
        i_rreq          : in     vl_logic;
        o_ready         : out    vl_logic;
        i_wreg0         : in     vl_logic_vector;
        i_wreg1         : in     vl_logic_vector;
        i_wen0          : in     vl_logic;
        i_wen1          : in     vl_logic;
        i_wdata0        : in     vl_logic_vector;
        i_wdata1        : in     vl_logic_vector;
        i_rreg0         : in     vl_logic_vector;
        i_rreg1         : in     vl_logic_vector;
        o_rdata0        : out    vl_logic_vector;
        o_rdata1        : out    vl_logic_vector;
        o_waddr         : out    vl_logic_vector;
        o_wdata         : out    vl_logic_vector;
        o_wen           : out    vl_logic;
        o_raddr         : out    vl_logic_vector;
        o_ren           : out    vl_logic;
        i_rdata         : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of reset_strategy : constant is 1;
    attribute mti_svvh_generic_type of csr_regs : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
    attribute mti_svvh_generic_type of raw : constant is 3;
    attribute mti_svvh_generic_type of l2w : constant is 3;
    attribute mti_svvh_generic_type of aw : constant is 3;
end serv_rf_ram_if;
