library IEEE;
use ieee.std_logic_1164;

ENTITY tsb IS
	PORT (
				D			: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				enable	: IN STD_LOGIC;
				Q			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	
END tsb;

ARCHITECTURE behavioral OF tsb IS

BEGIN

	PROCESS(enable, input)
	BEGIN
		
		if (enable = '1') then
			Q <= D;
		else
			Q <= (others => 'Z');
		end if;
	
	END PROCESS;
	
END behavioral;	