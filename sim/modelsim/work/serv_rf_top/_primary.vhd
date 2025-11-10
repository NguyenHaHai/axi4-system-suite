library verilog;
use verilog.vl_types.all;
entity serv_rf_top is
    generic(
        RESET_PC        : integer := 0;
        COMPRESSED      : vl_logic_vector(0 downto 0) := (others => Hi0);
        ALIGN           : vl_logic_vector(0 downto 0);
        MDU             : vl_logic_vector(0 downto 0) := (others => Hi0);
        PRE_REGISTER    : integer := 1;
        RESET_STRATEGY  : string  := "MINI";
        DEBUG           : vl_logic_vector(0 downto 0) := (others => Hi0);
        WITH_CSR        : integer := 1;
        W               : integer := 1;
        RF_WIDTH        : vl_notype;
        RF_L2D          : vl_notype
    );
    port(
        clk             : in     vl_logic;
        i_rst           : in     vl_logic;
        i_timer_irq     : in     vl_logic;
        o_ibus_adr      : out    vl_logic_vector(31 downto 0);
        o_ibus_cyc      : out    vl_logic;
        i_ibus_rdt      : in     vl_logic_vector(31 downto 0);
        i_ibus_ack      : in     vl_logic;
        o_dbus_adr      : out    vl_logic_vector(31 downto 0);
        o_dbus_dat      : out    vl_logic_vector(31 downto 0);
        o_dbus_sel      : out    vl_logic_vector(3 downto 0);
        o_dbus_we       : out    vl_logic;
        o_dbus_cyc      : out    vl_logic;
        i_dbus_rdt      : in     vl_logic_vector(31 downto 0);
        i_dbus_ack      : in     vl_logic;
        o_ext_rs1       : out    vl_logic_vector(31 downto 0);
        o_ext_rs2       : out    vl_logic_vector(31 downto 0);
        o_ext_funct3    : out    vl_logic_vector(2 downto 0);
        i_ext_rd        : in     vl_logic_vector(31 downto 0);
        i_ext_ready     : in     vl_logic;
        o_mdu_valid     : out    vl_logic;
        o_cnt_done      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RESET_PC : constant is 1;
    attribute mti_svvh_generic_type of COMPRESSED : constant is 2;
    attribute mti_svvh_generic_type of ALIGN : constant is 4;
    attribute mti_svvh_generic_type of MDU : constant is 2;
    attribute mti_svvh_generic_type of PRE_REGISTER : constant is 1;
    attribute mti_svvh_generic_type of RESET_STRATEGY : constant is 1;
    attribute mti_svvh_generic_type of DEBUG : constant is 2;
    attribute mti_svvh_generic_type of WITH_CSR : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of RF_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of RF_L2D : constant is 3;
end serv_rf_top;
