library verilog;
use verilog.vl_types.all;
entity serv_compdec is
    port(
        i_clk           : in     vl_logic;
        i_instr         : in     vl_logic_vector(31 downto 0);
        i_ack           : in     vl_logic;
        o_instr         : out    vl_logic_vector(31 downto 0);
        o_iscomp        : out    vl_logic
    );
end serv_compdec;
