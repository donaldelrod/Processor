library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;

ENTITY addersub IS
	PORT (
				instr		: IN STD_LOGIC;
				a, b		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				dataout	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				overflow	: OUT STD_LOGIC
	);
END addersub;

ARCHITECTURE behavioral OF addersub IS

	COMPONENT sixteenBit_FA 
		PORT (
					a16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					b16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					cin : IN STD_Logic;
					s	 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
		);
	END COMPONENT;
	
	signal a_adder	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal b_adder	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
	
	PROCESS(instr)
	BEGIN
		if (instr = '0') then --add
			a_adder <= a;
			b_adder <= b;
		elsif (instr= '1') then --subtract
			a_adder <= a;
			b_adder <= NOT b + 1;
		end if;
	end process;
	
	adder: sixteenBit_FA PORT MAP (
		a16					=> a_adder,
		b16					=> b_adder,
		cin					=> '0',
		s(15 DOWNTO 0)		=> dataout,
		s(16)					=> overflow
	);
	
	
END behavioral;