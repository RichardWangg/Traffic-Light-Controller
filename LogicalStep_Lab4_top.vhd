
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output PORTs here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE TOP_LEVEL_CIRCUIT OF LogicalStep_Lab4_top IS
   	COMPONENT segment7_mux PORT (
		clk 	: in  std_logic := '0';
		DIN2	: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
		DIN1 	: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
		DOUT	: out	std_logic_vector(6 downto 0);
		DIG2	: out	std_logic;
		DIG1	: out	std_logic
   	);
   	END COMPONENT;
   	COMPONENT clock_generator PORT (
		sim_mode	: in boolean;
		reset		: in std_logic;
		clkin      	: in  std_logic;
		sm_clken	: out	std_logic;
		blink		: out std_logic
  	);
   	END COMPONENT;
   	COMPONENT pb_inverters PORT (
		pb_n	: in std_logic_vector(3 downto 0);
		pb		: out std_logic_vector(3 downto 0)
  	);
   	END COMPONENT;
	COMPONENT synchronizer PORT (
		clk		: in std_logic;
		reset	: in std_logic;
		din		: in std_logic;
		dout	: out std_logic
  	);
 	END COMPONENT;
  	COMPONENT holding_register PORT (
		clk				: in std_logic;
		reset			: in std_logic;
		register_clr	: in std_logic;
		din				: in std_logic;
		dout      		: out std_logic
  	);
  	END COMPONENT;
  	COMPONENT TLC_State_Machine PORT (
		clk_input, sm_clken, reset	: IN std_logic;
		NS_button, EW_button		: IN std_logic;
		
		NS_g, NS_a, NS_r			: OUT std_logic;
		EW_g, EW_a, EW_r            : OUT std_logic;
		NS_cross, EW_cross          : OUT std_logic;
		NS_reg_clear, EW_reg_clear  : OUT std_logic;
		state_num				    : OUT std_logic_vector(3 downto 0)
	);
	END COMPONENT;
	COMPONENT Light_Concatenation PORT (
		blink			 		   		: IN std_logic;
		NS_g, NS_a, NS_r           		: IN std_logic;
		EW_g, EW_a, EW_r           		: IN std_logic;
		state_num                  		: IN std_logic_vector(3 downto 0);
		NS_lights_out, EW_lights_out 	: OUT std_logic_vector(6 downto 0)
	); 
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode		: boolean := FALSE; -- set to FALSE for LogicalStep board downloads, set to TRUE for SIMULATIONS
	SIGNAL sm_clken, blink_sig	: std_logic; 
	SIGNAL pb					: std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	SIGNAL ns_state 			: std_logic_vector(1 downto 0);
	SIGNAL seg7_right 			: std_logic_vector(6 downto 0);
	SIGNAL seg7_left  			: std_logic_vector(6 downto 0);
	SIGNAL sync_output_EW 		: std_logic;
	SIGNAL sync_output_NS       : std_logic;
	SIGNAL NS_button, EW_button : std_logic;
	SIGNAL NS_g, NS_a, NS_r		: std_logic;
	SIGNAL EW_g, EW_a, EW_r     : std_logic;
	SIGNAL NS_cross, EW_cross 	: std_logic;
	SIGNAL NS_reg_clear			: std_logic;
	SIGNAL EW_reg_clear 		: std_logic;
	SIGNAL state_num 			: std_logic_vector(3 downto 0);
	----------------------------------------------------------------------------------------------------
	BEGIN
	INST1: pb_inverters		 PORT map (pb_n, pb);
	INST2: clock_generator 	 PORT map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig);
	INST3: synchronizer		 PORT map (clkin_50, pb(3), pb(1), sync_output_EW);  -- EW Direction
	INST4: synchronizer		 PORT map (clkin_50, pb(3), pb(0), sync_output_NS);  -- NS Direction
	INST5: holding_register  PORT map (clkin_50, pb(3), EW_reg_clear, sync_output_EW, EW_button);  -- EW Direction 
	INST6: holding_register  PORT map (clkin_50, pb(3), NS_reg_clear, sync_output_NS, NS_button);  -- NS Direction

	INST7: TLC_State_Machine    PORT map (clkin_50, sm_clken, pb(3), NS_button, EW_button, NS_g, NS_a, NS_r, EW_g, EW_a, EW_r, leds(0), leds(2), NS_reg_clear, EW_reg_clear, state_num);								
	INST8: Light_Concatenation  PORT map ( blink_sig, NS_g, NS_a, NS_r, EW_g, EW_a, EW_r, state_num, seg7_right, seg7_left);

	-- Note how the bug with the actual board is known (the one where it pb(1) clears leds(1)

	-- for simulation for part A
	--leds(2) <= sm_clken; 
	--leds(0) <= blink_sig;
	leds(7 downto 4) <= state_num;
	segment7_mux_inst : segment7_mux PORT map(clkin_50, seg7_right, seg7_left, seg7_data, seg7_char2, seg7_char1);
	leds(1) <= NS_button;
	leds(3) <= EW_button;
END TOP_LEVEL_CIRCUIT;



