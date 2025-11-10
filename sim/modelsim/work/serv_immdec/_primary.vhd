library verilog;
use verilog.vl_types.all;
entity serv_immdec is
    generic(
        SHARED_RFADDR_IMM_REGS: integer := 1;
        W               : integer := 1
    );
    port(
        i_clk           : in     vl_logic;
        i_cnt_en        : in     vl_logic;
        i_cnt_done      : in     vl_logic;
        i_immdec_en     : in     vl_logic_vector(3 downto 0);
        i_csr_imm_en    : in     vl_logic;
        i_ctrl          : in     vl_logic_vector(3 downto 0);
        o_rd_addr       : out    vl_logic_vector(4 downto 0);
        o_rs1_addr      : out    vl_logic_vector(4 downto 0);
        o_rs2_addr      : out    vl_logic_vector(4 downto 0);
        o_csr_imm       : out    vl_logic_vector;
        o_imm           : out    vl_logic_vector;
        i_wb_en         : in     vl_logic;
        i_wb_rdt        : in     vl_logic_vector(31 downto 7)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SHARED_RFADDR_IMM_REGS : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
end serv_immdec;
