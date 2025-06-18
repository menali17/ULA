
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
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
end ULA;

architecture Behavioral of ULA is

    signal result : signed(4 downto 0) := (others => '0');
    signal a_int, b_int : signed(3 downto 0);
    signal F_int : STD_LOGIC_VECTOR(3 downto 0);
    signal c_out_int, over_int : STD_LOGIC;

    signal clk_div : unsigned(24 downto 0) := (others => '0');
    signal slow_clk : STD_LOGIC := '0';

    signal digit_sel : integer range 0 to 5 := 0;
    signal digit_data : STD_LOGIC_VECTOR(3 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            clk_div <= clk_div + 1;
            if clk_div = 50000 then
                slow_clk <= not slow_clk;
                clk_div <= (others => '0');
            end if;
        end if;
    end process;

    process(A, B, SS)
        variable sum : signed(4 downto 0);
    begin
        a_int <= signed(A);
        b_int <= signed(B);
        c_out_int <= '0';
        over_int <= '0';

        case SS is
            when "00" =>
                sum := ('0' & a_int) + ('0' & b_int);
                result <= sum;
                c_out_int <= sum(4);
                over_int <= (a_int(3) and b_int(3) and not sum(3)) or
                            (not a_int(3) and not b_int(3) and sum(3));

            when "01" =>
                sum := ('0' & a_int) - ('0' & b_int);
                result <= sum;
                c_out_int <= sum(4);
                over_int <= (a_int(3) and not b_int(3) and not sum(3)) or
                            (not a_int(3) and b_int(3) and sum(3));

            when "10" =>
                result <= ('0' & (a_int and b_int));
                c_out_int <= '0';
                over_int  <= '0';

            when others =>
                result <= ('0' & (a_int or b_int));
                c_out_int <= '0';
                over_int  <= '0';
        end case;

        F_int <= std_logic_vector(result(3 downto 0));
    end process;

    c_out <= c_out_int;
    over  <= over_int;
    LED_S1 <= SS(1);
    LED_S0 <= SS(0);

    process(digit_data)
    begin
        case digit_data is
            when "0000" => display <= "0111111";
            when "0001" => display <= "0000110";
            when "0010" => display <= "1011011";
            when "0011" => display <= "1001111";
            when "0100" => display <= "1100110";
            when "0101" => display <= "1101101";
            when "0110" => display <= "1111101";
            when "0111" => display <= "0000111";
            when "1000" => display <= "1111111";
            when "1001" => display <= "1101111";
            when others => display <= "0000000";
        end case;
    end process;

    process(slow_clk, RESET)
    begin
        if RESET = '1' then
            digit_sel <= 0;
        elsif rising_edge(slow_clk) then
            digit_sel <= (digit_sel + 1) mod 6;
        end if;
    end process;

    process(digit_sel)
    begin
        anode <= "111111";
        case digit_sel is
            when 0 =>
                digit_data <= F_int;
                anode <= "111110";
            when others =>
                digit_data <= "0000";
                anode <= "111111";
        end case;
    end process;

end Behavioral;
