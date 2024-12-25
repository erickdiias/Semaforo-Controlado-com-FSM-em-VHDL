library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_7seg is
    port(
        valor : in integer; 
        display : out std_logic_vector(6 downto 0)
    );
end entity;

architecture main of display_7seg is
begin
    process(valor)
    begin
        case valor is
            when 0 => display <= "1111110"; -- número 0  
            when 1 => display <= "0110000"; -- número 1
            when 2 => display <= "1101101"; -- número 2
            when 3 => display <= "1111001"; -- número 3
            when 4 => display <= "0110011"; -- número 4
            when 5 => display <= "1011011"; -- número 5
            when 6 => display <= "1011111"; -- número 6
            when 7 => display <= "1110000"; -- número 7
            when 8 => display <= "1111111"; -- número 8
            when 9 => display <= "1111011"; -- número 9
            when others => display <= "0000000";
        end case;
    end process;
end architecture;
