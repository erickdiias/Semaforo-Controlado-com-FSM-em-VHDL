--  File: TRABALHO_3B.vhd
--  Descrição: Módulo principal do trabalho 3B 
--  Autores: Erick Dias, Guilherme Mano, Henrique Vaz
--  Ultima atualização: 05/01/2025

library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        btm        : in  std_logic;
        semaforo1  : out std_logic_vector(2 downto 0);
        semaforo2  : out std_logic_vector(2 downto 0);
        semaforo3  : out std_logic_vector(2 downto 0)
    );
end entity top_level;

architecture main of top_level is

    -- Declaração do sinal de clock de 1Hz
    signal clk_1Hz : std_logic;

begin

    -- Instanciação do divisor de frequência
    clk_div_inst : entity work.clk_div
        generic map(
            freq_clk => 50e6 -- Configurável entre 1 e 100 MHz
        )
        port map(
            clk     => clk,
            clk_1Hz => clk_1Hz
        );
    
    semaforo_int: entity work.semaforo
        generic map(   
            tempo_verde => 10, -- Configurável entre 5 e 10 segundos.
            tempo_amarelo => 5 -- Configurável entre 2 e 5 segundos
        )
        port map(
            clk_50MHz => clk,
            clk_1Hz => clk_1Hz,
            rst => reset,
            btm => btm,
            semaforo1 => semaforo1,
            semaforo2 => semaforo2,
            semaforo3 => semaforo3
        );
end architecture main;
