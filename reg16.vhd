library ieee;
USE ieee.std_logic_1164;
USE ieee.std_logic_unsigned;

ENTITY reg16 IS
	PORT (
			clk, w		: IN STD_LOGIC;
			reset		: IN STD_LOGIC;
			input		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable		: IN STD_LOGIC;
			output		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END reg16;

ARCHITECTURE behavioral OF reg16 IS

		COMPONENT DFF_pos
				PORT (
						D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
						Clk 				: IN STD_LOGIC;
						Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
						enable				: IN STD_LOGIC
				);
		END COMPONENT;
		
BEGIN

		reg: DFF_pos PORT MAP (
				Clk					=> clk,
				D						=> input,
				
		
		
		);
		
		PROCESS(clk)
		BEGIN
			if (reset = '1') then
				output <= others => '0';
			else if (rising_edge(clk) AND enable = '1') then
				