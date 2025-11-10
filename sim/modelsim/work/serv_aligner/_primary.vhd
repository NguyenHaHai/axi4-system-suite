library verilog;
use verilog.vl_types.all;
entity serv_aligner is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        i_ibus_adr      : in     vl_logic_vector(31 downto 0);
        i_ibus_cyc      : in     vl_logic;
        o_ibus_rdt      : out    vl_logic_vector(31 downto 0);
        o_ibus_ack      : out    vl_logic;
        o_wb_ibus_adr   : out    vl_logic_vector(31 downto 0);
        o_wb_ibus_cyc   : out    vl_logic;
        i_wb_ibus_rdt   : in     vl_logic_vector(31 downto 0);
        i_wb_ibus_ack   : in     vl_logic
    );
end serv_aligner;
