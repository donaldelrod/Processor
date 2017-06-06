library IEEE;
use ieee.std_logic_1164;

ENTITY OHEnable IS
	PORT (
				addr			: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
				enable			: IN STD_LOGIC;
				enables			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behavioral OF OHDecoder IS
	-- COMPONENT DFF_pos IS
	-- PORT ( 	
				-- D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				-- clk, res 		: IN STD_LOGIC;
				-- Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				-- enable			: IN STD_LOGIC
			-- ) ;
	-- END COMPONENT;
	
BEGIN

	PROCESS(addr, enable)
	BEGIN
		if (enable = '0') then
			enables <= x"0000";
		else
			case (addr) is
				when "0000" => enables <= x"000" & "0001";
				when "0001" => enables <= x"000" & "0010";
				when "0010" => enables <= x"000" & "0100";
				when "0011" => enables <= x"000" & "1000";
				when "0100" => enables <= x"00" & "0001" & x"0";
				when "0101" => enables <= x"00" & "0010" & x"0";
				when "0110" => enables <= x"00" & "0100" & x"0";
				when "0111" => enables <= x"00" & "1000" & x"0";
				when "1000" => enables <= x"0" & "0001" & x"00";
				when "1001" => enables <= x"0" & "0010" & x"00";
				when "1010" => enables <= x"0" & "0100" & x"00";
				when "1011" => enables <= x"0" & "1000" & x"00";
				when "1100" => enables <= "0001" & x"000";
				when "1101" => enables <= "0010" & x"000";
				when "1110" => enables <= "0100" & x"000";
				when "1111" => enables <= "1000" & x"000";
			END CASE;
		end if;
	END PROCESS;
END behavioral;