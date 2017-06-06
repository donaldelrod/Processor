LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY instantiate_fourBit_FA IS
		PORT ( 
					SW		: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
					Hex1	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
					Hex0	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
					LEDR	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
					LEDG	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
				);
END;

ARCHITECTURE behavioural of instantiate_fourBit_FA is 
	
	COMPONENT fourBit_FA IS
		PORT ( 
						a4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
						b4 : IN STD_LOGIC_VECTOR(7 DOWNTO 4);
						cin4 : IN STD_Logic;
						s4 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
						-- Define inputs and outputs.
						-- You should have 2 4-bit inputs: a, b
						-- You should have 1 1-bit inputs: cin
						-- You should have 1 5-bit outputs: s
			);
			
		-- Add component declaration for fourBit_FA here
	END COMPONENT;
	
	signal lights : STD_LOGIC_VECTOR(4 DOWNTO 0);
begin 
	
	ratbag: fourBit_FA PORT MAP (
			a4		=> SW(7 DOWNTO 4),
			b4		=> SW(3 DOWNTO 0),
			s4		=> lights,
			cin4	=> SW(8)
	);
	LEDR	<= SW(8 DOWNTO 0);
	LEDG	<= lights(4 DOWNTO 0);
	-- Create an instance of fourBit_FA here.
	-- Give it a name e.g. ratbag
	-- Connect this to the switches and Hex displays
	
END behavioural;