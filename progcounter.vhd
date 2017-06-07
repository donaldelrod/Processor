LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY progcounter IS
PORT (		
			D					: IN STD_LOGIC;
			clk, res 			: IN STD_LOGIC;
			Q					: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		);
END progcounter;

ARCHITECTURE Behavior OF progcounter IS	
	
	
	signal lastd		: STD_LOGIC;
	signal state		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

	PROCESS (clk, res, D)
	BEGIN
		if (rising_edge(res)) then
			Q <= others => 0;
			state <= "0000";
		elsif (rising_edge(clk) AND D = '1' AND lastd = '0') then			
			case state is
				when "0000"	=> state <= "0001";
				when "0001"	=> state <= "0010";
				when "0010"	=> state <= "0011";
				when "0011"	=> state <= "0100";
				when "0100"	=> state <= "0101";
				when "0101"	=> state <= "0110";
				when "0110"	=> state <= "0111";
				when "0111"	=> state <= "1000";
				when "1000"	=> state <= "1001";
				when "1001"	=> state <= "1010";
				when "1010"	=> state <= "1011";
				when "1011"	=> state <= "1100";
				when "1100"	=> state <= "1101";
				when "1101"	=> state <= "1110";
				when "1110"	=> state <= "1111";
				when "1111"	=> state <= "0000";
				when others => state <= "0000";
			end case;
			
			Q <= state;
			
		end if;
		lastd <= D;
	END PROCESS ;
	
END Behavior ;
