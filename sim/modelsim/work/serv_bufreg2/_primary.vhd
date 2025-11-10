library verilog;
use verilog.vl_types.all;
entity serv_bufreg2 is
    generic(
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_en            : in     vl_logic;
        i_init          : in     vl_logic;
        i_cnt7          : in     vl_logic;
        i_cnt_done      : in     vl_logic;
        i_sh_right      : in     vl_logic;
        i_lsb           : in     vl_logic_vector(1 downto 0);
        i_bytecnt       : in     vl_logic_vector(1 downto 0);
        o_sh_done       : out    vl_logic;
        i_op_b_sel      : in     vl_logic;
        i_shift_op      : in     vl_logic;
        i_rs2           : in     vl_logic_vector;
        i_imm           : in     vl_logic_vector;
        o_op_b          : out    vl_logic_vector;
        o_q             : out    vl_logic_vector;
        o_dat           : out    vl_logic_vector(31 downto 0);
        i_load          : in     vl_logic;
        i_dat           : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_bufreg2;
