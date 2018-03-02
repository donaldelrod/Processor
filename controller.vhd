library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;

ENTITY controller IS
			PORT (
				clk			: IN STD_LOGIC;	--clock
				rxo, ryo		: OUT STD_LOGIC;	--signals to tell registers to output
				rxi, ryi		: OUT STD_LOGIC;	--signals to tell registers to input
				ai, ao, go, gi		: OUT STD_LOGIC;	--signals to tell registers to in/output
				w			: IN STD_LOGIC;
				f_in			: IN STD_LOGIC_VECTOR(26 DOWNTO 0); --instructions and data from RAM
				done			: OUT STD_LOGIC;	--output signal that goes high on completion of operation
				addout			: OUT STD_LOGIC;	--signal that tells the addersub what to do
				ramout			: OUT STD_LOGIC		--signal that tells ram to stop outputting		
			);
			
END controller;

ARCHITECTURE behavioral OF controller IS

--signal funct	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
--signal regno		: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal regaddr1		: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal regaddr2		: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal currentstate	: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal f		: STD_LOGIC_VECTOR(26 DOWNTO 0);
boolean finished;


BEGIN
	
	PROCESS(clk)
	BEGIN
		if (finished = true) then 			
			--turn off all tristate buffers
			rxo 		<= '0';
			rxi 		<= '0';
			ryo 		<= '0';
			ryi 		<= '0';
			ai 		<= '0';
			ao 		<= '0';
			gi 		<= '0';
			go 		<= '0';
			w 		<= '0';
			ramout		<= '0';
			--dont chage addout because this will cause it to try and add/subtract
			
			--send done signal to RAM so RAM sends the next instruction set with the data
			done 		<= '1';
			
			
			if (currentstate = "000") then
				ramout <= '1';
				f <= f_in;
				finished = false;
				done <= '0';
				ramout <= '0';
			end if;
			currentstate 	<= "000"
		else 
		
		
			case f(26 DOWNTO 24) is  --instruction code id f(26 downto 24)
				when "000"	=> --load
					--set the input register to receive data
					regaddr1 <= f(23 DOWNTO 20);
					ramout <= '1';
					--maybe use case statement
					case regaddr1 is
						when "0001" => --register 1, Rx
							rxi <= '1';
						when "0010" => --register 2, Ry
							ryi <= '1';
					end case;
					finished = true;
				
				--finished(except for maybe registers)
				when "001"	=> --move
					--set the to and from registers, and send the data from
					--register y to the bus and set register x to receive
					
					regaddr1 <= f(23 DOWNTO 20);
					regaddr2 <= f(19 DOWNTO 16);
					
					if (regaddr1 = "0001" AND regaddr2 = "0010") then					
						ryo <= '1';
						rxi <= '1';
					else if (regaddr1 = "0010" AND regaddr2 = "0001") then
						rxo <= '1';
						ryi <= '1';
					end if;
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
					
							rxo <= '1'; 		--lets rx output
							ai <= '1';  		--lets a input
						when "001" =>							--state 2 of add
							--stop the output of rx and input of a, and set output of
							--ry and the output of a to the adder, and tells the adder to add
							rxo <= '0'; 		--stops rx from outputting
							ai <= '0';  		--stops a from inputting
					
							ryo <= '1';			--lets ry output
							ao <= '1'  			--lets a output
							
							gi <= '1';			--lets G receive input
							
							addout <= '0';		--tells the adder to add the numbers
							
						when "010" =>							--state 3 of add
							--send the adder a signal to add, and set G to receive input
							gi <= '0';
							ryo <= '0';
							ao <= '0';
							go <= '1';
							rxi <= '1';
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
							regaddr1 <= f(23 DOWNTO 20);
							regaddr2 <= f(19 DOWNTO 16);
					
							rxo <= '1'; 		--lets rx output
							ai <= '1';  		--lets a input
						when "001" =>							--state 2 of subtract
							--stop the output of rx and input of a, and set output of
							--ry and the output of a to the adder, and tells the adder to add
							rxo <= '0'; 		--stops rx from outputting
							ai <= '0';  		--stops a from inputting
					
							ryo <= '1';			--lets ry output
							ao <= '1'  			--lets a output
								
							gi <= '1';			--lets G receive input
								
							addout <= '1';		--tells the adder to subtract the numbers
								
						when "010" =>							--state 3 of subtract
							gi <= '0';
							ryo <= '0';
							ao <= '0';
							go <= '1';
							rxi <= '1';
							finished = true;
						when others =>
							finished = true;
					end case;
				when "100"  => --xor
						
					case currentstate is
						when "000" =>
								
					when others =>
						--something
			
				
			END CASE;
	END PROCESS;
END behavioral;
