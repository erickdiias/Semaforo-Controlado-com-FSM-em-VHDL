library ieee;
use ieee.STD_LOGIC_1164.ALL;

entity latch_jk is
    Port (
        clk_50MHz : in std_logic;
        j   : in  std_logic;
        k   : in  std_logic;
        q   : out std_logic;
        q_bar : out std_logic
    );
end entity;

architecture Behavioral of latch_jk is
    signal SET, RESET, s, s_bar : std_logic; -- Sinais internos
begin
    
    SET     <= not (j and s_bar and clk_50MHz);
    RESET   <= not (k and s and clk_50MHz);

    s       <= SET nand s_bar;
    s_bar   <= RESET nand s;

    q       <= s;
    q_bar   <= s_bar;

end architecture;
