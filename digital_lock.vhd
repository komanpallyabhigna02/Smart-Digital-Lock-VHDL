library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digital_lock is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input_bit : in  STD_LOGIC;
           enter : in  STD_LOGIC;
           unlock : out  STD_LOGIC;
           error : out  STD_LOGIC);
end digital_lock;

architecture Behavioral of digital_lock is
type state_type is (S0, S1, S2, S3, CHECK, UNLOCKED, ERROR_STATE, LOCKED);
    signal state : state_type := S0;

    signal password : std_logic_vector(3 downto 0) := "1011";
    signal user_input : std_logic_vector(3 downto 0) := "0000";
    signal count : integer range 0 to 3 := 0;
    signal wrong_attempts : integer range 0 to 3 := 0;

begin
process(clk, reset)
begin
    if reset = '1' then
        state <= S0;
        wrong_attempts <= 0;
        unlock <= '0';
        error <= '0';
        count <= 0;
		  elsif rising_edge(clk) then

        case state is

            when S0 =>
                unlock <= '0';
                error <= '0';
                if enter = '1' then
                    user_input(3) <= input_bit;
                    state <= S1;
                end if;
					 when S1 =>
                if enter = '1' then
                    user_input(2) <= input_bit;
                    state <= S2;
                end if;

            when S2 =>
                if enter = '1' then
                    user_input(1) <= input_bit;
                    state <= S3;
                end if;
					 when S3 =>
                if enter = '1' then
                    user_input(0) <= input_bit;
                    state <= CHECK;
                end if;

            when CHECK =>
                if user_input = password then
                    state <= UNLOCKED;
                else
                    wrong_attempts <= wrong_attempts + 1;
                    state <= ERROR_STATE;
                end if;

            when UNLOCKED =>
                unlock <= '1';
					 when ERROR_STATE =>
                error <= '1';
                if wrong_attempts = 3 then
                    state <= LOCKED;
                else
                    state <= S0;
                end if;

            when LOCKED =>
                unlock <= '0';
                error <= '1';

        end case;
    end if;
end process;

end Behavioral;
