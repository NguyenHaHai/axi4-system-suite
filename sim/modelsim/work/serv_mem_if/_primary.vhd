library verilog;
use verilog.vl_types.all;
entity serv_mem_if is
    generic(
        WITH_CSR        : vl_logic_vector(0 downto 0) := (others => Hi1);
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_bytecnt       : in     vl_logic_vector(1 downto 0);
        i_lsb           : in     vl_logic_vector(1 downto 0);
        o_misalign      : out    vl_logic;
        i_signed        : in     vl_logic;
        i_word          : in     vl_logic;
        i_half          : in     vl_logic;
        i_mdu_op        : in     vl_logic;
        i_bufreg2_q     : in     vl_logic_vector;
        o_rd            : out    vl_logic_vector;
        o_wb_sel        : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WITH_CSR : constant is 2;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_mem_if;
