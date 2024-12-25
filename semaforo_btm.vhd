--------------------------------------------------------
-- Descrição: Semáforo Controlado com FSM em VHDL ------
-- Autores: Erick Dias, Guilherme Mano, Henrique Vaz ---
-- Ultima atualização: 24/12/24 ------------------------
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity semaforo_btm is
    port(
        clk                 : in std_logic;
        rst                 : in std_logic := '0';
        btm                 : in std_logic := '0';
        s1, s2, s3          : out std_logic_vector(2 downto 0);
        display             : out std_logic_vector(6 downto 0)
    );
end entity;

architecture hardware of semaforo_btm is
    -- Declaração dos estados
    type estado is (estado_inicial_reset, estadoA, estadoB, estadoC, estadoD, estadoE, estadoF, estado_safety);

    -- Declaração das cores do semáforo
    constant inicial         : std_logic_vector(2 downto 0) := "111"; -- teste luminoso
    constant vermelho        : std_logic_vector(2 downto 0) := "100";
    constant verde_amarelo   : std_logic_vector(2 downto 0) := "011";
    constant verde           : std_logic_vector(2 downto 0) := "001";

    -- Declaração das variáveis de tempo em segundos
    constant tempo_inicial   : integer := 2;
    constant tempo_erro      : integer := 5;
    constant tempo_safety    : integer := 5;
    constant tempo_verde     : integer := 10; -- Configurável entre 5 e 10 segundos.
    constant tempo_amarelo   : integer := 5;  -- Configurável entre 2 e 5 segundos
    
    -- Declaração das variáveis de tempo em Hertz
    constant clk_freq        : integer := 1;
    constant clk_inicial     : integer := clk_freq * tempo_inicial;
    constant clk_erro        : integer := clk_freq * tempo_erro;
    constant clk_safety      : integer := clk_freq * tempo_safety;
    constant clk_verde       : integer := clk_freq * tempo_verde;
    constant clk_amarelo     : integer := clk_freq * tempo_amarelo;

    -- Declaração dos sinais internos
    signal estado_atual      : estado := estado_inicial_reset;
    signal proximo_estado    : estado;
    signal contador, tempo   : integer := 0;
    signal contagem          : boolean;
    
    -- Declaração dos componentes
    signal reset             : std_logic;
    signal q                 : std_logic;
    signal display_ativo     : std_logic_vector(6 downto 0) := (others => '0');

    component FF_JK is
        port(
            clk     : in std_logic; 
            j       : in std_logic;
            k       : in std_logic; 
            q       : out std_logic; 
            q_bar   : out std_logic 
        );
    end component;

    component display_7seg is
        port(
            valor : in integer; 
            display : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    FF_JK_inst: FF_JK 
        port map (
            clk => clk,
            j => btm,
            k => reset,
            q => q,
            q_bar => open
        );

    display_inst: display_7seg 
        port map (
            valor => contador/clk_freq,
            display => display_ativo
        );

    
    display <= display_ativo when estado_atual = estado_safety else (others => '0');

    -- Processo para definição do sincronismo da FSM
    sincronismo: process(clk, rst)
    begin
        if rst = '1' then
            estado_atual <= estado_inicial_reset;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process sincronismo;
    
    -- Processo para realização da contagem
    cont: process(clk, rst, contador)
    begin
        if rst = '1' then
            contador <= 0;
            contagem <= FALSE;
        elsif rising_edge(clk) then
            if contador = tempo then
                contagem <= TRUE;
                contador <= 0;
            else
                contador <= contador + 1;
                contagem <= FALSE;
            end if;
        end if;
    end process cont;

    -- Processo combinacional para determinar o próximo estado e a saída
    combinacional: process(estado_atual, contagem, q)
    begin
        reset <= '0';
        case estado_atual is
            when estado_inicial_reset =>
                tempo <= clk_inicial;
                s1 <= inicial;
                s2 <= inicial;
                s3 <= inicial;
                if contagem then
                    proximo_estado <= estadoA;
                else
                    proximo_estado <= estado_inicial_reset;
                end if;

            when estadoA =>
                tempo <= clk_verde;
                s1 <= verde;
                s2 <= vermelho;
                s3 <= vermelho;
                if contagem then
                    proximo_estado <= estadoB;
                else
                    proximo_estado <= estadoA;
                end if;

            when estadoB =>
                tempo <= clk_amarelo;
                s1 <= verde_amarelo;
                s2 <= vermelho;
                s3 <= vermelho;
                if q = '1' and contagem then
                    proximo_estado <= estado_safety;
                    reset <= '1';
                elsif contagem then
                    proximo_estado <= estadoC;
                else
                    proximo_estado <= estadoB;
                end if;

            when estadoC =>
            tempo <= clk_verde;
                s1 <= vermelho;
                s2 <= verde;
                s3 <= vermelho;
                if contagem then
                    proximo_estado <= estadoD;
                else
                    proximo_estado <= estadoC;
                end if;

            when estadoD =>
                tempo <= clk_amarelo;
                s1 <= vermelho;
                s2 <= verde_amarelo;
                s3 <= vermelho;
                if q = '1' and contagem then
                    proximo_estado <= estado_safety;
                    reset <= '1';
                elsif contagem then
                    proximo_estado <= estadoE;
                else
                    proximo_estado <= estadoD;
                end if;

            when estadoE =>
                tempo <= clk_verde;
                s1 <= vermelho;
                s2 <= vermelho;
                s3 <= verde;
                if contagem then
                    proximo_estado <= estadoF;
                else
                    proximo_estado <= estadoE;
                end if;

            when estadoF =>
                tempo <= clk_amarelo;
                s1 <= vermelho;
                s2 <= vermelho;
                s3 <= verde_amarelo;
                if q = '1' and contagem then
                    proximo_estado <= estado_safety;
                    reset <= '1';
                elsif contagem then
                    proximo_estado <= estadoA;
                else
                    proximo_estado <= estadoF;
                end if;

            when estado_safety =>
                tempo <= clk_safety;
                s1 <= vermelho;
                s2 <= vermelho;
                s3 <= vermelho;
                if contagem then
                    proximo_estado <= estadoA;
                else
                    proximo_estado <= estado_safety;
                end if;

            when others =>
                tempo <= clk_erro;
                s1 <= vermelho;
                s2 <= vermelho;
                s3 <= vermelho;
                if contagem then
                    proximo_estado <= estadoA;
                end if;
        end case;
    end process combinacional;
end architecture;
