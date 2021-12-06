--Michael Harditya 2006577265
library ieee;
use ieee.std_logic_1164.all;

entity FSM_Control is
	port (Mode : IN std_logic_vector (1 downto 0); -- untuk memilih mode
			CLK,CLR : IN std_logic;
			Sense,Dout : OUT std_logic);
end entity;

architecture arch of FSM_Control is
component FSM_Timer is
	port ( en,clock,clear : in std_logic;
			state : out std_logic);
end component;
type state_types is (Blink,Auto,Manual,Count);
signal present_state, next_state : state_types;

signal en_timer : std_logic;
signal lampOn : std_logic;
signal senseOn : std_logic;
signal state : std_logic;

begin
	timer : FSM_Timer port map (en_timer,CLK,CLR,state);
	sync_proc : process(CLK, next_state,CLR)
	begin
		if (CLR = '1') then present_state <= Blink;
		elsif (rising_edge(CLK)) then present_state <= next_state;
		end if;
	end process sync_proc;
	
	comb_proc : process(present_state,Mode)
	begin
		senseOn <= '0';
		en_timer <= '0';
		case present_state is
		when Blink =>
			senseOn <= '0'; --matikan sensor
			en_timer <= '0'; -- matikan timer
			--do blink twice
			lampOn <= '1' after 1000 ns;
			lampOn <= '0' after 100 ns;
			lampOn <= '1' after 1000 ns;
			lampOn <= '0';
			if (Mode = "10") then next_state <= Manual;
			elsif(Mode = "11") then next_state <= Count;
			elsif(Mode = "01") then next_state <= Auto;
			else next_state <= Blink;
			end if;
		when Auto =>
			Sense <= '1'; -- nyalakan sensor
			en_timer <= '0'; -- matikan timer
			lampOn <= '0'; -- matikan manual mode
			if (Mode = "10") then next_state <= Manual;
			elsif(Mode = "11") then next_state <= Count;
			else next_state <= Auto;
			end if;
		when Manual =>
			senseOn <= '0'; --matikan sensor
			en_timer <= '0'; -- matikan timer
			lampOn <= '0'; -- matikan manual mode
			if (Mode = "10") then next_state <= Manual;
			elsif (Mode = "11") then next_state <= Count;
			else next_state <= Auto;
			end if;
		when Count =>
			senseOn <= '0'; -- matikan sensor
			en_timer <= '1'; -- nyalakan timer
			lampOn <= state; -- arahkan output lampu sesuai timer
			if (Mode = "10") then next_state <= Manual;
			elsif (Mode = "11") then next_state <= Count;
			else next_state <= Auto;
			end if;
		end case;
	end process comb_proc;
	Dout <= lampOn;
	Sense <= senseOn;
end architecture;