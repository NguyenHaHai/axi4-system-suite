library verilog;
use verilog.vl_types.all;
entity wb2axi_read is
    generic(
        ADDR_WIDTH      : integer := 32;
        DATA_WIDTH      : integer := 32;
        ID_WIDTH        : integer := 4
    );
    port(
        ACLK            : in     vl_logic;
        ARESETN         : in     vl_logic;
        wb_adr          : in     vl_logic_vector;
        wb_cyc          : in     vl_logic;
        i_cnt_done      : in     vl_logic;
        wb_rdt          : out    vl_logic_vector;
        wb_ack          : out    vl_logic;
        M_AXI_arid      : out    vl_logic_vector;
        M_AXI_araddr    : out    vl_logic_vector;
        M_AXI_arlen     : out    vl_logic_vector(7 downto 0);
        M_AXI_arsize    : out    vl_logic_vector(2 downto 0);
        M_AXI_arburst   : out    vl_logic_vector(1 downto 0);
        M_AXI_arlock    : out    vl_logic_vector(1 downto 0);
        M_AXI_arcache   : out    vl_logic_vector(3 downto 0);
        M_AXI_arprot    : out    vl_logic_vector(2 downto 0);
        M_AXI_arqos     : out    vl_logic_vector(3 downto 0);
        M_AXI_arregion  : out    vl_logic_vector(3 downto 0);
        M_AXI_arvalid   : out    vl_logic;
        M_AXI_arready   : in     vl_logic;
        M_AXI_rid       : in     vl_logic_vector;
        M_AXI_rdata     : in     vl_logic_vector;
        M_AXI_rresp     : in     vl_logic_vector(1 downto 0);
        M_AXI_rlast     : in     vl_logic;
        M_AXI_rvalid    : in     vl_logic;
        M_AXI_rready    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ID_WIDTH : constant is 1;
end wb2axi_read;
