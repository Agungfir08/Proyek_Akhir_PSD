--Michael Harditya 2006577265
library ieee;
use ieee.std_logic_1164.all;

entity FSM_Control is
	port (
		Mode,clk,clr : IN std_logic;
		Sense,O : OUT std_logic);
end entity;

architecture arch of FSM_Control is
component FSM_Timer is
	port ( en,clock,clear : in std_logic;
			state : out std_logic);
end component;
type state_types is (Off,Timer,Manual);
signal present_state, next_state : state_types;
signal en_timer : std_logic := '0';
signal state_out : std_logic;
begin
	UUT : FSM_Timer port map (en_timer,clk,clr,state_out);
	sync_proc : process(clk, next_state,clr)
	begin
		if (CLR = '1') then present_state <= Timer;
		elsif (rising_edge(clk)) then present_state <= next_state;
		end if;
	end process sync_proc;
	
	comb_proc : process(present_state,Mode)
	begin
		Sense <= '0';
		en_timer <= '0';
		case present_state is
		when Timer =>
			Sense <= '1';
			en_timer <= '0';
			if (Mode = '1') then next_state <= Manual;
			elsif(Mode = '0') then next_state <= Timer;
			else next_state <= Off;
			end if;
		when Manual =>
			Sense <= '0';
			en_timer <= '1';
			if (Mode = '1') then next_state <= Manual;
			elsif (Mode = '0') then next_state <= Timer;
			else next_state <= Off;
			end if;
		when Off =>
			Sense <= '0';
			en_timer <= '0';
			if (Mode = '1') then next_state <= Manual;
			elsif (Mode = '0') then next_state <= Timer;
			else next_state <= Off;
			end if;
		end case;
	end process comb_proc;
	O <= state_out;
end architecture;