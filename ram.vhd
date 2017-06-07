library IEEE;
use ieee.std_logic_1164;

ENTITY ram IS
	GENERIC (S,N : INTEGER:= 32);
	PORT (
			clock				: IN STD_LOGIC;
			data				: IN STD_LOGIC_VECTOR(26 DOWNTO 0);
			write_addr			: in std_logic_vector(N-1 DOWNTO 0);
			read_addr			: in std_logic_vecotr(N-1 DOWNTO 0);
			write_enable		: in std_logic;
			Q					: out std_logic_vector(26 DOWNTO 0)
	);
	
END;

ARCHITECTURE behavioural OF ram IS
	TYPE mem is ARRAY (S-1 DOWNTO 0) 
						of std_logic_vector(16 DOWNTO 0);
						
	FUNCTION intialise_ram RETURN mem IS
		VARIABLE result : mem;
		BEGIN
			
			result(0) := ("000" & x"0" & x"00000"); --load r0
			result(1) := ("000" & x"1" & x"00000"); --load r1
			result(2) := ("000" & x"2" & x"00000"); --load r2
			result(3) := ("000" & x"3" & x"00000"); --load r3
			result(4) := ("001" & x"0" & x"1" & x"0000"); --mov r0 r1
			result(5) := ("001" & x"0" & x"2" & x"0000"); --mov r0 r2
			result(6) := ("001" & x"0" & x"3" & x"0000"); --mov r0 r3 
			result(7) := ("010" & x"0" & x"1" & x"0000"); --add r0 r1
			result(8) := ("010" & x"0" & x"2" & x"0000"); --add r0 r2
			result(9) := ("010" & x"0" & x"3" & x"0000"); --add r0 r3
			result(10) := ("011" & x"0" & x"1" & x"0000"); --sub r0 r1
			result(11) := ("011" & x"0" & x"2" & x"0000"); --sub r0 r2
			result(12) := ("011" & x"0" & x"3" & x"0000"); --sub r0 r3
			result(13) := ("100" & x"0" & x"1" & x"0000");  --xor r0 r1
			result(14) := ("100" & x"0" & x"2" & x"0000"); --xor r0 r2
			result(15) := ("100" & x"0" & x"3" & x"0000"); --xor r0 r3
		END initialise_ram
		SIGNAL tempMem : mem;
	BEGIN 
	PROCESS(clock)
		BEGIN
		IF (clock'event AND clock = '1') THEN 
			IF(write_enable = '1') THEN
				tempMem(to_integer(unsigned(write_addr)) <= data; --write data to address
			END IF
			q <= tempMem(to_integer(unsigned(read_addr)); --read data
		END IF
	END PROCESS
	END BEHAVIOURAL 
				
				
	