LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Green light / top : 0001000
-- Amber light / mid : 1000000
-- Red   light / bot : 0000001

ENTITY Light_Concatenation IS PORT (
    blink                      : IN std_logic;
	NS_g, NS_a, NS_r           : IN std_logic;
	EW_g, EW_a, EW_r           : IN std_logic;
	state_num                  : IN std_logic_vector(3 downto 0);
	NS_lights_out, EW_lights_out 	: OUT std_logic_vector(6 downto 0)
); 
END Light_Concatenation;

ARCHITECTURE OUTPUT_SELECTOR OF Light_Concatenation IS
BEGIN
    NS_Light_Section: PROCESS (state_num) 
    BEGIN
        CASE state_num IS
            WHEN "0000" => -- state 0
                NS_lights_out <= "000" & blink & "000";
            WHEN "0001" => -- state 1
                NS_lights_out <= "000" & blink & "000";
            WHEN OTHERS =>
                NS_lights_out <= NS_a & "00" & NS_g & "00" & NS_r;
        END CASE;
    END PROCESS;

    EW_Light_Section: PROCESS (state_num) 
    BEGIN
        CASE state_num IS
            WHEN "1000" => -- state 8
                EW_lights_out <= "000" & blink & "000";
            WHEN "1001" => -- state 9
                EW_lights_out <= "000" & blink & "000";
            WHEN OTHERS =>
                EW_lights_out <= EW_a & "00" & EW_g & "00" & EW_r;
                END CASE;
    END PROCESS;
END OUTPUT_SELECTOR;