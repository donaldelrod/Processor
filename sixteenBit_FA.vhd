LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY sixteenBit_FA IS
		PORT ( 
					a16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					b16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					cin : IN STD_Logic;
					s	 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
					-- Define inputs and outputs.
					-- You should have 2 4-bit inputs: a, b
					-- You should have 1 1-bit inputs: cin
					-- You should have 1 5-bit outputs: s
				);
END;

ARCHITECTURE behavioural of sixteenBit_FA is 
	
	signal temp_c : STD_LOGIC_VECTOR(14 DOWNTO 0);
	
	
	-- You will need any intermediate signals (c) and the component FA
	COMPONENT FA
		PORT (
					a : IN STD_Logic;
					b : IN STD_Logic;
					c_in : IN STD_Logic;
					s : OUT STD_Logic;
					c_out : OUT STD_Logic
		);
	END COMPONENT;
	
	
begin 
	
	adder1 : FA PORT MAP (
			a				=> a16(0),
			b				=> b16(0),
			c_in			=> cin,
			c_out			=>temp_c(0),
			s				=> s(0)
	);
	
	adder2 : FA PORT MAP (
			a			=> a16(1),
			b			=> b16(1),
			c_in		=> temp_c(0),
			c_out		=> temp_c(1),
			s			=> s(1)
	);
	
	adder3 : FA PORT MAP (
			a			=> a16(2),
			b			=> b16(2),
			c_in		=> temp_c(1),
			c_out		=> temp_c(2),
			s			=> s(2)
	);
	
	adder4 : FA PORT MAP (
			a			=> a16(3),
			b			=> b16(3),
			c_in		=> temp_c(2),
			c_out		=> temp_c(3),
			s			=> s(3)
	);
	
	adder5 : FA PORT MAP (
			a			=> a16(4),
			b			=> b16(4),
			c_in		=> temp_c(3),
			c_out		=> temp_c(4),
			s			=> s(4)
	);
	
	adder6 : FA PORT MAP (
			a			=> a16(5),
			b			=> b16(5),
			c_in		=> temp_c(4),
			c_out		=> temp_c(5),
			s			=> s(5)
	);
	
	adder7 : FA PORT MAP (
			a			=> a16(6),
			b			=> b16(6),
			c_in		=> temp_c(5),
			c_out		=> temp_c(6),
			s			=> s(6)
	);
	
	adder8 : FA PORT MAP (
			a			=> a16(7),
			b			=> b16(7),
			c_in		=> temp_c(6),
			c_out		=> temp_c(7),
			s			=> s(7)
	);
	
	adder9 : FA PORT MAP (
			a			=> a16(8),
			b			=> b16(8),
			c_in		=> temp_c(7),
			c_out		=> temp_c(8),
			s			=> s(8)
	);
	
	adder10 : FA PORT MAP (
			a			=> a16(9),
			b			=> b16(9),
			c_in		=> temp_c(8),
			c_out		=> temp_c(9),
			s			=> s(9)
	);
	
	adder11 : FA PORT MAP (
			a			=> a16(10),
			b			=> b16(10),
			c_in		=> temp_c(9),
			c_out		=> temp_c(10),
			s			=> s(10)
	);
	
	adder12 : FA PORT MAP (
			a			=> a16(11),
			b			=> b16(11),
			c_in		=> temp_c(10),
			c_out		=> temp_c(11),
			s			=> s(11)
	);
	
	adder13 : FA PORT MAP (
			a			=> a16(12),
			b			=> b16(12),
			c_in		=> temp_c(11),
			c_out		=> temp_c(12),
			s			=> s(12)
	);
	
	adder14 : FA PORT MAP (
			a			=> a16(13),
			b			=> b16(13),
			c_in		=> temp_c(12),
			c_out		=> temp_c(13),
			s			=> s(13)
	);
	
	adder15 : FA PORT MAP (
			a			=> a16(14),
			b			=> b16(14),
			c_in		=> temp_c(13),
			c_out		=> temp_c(14),
			s			=> s(14)
	);
	
	adder16 : FA PORT MAP (
			a			=> a16(15),
			b			=> b16(15),
			c_in		=> temp_c(14),
			c_out		=> s(16),
			s			=> s(15)
	);
	

		  
	-- You need to make multiple instances of FA and connect them up to the 
	-- inputs and carries
	
END behavioural;