-- Descrição do funcionamento em VHDL do flip-flop JK
-- Autor: Erick S. Dias
-- Data: 23/12/2024

library ieee;
use ieee.std_logic_1164.all;

entity FF_JK is
    port(
        clk     : in std_logic; 
        j       : in std_logic;
        k       : in std_logic; 
        q       : out std_logic; 
        q_bar   : out std_logic 
    );
end entity;

architecture flip_flop of FF_JK is
    signal q_int : std_logic := '0';
    signal sel : std_logic_vector(1 downto 0);
begin
    
    sel <= j & k;

    process(clk)
    begin
        if rising_edge(clk) then
            case sel is
                when "00" => q_int <= q_int;    
                when "01" => q_int <= '0';         
                when "10" => q_int <= '1';        
                when "11" => q_int <= not q_int;              
            end case;
        end if;
    end process;

    q     <= q_int;
    q_bar <= not q_int;       
       
end architecture;
