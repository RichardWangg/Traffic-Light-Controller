LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sevenSegCtrl IS PORT
	(
		blnk					: in std_logic;
		ns_state 			: in std_logic_vector(1 DOWNTO 0);
		dout 					: out std_logic_vector(6 DOWNTO 0)
	);
END sevenSegCtrl;

ARCHITECTURE Circuit OF sevenSegCtrl IS
	
	signal tmp 			: std_logic_vector(6 DOWNTO 0);
	
BEGIN


WITH ns_state SELECT
		tmp(6 DOWNTO 0) <=		"0001000" when "01",    -- d if state 01 - gsolid
										"1000000" when "10",	   -- g if state 10 - asolid
										"0000001" when "11",	 	-- a if state 11 - rsolid
										"1111111" when others;


blnker: PROCESS (ns_state) -- process updates as the state changes
BEGIN
	IF (ns_state = "00") THEN
		-- blinker logic
		IF (rising_edge(blnk)) THEN
			dout <= "0001000";
		ELSE 
			dout <= "0000000";
		END IF;
	ELSE
		dout <= tmp;
	END IF;
END PROCESS;

END architecture circuit;
