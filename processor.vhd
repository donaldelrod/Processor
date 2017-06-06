library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;


ENTITY processor IS
			PORT (
									
			);
			
END processor;

ARCHITECTURE behavioral OF processor IS





BEGIN
		COMPONENT tsb
				PORT (
						D			: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
						enable	: IN STD_LOGIC;
						Q			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
				);
		END COMPONENT;
		
		COMPONENT addersub
			PORT (
						instr		: IN STD_LOGIC;
						a, b		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
						dataout	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
						overflow	: OUT STD_LOGIC
			);
		END COMPONENT;
		
		COMPONENT DFF_pos
			PORT ( 	
					D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					clk, res 		: IN STD_LOGIC;
					Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
					enable			: IN STD_LOGIC
			);
		END COMPONENT;