LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFF_pos IS
PORT (		
			--input from the bus
			D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk, res 			: IN STD_LOGIC;
			Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable				: IN STD_LOGIC
		);
END DFF_pos ;

ARCHITECTURE Behavior OF DFF_pos IS	

BEGIN

	PROCESS (clk, res)
	BEGIN
		if (rising_edge(res)) then
			Q <= others => 0;
		elsif (rising_edge(clk) AND enable = '1') then			
			Q <= D;
			
		end if;
	END PROCESS ;

END Behavior ;
