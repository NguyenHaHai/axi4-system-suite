library verilog;
use verilog.vl_types.all;
entity serv_csr is
    generic(
        RESET_STRATEGY  : string  := "MINI";
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_rst           : in     vl_logic;
        i_trig_irq      : in     vl_logic;
        i_en            : in     vl_logic;
        i_cnt0to3       : in     vl_logic;
        i_cnt3          : in     vl_logic;
        i_cnt7          : in     vl_logic;
        i_cnt11         : in     vl_logic;
        i_cnt12         : in     vl_logic;
        i_cnt_done      : in     vl_logic;
        i_mem_op        : in     vl_logic;
        i_mtip          : in     vl_logic;
        i_trap          : in     vl_logic;
        o_new_irq       : out    vl_logic;
        i_e_op          : in     vl_logic;
        i_ebreak        : in     vl_logic;
        i_mem_cmd       : in     vl_logic;
        i_mstatus_en    : in     vl_logic;
        i_mie_en        : in     vl_logic;
        i_mcause_en     : in     vl_logic;
        i_csr_source    : in     vl_logic_vector(1 downto 0);
        i_mret          : in     vl_logic;
        i_csr_d_sel     : in     vl_logic;
        i_rf_csr_out    : in     vl_logic_vector;
        o_csr_in        : out    vl_logic_vector;
        i_csr_imm       : in     vl_logic_vector;
        i_rs1           : in     vl_logic_vector;
        o_q             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RESET_STRATEGY : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_csr;
