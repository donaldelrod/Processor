library IEEE;
use IEEE.std_logic_1164;
use IEEE.std_logic_unsigned;


ENTITY processor IS
			PORT (
					bus				: INOUT STD_LOGIC_VECTOR(26 DOWNTO 0);
					clk				: IN STD_LOGIC;
					res				: IN STD_LOGIC
			);
			
END processor;

ARCHITECTURE behavioral OF processor IS

		type regtsb is ARRAY (15 downto 0) of std_logic_vector(15 DOWNTO 0);

		COMPONENT tsb
		GENERIC (N : INTEGER := 15)
				PORT (
						D			: IN STD_LOGIC_VECTOR(N DOWNTO 0);
						enable		: IN STD_LOGIC;
						Q			: OUT STD_LOGIC_VECTOR(N DOWNTO 0)
				);
		END COMPONENT;
		
		COMPONENT addersub
			PORT (
						instr		: IN STD_LOGIC;
						a, b		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
						dataout	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
						overflow	: OUT STD_LOGIC
			);
		END COMPONENT;
		
		COMPONENT DFF_pos
			PORT ( 	
					D					: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
					clk, res 			: IN STD_LOGIC;
					Q					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
					enable				: IN STD_LOGIC
			);
		END COMPONENT;
		
		COMPONENT OHEnable
			PORT (
				addr					: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
				enable					: IN STD_LOGIC;
				enables					: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
		END COMPONENT;
		
		COMPONENT controller
			PORT (
						clk					: IN STD_LOGIC;						--clock
						ai, ao, go, gi		: OUT STD_LOGIC;					--signals to tell registers to in/output
						f_in				: IN STD_LOGIC_VECTOR(26 DOWNTO 0); --instructions and data from RAM
						done				: OUT STD_LOGIC;					--output signal that goes high on completion of operation
						addout				: OUT STD_LOGIC;					--signal that tells the addersub what to do
						ramout				: OUT STD_LOGIC;					--signal that tells ram to stop outputting
						regin				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
						tsbout				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
						regenable			: OUT STD_LOGIC;
						tsbenable			: OUT STD_LOGIC
			);	
		END COMPONENT;
		
		COMPONENT ram
			GENERIC (S,N : INTEGER:= 32);
			PORT (
						clock				: IN STD_LOGIC;
						data				: IN STD_LOGIC_VECTOR(26 DOWNTO 0);
						write_addr			: in std_logic_vector(N-1 DOWNTO 0);
						read_addr			: in std_logic_vecotr(N-1 DOWNTO 0);
						write_enable		: in std_logic;
						Q					: out std_logic_vector(26 DOWNTO 0)
			);
		END COMPONENT;
		
		COMPONENT progcounter
			PORT (		
						D					: IN STD_LOGIC;
						clk, res 			: IN STD_LOGIC;
						Q					: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
		END COMPONENT;
	
END;
		
		
		
		
		--one hot buffer signals
		signal reg_enable_sig			: STD_LOGIC;
		signal tsb_enable_sig			: STD_LOGIC;
		signal reg_select_sig			: STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal tsb_out_sig				: STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		--controller signals
		signal reg_addr					: STD_LOGIC_VECTOR(3 DOWNTO 0);
		signal addout_sig				: STD_LOGIC;
		signal ramout_sig				: STD_LOGIC;
		signal done_sig					: STD_LOGIC;
		signal aisig,aosig,gosig,gisig	: STD_LOGIC;
		signal clk_sig					: STD_LOGIC;
		signal res_sig					: STD_LOGIC;
		signal tsb_addr					: STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		signal reg_to_tsb				: regtsb;
		
		signal g_to_tsb					: STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		signal adder_to_g				: STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		signal a_to_adder				: STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		signal overflow					: STD_LOGIC;
		
		--ram signals
		signal ram_write_addr			: STD_LOGIC_VECTOR(3 DOWNTO 0);
		signal ram_read_addr			: STD_LOGIC_VECTOR(3 DOWNTO 0);
		signal ram_to_tsb				: STD_LOGIC_VECTOR(26 DOWNTO 0);
		
		
BEGIN
	
	--tri state buffers for registers 0-15
	reg_tsbs:
		for i in 0 to 15 GENERATE
			reg_tsb: tsb PORT MAP (
					D				<= reg_to_tsb(i),
					enable			<= tsb_out_sig(i),
					Q				<= bus(15 DOWNTO 0)
			);
	END GENERATE;
	
	--tri state buffer for register g
	g_tsb:tsb PORT MAP (
					D				<= g_to_tsb,
					enable			<= gosig,
					Q				<= bus(15 DOWNTO 0)
	);
	
	--tri state buffer for ram
	ram_tsb:tsb GENERIC MAP (N => 26) PORT MAP (
					D				<= ram_to_tsb,
					enable			<= ramout_sig,
					Q				<= bus(26 DOWNTO 0)
	);
					
	--registers r0-r15
	registers:
		for i in 0 to 15 GENERATE
			reg: DFF_pos PORT MAP (
					D				<= bus(15 DOWNTO 0),
					clk				<= clk_sig,
					res				<= res_sig,
					enable			<= reg_select_sig(i),
					Q				<= reg_to_tsb(i)
			);
	END GENERATE;
	
	
	--register a
	reg_a: DFF_pos PORT MAP (
					D				<= bus(15 DOWNTO 0),
					clk				<= clk_sig,
					res				<= res_sig,
					enable			<= aisig,
					Q				<= a_to_adder
	);
	
	--register g
	reg_g: DFF_pos PORT MAP (
					D				<= adder_to_g,
					clk				<= clk_sig,
					res				<= res_sig,
					enable			<= gisig,
					Q				<= g_to_tsb
	);
	
	--encoder for setting register inputs
	regencoder: OHEnable PORT MAP (
						addr		<= reg_addr,
						enable		<= reg_enable_sig,
						enables		<= reg_select_sig
	);
	
	--encoder for setting tri state buffer outputs
	tsbencoder: OHEnable PORT MAP (
						addr		<= tsb_addr,
						enable		<= tsb_enable_sig,
						enables		<= tsb_out_sig
	);
	
	--adder and subtracter 
	addsub: addersub PORT MAP (
						instr		<= addout_sig,
						a 			<= a_to_adder,
						b			<= bus(15 DOWNTO 0),
						dataout		<= adder_to_g,
						overflow	<= overflow
	);
	
	overlord:controller PORT MAP (
						clk			<= clk_sig,
						ai			<= aisig, 
						ao			<= aosig, 
						go			<= gosig, 
						gi			<= gisig,		
						f_in		<= bus,
						done		<= done_sig,
						addout		<= addout_sig,
						ramout		<= ramout_sig,
						regin		<= reg_addr,
						tsbout		<= tsb_addr,
						regenable	<= reg_enable_sig,
						tsbenable	<= tsb_enable_sig
	);
	
	memory: ram GENERIC MAP (N => 4, S => 16) PORT MAP (
						clock		<= clk_sig,
						data		<= bus,
						write_addr	<= ram_write_addr,
						read_addr	<= ram_read_addr,
						write_enable<= '0',
						Q			<= ram_to_tsb
	);
	
	program_state:progcounter PORT MAP (
						D			<= done_sig,
						clk			<= clk_sig,
						res			<= res_sig,
						Q			<= ram_read_addr
	);
	
	
	
END ENTITY;
	
	
	
	
	
	
	
	
	
	
	
	