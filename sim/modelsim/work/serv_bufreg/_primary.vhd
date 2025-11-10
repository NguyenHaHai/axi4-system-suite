library verilog;
use verilog.vl_types.all;
entity serv_bufreg is
    generic(
        MDU             : vl_logic_vector(0 downto 0) := (others => Hi0);
        W               : integer := 1;
        B               : vl_notype
    );
    port(
        i_clk           : in     vl_logic;
        i_cnt0          : in     vl_logic;
        i_cnt1          : in     vl_logic;
        i_cnt_done      : in     vl_logic;
        i_en            : in     vl_logic;
        i_init          : in     vl_logic;
        i_mdu_op        : in     vl_logic;
        o_lsb           : out    vl_logic_vector(1 downto 0);
        i_rs1_en        : in     vl_logic;
        i_imm_en        : in     vl_logic;
        i_clr_lsb       : in     vl_logic;
        i_shift_op      : in     vl_logic;
        i_right_shift_op: in     vl_logic;
        i_shamt         : in     vl_logic_vector(2 downto 0);
        i_sh_signed     : in     vl_logic;
        i_rs1           : in     vl_logic_vector;
        i_imm           : in     vl_logic_vector;
        o_q             : out    vl_logic_vector;
        o_dbus_adr      : out    vl_logic_vector(31 downto 0);
        o_ext_rs1       : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MDU : constant is 2;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 3;
end serv_bufreg;
