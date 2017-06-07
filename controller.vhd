library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;

ENTITY controller IS
			PORT (
						clk					: IN STD_LOGIC;	--clock
						ai, ao, go, gi		: OUT STD_LOGIC;	--signals to tell registers to in/output
						f_in				: IN STD_LOGIC_VECTOR(26 DOWNTO 0); --instructions and data from RAM
						done				: OUT STD_LOGIC;	--output signal that goes high on completion of operation
						addout				: OUT STD_LOGIC;	--signal that tells the addersub what to do
						ramout				: OUT STD_LOGIC;		--signal that tells ram to stop outputting
						regin				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
						tsbout				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
						regenable			: OUT STD_LOGIC;
						tsbenable			: OUT STD_LOGIC
			);
END controller;

ARCHITECTURE behavioral OF controller IS
	
signal regaddr1		: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal regaddr2		: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal currentstate	: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal f			: STD_LOGIC_VECTOR(26 DOWNTO 0);

boolean finished;


BEGIN
	
	PROCESS(clk)
	BEGIN
		if (finished = true) then 			
			--turn off all tristate buffers
			regenable 		<= '0';
			tsbenable 		<= '0';
			
			ai 				<= '0';
			ao 				<= '0';
			gi 				<= '0';
			go 				<= '0';
			
			--send done signal to RAM so RAM sends the next instruction set with the data
			done 			<= '1';
			ramout 			<= '1';
			f 				<= f_in;
			finished 		<= false;
			currentstate 	<= "000"
		else 
			done <= '0';
			ramout <= '0';
			case f(26 DOWNTO 24) is  --instruction code id f(26 downto 24)
				when "000"	=> --load
					--set the input register to receive data
						regaddr1 		<= f(23 DOWNTO 20);
						ramout 			<= '1';
						
						regenable 		<= '1';
						regin 			<= regaddr1;
						
						finished 		<= true;
				
				--finished(except for maybe registers)
				when "001"	=> --move
					--set the to and from registers, and send the data from
					--register y to the bus and set register x to receive
					
					regaddr1 <= f(23 DOWNTO 20);
					regaddr2 <= f(19 DOWNTO 16);
					
					tsbenable <= '1';
					regenable <= '1';
					
					tsbout <= regaddr2;
					regin  <= regaddr1;
					
					finished = true;
									
				when "010"	=> --add
					--takes 3 clock cycles:
					--first cycle gets the addresses to add and enables input and output
					--second cycle stops input and output, and enables second input and output
					--third cycle tells the adder what to do, and stores the data in register g
				
						case currentstate is
							when "000" =>							--state 1 of add
								--get the 2 addresses and set the output of rx and input of a
								regaddr1 <= f(23 DOWNTO 20);
								regaddr2 <= f(19 DOWNTO 16);
								
								tsbenable <= '1';
								
								
								tsbout <= regaddr1;
								ai <= '1';
								
								currentstate <= "001";
								
							when "001" =>							--state 2 of add
								--stop the output of rx and input of a, and set output of
								--ry and the output of a to the adder, and tells the adder to add
								
								
								
								--rxo <= '0'; 		--stops rx from outputting
								ai <= '0';  		--stops a from inputting
								tsbout <= regaddr2;
						
								
								gi <= '1';			--lets G receive input
								
								addout <= "00";		--tells the adder to add the numbers
								
								currentstate <= "010";
								
							when "010" =>							--state 3 of add
								gi <= '0';
								
								tsbenable <= '0';
								
								go <= '1';
								
								regenable <= '1';
								regin <= regaddr1;
								
								finished = true;
							when others =>
								finished = true;
						end case;				
						
				when "011"	=> --subtract
					--takes 3 clock cycles:
					--first cycle gets the addresses to add and enables input and output
					--second cycle stops input and output, and enables second input and output
					--third cycle tells the adder what to do, and stores the data in register g
				
						case currentstate is
							when "000" =>							--state 1 of subtract
								--get the 2 addresses and set the output of rx and input of a
								regaddr1 	<= f(23 DOWNTO 20);
								regaddr2 	<= f(19 DOWNTO 16);
						
								tsbenable 	<= '1';
								
								tsbout 		<= regaddr1;
								
								ai <= '1';  		--lets a input
								
								currentstate<= "001";
							when "001" =>							--state 2 of subtract
								--stops a from inputting
								ai 			<= '0';  		
								
								tsbout 		<= regaddr2;
								
								addout 		<= "01";		--tells the adder to subtract the numbers
								gi 			<= '1';			--lets G receive input
								
								currentstate<= "010";
								
							when "010" =>							--state 3 of subtract
								gi 			<= '0';
								
								tsbenable 	<='0';
								
								go 			<= '1';
								
								regin 		<= regaddr1;
								
								finished 	<= true;
							when others =>
								finished 	<= true;
						end case;
				when "100"  => --xor
						
						case currentstate is
							when "000" =>
								regaddr1 	<= f(23 DOWNTO 20);
								regaddr2 	<= f(19 DOWNTO 16);
								
								tsbenable 	<= '1';
								
								tsbout		<= regaddr1;
								
								ai			<= '1';
								
								currentstate<= "001"
							when "001" =>
								
								ai 			<= '0';
								
								tsbout		<= regaddr2;
								
								addout		<= "10";
								
								gi			<= '1';
								
								currentstate<= "010"
							when "010" =>
								
								gi			<= '0';
								
								tsbenable	<= '0';
								
								g0			<= '0';
								
								regin		<= regaddr1;
								
								finished	<= true;
							when others =>
								finished 	<= true;
								
				when others =>	finished <= true;
			
				
			END CASE;
	END PROCESS;
END behavioral;