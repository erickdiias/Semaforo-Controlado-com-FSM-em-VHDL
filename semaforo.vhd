--  File: semaforo.vhd
--  Descrição: Módulo do semáforo
--  Autores: Erick Dias, Guilherme Mano, Henrique Vaz
--  Ultima atualização: 05/01/2025

library ieee;
use ieee.std_logic_1164.all;

entity semaforo is
    generic(
        tempo_verde          : integer := 10; -- Configurável entre 5 e 10 segundos.
        tempo_amarelo        : integer := 5   -- Configurável entre 2 e 5 segundos
    );
    port(
        clk_50MHz            : in std_logic;
        clk_1Hz              : in std_logic;
        rst                  : in std_logic;
        btm                  : in std_logic;
        semaforo1            : out std_logic_vector(2 downto 0);
        semaforo2            : out std_logic_vector(2 downto 0);
        semaforo3            : out std_logic_vector(2 downto 0)
    );
end entity;

architecture hardware of semaforo is

    -- Declaração dos estados
    type estado is (estadoInicialReset, estadoA, estadoB, estadoC, estadoD, estadoE, estadoF, estadoSafety);

    constant tempo_inicial   : integer := 2; 
    constant tempo_erro      : integer := 5;  
    constant tempo_safety    : integer := 5; 

    -- Declaração das cores do semáforo
    constant inicial         : std_logic_vector(2 downto 0) := "111"; -- teste luminoso
    constant vermelho        : std_logic_vector(2 downto 0) := "100";
    constant verde_amarelo   : std_logic_vector(2 downto 0) := "011";
    constant verde           : std_logic_vector(2 downto 0) := "001";

    -- Declaração dos sinais internos
    signal estadoAtual      : estado := estadoInicialReset;
    signal estadoProximo    : estado;
    signal contagem         : integer := 0;
    
    -- Declaração dos omponentes
    signal resetFF_JK       : std_logic;
    signal estadoBtm        : std_logic;

begin

    latch_jk_int: entity work.latch_jk 
        port map (
            clk_50MHz => clk_50MHz,
            j => btm,
            k => resetFF_JK,
            q => estadoBtm,
            q_bar => open
        );

    -- Processo para definição do sincronismo da FSM
    sincronismo: process(clk_1Hz, rst)
    begin
        if rst = '1' then
            estadoAtual <= estadoInicialReset;
        elsif rising_edge(clk_1Hz) then
            estadoAtual <= estadoProximo;
        end if;
    end process sincronismo;
    
    -- Processo para realização da contagem
    cont: process(clk_1Hz, rst)
    begin
        if rst = '1' then
            contagem <= 0;
        elsif rising_edge(clk_1Hz) then
            if estadoAtual /= estadoProximo then
                contagem <= 0;
            else
                contagem <= contagem + 1;
            end if;
        end if;
    end process cont;

    -- Processo combinacional para determinar o próximo estado e a saída
    combinacional: process(estadoAtual, contagem, estadoBtm)
    begin
        resetFF_JK <= '0';
        estadoProximo <= estadoAtual;
        case estadoAtual is
            when estadoInicialReset =>
                if contagem = tempo_inicial then
                    estadoProximo <= estadoA;
                end if;

            when estadoA =>
                if contagem = tempo_verde then
                    estadoProximo <= estadoB;
                end if;

            when estadoB =>
                if estadoBtm = '1' and contagem = tempo_amarelo then
                    estadoProximo <= estadoSafety;
                    resetFF_JK <= '1';
                elsif contagem = tempo_amarelo then
                    estadoProximo <= estadoC;
                end if;

            when estadoC =>
                if contagem = tempo_verde then
                    estadoProximo <= estadoD;
                end if;

            when estadoD =>
                if estadoBtm = '1' and contagem = tempo_amarelo then
                    estadoProximo <= estadoSafety;
                    resetFF_JK <= '1';
                elsif contagem = tempo_amarelo then
                    estadoProximo <= estadoE;
                end if;

            when estadoE =>
                if contagem = tempo_verde then
                    estadoProximo <= estadoF;
                end if;

            when estadoF =>
                if estadoBtm = '1' and contagem = tempo_amarelo then
                    estadoProximo <= estadoSafety;
                    resetFF_JK <= '1';
                elsif contagem = tempo_amarelo then
                    estadoProximo <= estadoA;
                end if;

            when estadoSafety =>
                if contagem = tempo_safety then
                    estadoProximo <= estadoA;
                end if;

            when others =>
                if contagem = tempo_erro then
                    estadoProximo <= estadoA;
                end if;
        end case;
    end process combinacional;

    -- Lógica para definição das saídas
    semaforo1 <=    inicial         when estadoAtual = estadoInicialReset else
                    verde           when estadoAtual = estadoA else
                    verde_amarelo   when estadoAtual = estadoB else
                    vermelho        when estadoAtual = estadoSafety else
                    vermelho;

    semaforo2 <=    inicial          when estadoAtual = estadoInicialReset else
                    verde           when estadoAtual = estadoC else
                    verde_amarelo   when estadoAtual = estadoD else
                    vermelho        when estadoAtual = estadoSafety else
                    vermelho;

    semaforo3 <=    inicial         when estadoAtual = estadoInicialReset else
                    verde           when estadoAtual = estadoE else
                    verde_amarelo   when estadoAtual = estadoF else
                    vermelho        when estadoAtual = estadoSafety else
                    vermelho;

end architecture;
