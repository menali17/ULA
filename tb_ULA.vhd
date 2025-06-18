
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ULA is
end tb_ULA;

architecture Behavioral of tb_ULA is

    -- Component da ULA
    component ULA
        Port (
            clk      : in  STD_LOGIC;
            RESET    : in  STD_LOGIC;
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            SS       : in  STD_LOGIC_VECTOR(1 downto 0);
            c_out    : out STD_LOGIC;
            over     : out STD_LOGIC;
            LED_S1   : out STD_LOGIC;
            LED_S0   : out STD_LOGIC;
            display  : out STD_LOGIC_VECTOR(6 downto 0);
            anode    : out STD_LOGIC_VECTOR(5 downto 0)
        );
    end component;

    -- Sinais de estímulo
    signal clk_tb      : STD_LOGIC := '0';
    signal RESET_tb    : STD_LOGIC := '0';
    signal A_tb        : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B_tb        : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal SS_tb       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal c_out_tb    : STD_LOGIC;
    signal over_tb     : STD_LOGIC;
    signal LED_S1_tb   : STD_LOGIC;
    signal LED_S0_tb   : STD_LOGIC;
    signal display_tb  : STD_LOGIC_VECTOR(6 downto 0);
    signal anode_tb    : STD_LOGIC_VECTOR(5 downto 0);

begin

    -- Instanciando a ULA
    uut: ULA port map(
        clk      => clk_tb,
        RESET    => RESET_tb,
        A        => A_tb,
        B        => B_tb,
        SS       => SS_tb,
        c_out    => c_out_tb,
        over     => over_tb,
        LED_S1   => LED_S1_tb,
        LED_S0   => LED_S0_tb,
        display  => display_tb,
        anode    => anode_tb
    );

    -- Geração de clock
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 10 ns;
            clk_tb <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Estímulos de teste
    stimulus: process
    begin
        -- Reset inicial
        RESET_tb <= '1';
        wait for 50 ns;
        RESET_tb <= '0';

        -- Teste de Soma (SS=00)
        A_tb <= "0011"; -- 3
        B_tb <= "0101"; -- 5
        SS_tb <= "00";
        wait for 100 ns;

        -- Teste de Subtração (SS=01)
        A_tb <= "1000"; -- 8
        B_tb <= "0011"; -- 3
        SS_tb <= "01";
        wait for 100 ns;

        -- Teste AND (SS=10)
        A_tb <= "1100"; -- 12
        B_tb <= "1010"; -- 10
        SS_tb <= "10";
        wait for 100 ns;

        -- Teste OR (SS=11)
        A_tb <= "1100";
        B_tb <= "1010";
        SS_tb <= "11";
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
