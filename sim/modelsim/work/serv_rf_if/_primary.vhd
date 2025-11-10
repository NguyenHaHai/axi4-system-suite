library verilog;
use verilog.vl_types.all;
entity serv_rf_if is
    generic(
        WITH_CSR        : integer := 1;
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        i_cnt_en        : in     vl_logic;
        o_wreg0         : out    vl_logic_vector;
        o_wreg1         : out    vl_logic_vector;
        o_wen0          : out    vl_logic;
        o_wen1          : out    vl_logic;
        o_wdata0        : out    vl_logic_vector;
        o_wdata1        : out    vl_logic_vector;
        o_rreg0         : out    vl_logic_vector;
        o_rreg1         : out    vl_logic_vector;
        i_rdata0        : in     vl_logic_vector;
        i_rdata1        : in     vl_logic_vector;
        i_trap          : in     vl_logic;
        i_mret          : in     vl_logic;
        i_mepc          : in     vl_logic_vector;
        i_mtval_pc      : in     vl_logic;
        i_bufreg_q      : in     vl_logic_vector;
        i_bad_pc        : in     vl_logic_vector;
        o_csr_pc        : out    vl_logic_vector;
        i_csr_en        : in     vl_logic;
        i_csr_addr      : in     vl_logic_vector(1 downto 0);
        i_csr           : in     vl_logic_vector;
        o_csr           : out    vl_logic_vector;
        i_rd_wen        : in     vl_logic;
        i_rd_waddr      : in     vl_logic_vector(4 downto 0);
        i_ctrl_rd       : in     vl_logic_vector;
        i_alu_rd        : in     vl_logic_vector;
        i_rd_alu_en     : in     vl_logic;
        i_csr_rd        : in     vl_logic_vector;
        i_rd_csr_en     : in     vl_logic;
        i_mem_rd        : in     vl_logic_vector;
        i_rd_mem_en     : in     vl_logic;
        i_rs1_raddr     : in     vl_logic_vector(4 downto 0);
        o_rs1           : out    vl_logic_vector;
        i_rs2_raddr     : in     vl_logic_vector(4 downto 0);
        o_rs2           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WITH_CSR : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_rf_if;
