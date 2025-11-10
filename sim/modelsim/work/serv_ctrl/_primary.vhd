library verilog;
use verilog.vl_types.all;
entity serv_ctrl is
    generic(
        RESET_STRATEGY  : string  := "MINI";
        RESET_PC        : integer := 0;
        WITH_CSR        : integer := 1;
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        clk             : in     vl_logic;
        i_rst           : in     vl_logic;
        i_pc_en         : in     vl_logic;
        i_cnt12to31     : in     vl_logic;
        i_cnt0          : in     vl_logic;
        i_cnt1          : in     vl_logic;
        i_cnt2          : in     vl_logic;
        i_jump          : in     vl_logic;
        i_jal_or_jalr   : in     vl_logic;
        i_utype         : in     vl_logic;
        i_pc_rel        : in     vl_logic;
        i_trap          : in     vl_logic;
        i_iscomp        : in     vl_logic;
        i_imm           : in     vl_logic_vector;
        i_buf           : in     vl_logic_vector;
        i_csr_pc        : in     vl_logic_vector;
        o_rd            : out    vl_logic_vector;
        o_bad_pc        : out    vl_logic_vector;
        o_ibus_adr      : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RESET_STRATEGY : constant is 1;
    attribute mti_svvh_generic_type of RESET_PC : constant is 1;
    attribute mti_svvh_generic_type of WITH_CSR : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_ctrl;
