library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_tb is
end FSM_tb;

architecture testbench of FSM_tb is
    component FSM_Control is
        port (Mode : IN std_logic_vector (1 downto 0); -- untuk memilih mode
                CLK,CLR : IN std_logic;
                Sense,Dout : OUT std_logic);
    end component;

    signal mode_tb : std_logic_vector (1 downto 0);
    signal clk_tb, clr_tb : std_logic;
    signal sense, Qout : std_logic;

    signal wait_time : time := 20 ns;

begin

    UUT : FSM_control port map (
        Mode => mode_tb,
        CLK => clk_tb,
        CLR => clr_tb,
        Sense => sense,
        Dout => Qout);

	process
        begin 
             clk_tb <= '1';
             wait for wait_time/4;
             clk_tb <= '0';
             wait for wait_time/4;
        end process;  
        
    process
        begin
            clr_tb <= '1';
            wait for wait_time/2;
            clr_tb <= '0';
            wait for wait_time;
            clr_tb <= '1';
            wait for wait_time/2;
            clr_tb <= '0';
            wait;
        end process;

    process
        begin
            mode_tb <= "01";
            wait for wait_time/2;
            mode_tb <= "11";
            wait for wait_time/2;
            mode_tb <= "00";
            wait for wait_time/2;
        end process;
end architecture;