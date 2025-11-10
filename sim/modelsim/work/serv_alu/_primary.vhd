library verilog;
use verilog.vl_types.all;
entity serv_alu is
    generic(
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        clk             : in     vl_logic;
        i_en            : in     vl_logic;
        i_cnt0          : in     vl_logic;
        o_cmp           : out    vl_logic;
        i_sub           : in     vl_logic;
        i_bool_op       : in     vl_logic_vector(1 downto 0);
        i_cmp_eq        : in     vl_logic;
        i_cmp_sig       : in     vl_logic;
        i_rd_sel        : in     vl_logic_vector(2 downto 0);
        i_rs1           : in     vl_logic_vector;
        i_op_b          : in     vl_logic_vector;
        i_buf           : in     vl_logic_vector;
        o_rd            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_alu;
