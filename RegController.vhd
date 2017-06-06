library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;

ENTITY RegController IS
	PORT (
			instr	: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			reg_in	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			reg_out	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk		: IN STD_LOGIC;
			res		: IN STD_LOGIC
	);
END RegController;

ARCHITECTURE Behavioral OF RegController IS

	type arr is ARRAY (15 downto 0) of std_logic_vector(15 DOWNTO 0);
	--type reg_instr is ARRAY (15 DOWNTO 0) of STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	COMPONENT DFF_pos
		PORT ( 	
			D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk, res 			: IN STD_LOGIC;
			Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable				: IN STD_LOGIC;
			reg_out				: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			tsb_enable			: IN STD_LOGIC
		);
	END COMPONENT
	
	--signal regaddr		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	--signal reg_enable	: STD_LOGIC;
	--signal tsb_enable	: STD_LOGIC;
	
	--signal reg_array	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	--signal tsb_array	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
	signal D:arr;
	signal reg_instr: STD_LOGIC_VECTOR(5 DOWNTO 0);
	--signal regs:reg_instr;
	
BEGIN

	reg_array:
		for i in 0 to 15 GENERATE
			regx: DFF_pos PORT MAP (
				D <= reg_in, 
				clk <= clk, 
				res <= res, 
				reg_out(i) <= reg_out;--D(i), 
				instr <= reg_instr,
				--enable(i) => reg_enable(i),
				regaddr <= x(i)
			);
	END GENERATE reg_array;

	PROCESS (instr)
	BEGIN
		--regaddr <= instr(5 DOWNTO 2);
		--reg_enable <= instr(1);
		--tsb_enable <= instr(0);
		
		reg_instr <= instr;
	
				
	END PROCESS;
END Behavioral;		
				
				
				
				
			
	