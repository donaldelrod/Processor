LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFF_pos IS
PORT (		
			--input from the bus
			D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk, res 			: IN STD_LOGIC;
			
			--output of the register
			--the register has a built in tristate buffer;
			--it reads in the instructions and reacts accordingly
			reg_out				: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			--instruction set: the instructions include the register address, enable of register, and enable for tristate buffer
			--first 4 bits are address
			--next bit is register enable signal
			--last bit is tsb enable signal
			instr				: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			
			--enable				: IN STD_LOGIC;
			--tsb_enable			: IN STD_LOGIC;
			
			--the unique address of each register
			regaddr				: IN STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END DFF_pos ;

ARCHITECTURE Behavior OF DFF_pos IS

	COMPONENT tsb IS
	PORT (
			D			: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable		: IN STD_LOGIC;
			Q			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	END COMPONENT;
	
	--used to keep the unique address of the register
	signal addr: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--signal from the register to the built in tristate buffer
	signal Q	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal tsb_enable: STD_LOGIC;
	signal enable: STD_LOGIC;

BEGIN
	--stores the register address in each register
	addr <= regaddr;
	
	--built in tristate buffer
	outcontrol:tsb PORT MAP (
		D <= Q,					--input of tsb is output of register
		enable <= tsb_enable,		--enable for tsb is last bit of instructions
		Q <= reg_out			--output of tsb goes to the bus
	);
		

	PROCESS (clk, res)
	BEGIN
		if (rising_edge(res)) then
			Q <= others => 0;
		elsif (rising_edge(clk) AND instr(5 DOWNTO 2) = addr) then
		--if rising edge of clock,
		--the address from the instructions matches this registers address
			enable <= instr(1);
			tsb_enable <= instr(0);
			
			if enable = '1' then  --the enable part of instructions is true
				Q <= D;
		elsif (rising_edge(clk) AND tsb_enable = '1' and instr(0) = '1') 
		--something else is trying to use the bus and this register is outputting to it
			tsb_enable <= '0';
			
		end if;
	END PROCESS ;

END Behavior ;
