library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lock_tb is
end lock_tb;

architecture behavior of lock_tb is

component digital_lock
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        input_bit  : in  std_logic;
        enter      : in  std_logic;
        unlock     : out std_logic;
        error      : out std_logic
    );
end component;
signal clk, reset, input_bit, enter : std_logic := '0';
signal unlock, error : std_logic;

begin

uut: digital_lock port map (
    clk => clk,
    reset => reset,
    input_bit => input_bit,
    enter => enter,
    unlock => unlock,
    error => error
);
clk_process : process
begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
	 end loop;
end process;

stimulus: process
begin
    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    -- Correct password 1011
    input_bit <= '1'; enter <= '1'; wait for 20 ns;
    input_bit <= '0'; wait for 20 ns;
    input_bit <= '1'; wait for 20 ns;
    input_bit <= '1'; wait for 20 ns;

    wait;

end process;

end behavior;
