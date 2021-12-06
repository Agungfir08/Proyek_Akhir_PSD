library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_tb is
end FSM_tb;

architecture testbench of FSM_tb is
    component FSM_Control is
        port (
            Mode,clk,clr : IN std_logic;
            Sense,O : OUT std_logic);
    end component;

    signal mode_tb : std_logic;
    signal clk_tb, clr_tb : std_logic;
    signal sense, Qout : std_logic;

	signal counter : integer := 0;
    signal wait_time : time := 20 ns;
    constant end_counter : integer := 10;

begin

    UUT : FSM_control port map (
        Mode => mode_tb,
        clk => clk_tb,
        clr => clr_tb,
        Sense => sense,
        O => Qout);

    clk_proc : process
        begin 
            if(counter < end_counter) then
                clk_tb <= '1';
                wait for wait_time/2;
                clk_tb <= '0';
                wait for wait_time/2;
                counter <= counter + 1;
            end if;
        end process;  
        
    FSM_proc : process
        begin
            clr_tb <= '0';
            wait for wait_time;
            sense <= '1';
            wait for wait_time;
            mode_tb <= '1';
            wait for wait_time;

            wait;
        end process;
end architecture;