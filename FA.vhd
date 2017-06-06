LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY FA IS
		PORT ( 
					a : IN STD_Logic;
					b : IN STD_Logic;
					c_in : IN STD_Logic;
					s : OUT STD_Logic;
					c_out : OUT STD_Logic
					-- Define inputs and outputs.
					-- You should have 3 1-bit inputs: a, b, c_in
					-- You should have 2 1-bit outputs: s, c_out
				);
END;

ARCHITECTURE behavioural of FA is 

	-- You should not need any intermediate signals
	
begin 
		
		--process(a, b, c_in)
		--begin
				--if  then
				--c_out <= '0';
				c_out <= (a AND b) OR (b AND c_in) OR (a AND c_in);--'1';
				--else 
					
				--end if;
				
				--if  then
				--s <= '0';
				s <= ((not a) and b and c_in) or (a and b and (not c_in)) or (not (a and b) and c_in);--'1';
				--else	s<='0';
				--end if;
		--end process;
					
				
	-- Create logic to produce c_out and sum
	-- from a, b, c_in
	-- Hint: translate to SOP form, or use a Case statement
	
END behavioural;