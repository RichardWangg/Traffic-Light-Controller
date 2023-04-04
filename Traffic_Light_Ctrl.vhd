library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Traffic_Light_Ctrl is port (

			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic_vector(1 DOWNTO 0)
);
end Traffic_Light_Ctrl;
 
architecture circuit of Traffic_Light_Ctrl is

VARIABLE cnt : unsigned(3 downto 0) := "0000";
TYPE STATE_NAMES IS (gblink, gsolid, asolid, rsolid);   -- list all the STATE_NAMES values
SIGNAL current_state, next_state	:  STATE_NAMES;
	
BEGIN
	
	update_state: PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) then
			IF (reset = '1') then
				current_state <= gblink;
				cnt := "0000";
			ELSE 
				current_state <= next_state;
				cnt := cnt + 1;
			END IF;
		END IF;
	END PROCESS;
		
		
	Transition_Section: PROCESS (current_state, cnt) 	
	BEGIN
	  CASE current_state IS
			  WHEN gblink =>		
					IF (cnt = "0001") THEN
						next_state <= gsolid;
					ELSE
						next_state <= gblink;
					END IF;

				WHEN gsolid =>		
					IF (cnt = "0101") THEN
						next_state <= asolid;
					ELSE
						next_state <= gsolid;
					END IF;					

				WHEN asolid =>		
					IF (cnt = "0111") THEN
						next_state <= rsolid;
					ELSE
						next_state <= asolid;
					END IF;					
					
				WHEN rsolid =>		
					IF (cnt = "1111") THEN
						next_state <= gblink;
					ELSE
						next_state <= rsolid;
					END IF;

					WHEN OTHERS =>
						next_state <= gblink;
						
		  END CASE;
	 END PROCESS;
	 

	Decoder_Section: PROCESS (current_state) 
	BEGIN
		  CASE current_state IS  
				WHEN gblink =>		
						dout <= "00";
				
				WHEN gsolid =>		
						dout <= "01";
				
				WHEN asolid =>		
						dout <= "10";
				
				WHEN rsolid =>		
						dout <= "11";
				
				WHEN others =>		
						dout <= "00";
		  END CASE;
	 END PROCESS;
	
	

END architecture circuit;