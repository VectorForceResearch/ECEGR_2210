---------------------------------------------------
-- HW 04 Problem 1 - counter_with_sharedvar
-- Author: Jim Lynch
-- Date:   02.05.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_with_sharedvar IS
    GENERIC(n: INTEGER := 7);
    PORT( clk: IN STD_LOGIC;
        enable: IN STD_LOGIC;
        data_in: IN std_logic_vector(n DOWNTO 0);
	    data_out: OUT std_logic_vector(n DOWNTO 0) );
END ENTITY counter_with_sharedvar;
---------------------------------------------------
ARCHITECTURE counter OF counter_with_sharedvar IS
    SIGNAL internal_data: std_logic_vector(n DOWNTO 0);
BEGIN
    -----------------------------------------------
    proc1: PROCESS (clk)	
    BEGIN
        IF (rising_edge(clk)) THEN
            internal_data <= data_in;
        END IF;
    END PROCESS proc1;
    -----------------------------------------------
    proc2: PROCESS (enable)
	BEGIN
        CASE enable IS
            WHEN '0' => data_out <= "ZZZZZZZZ";
            WHEN '1' => data_out <= internal_data;
            WHEN OTHERS => data_out <= "ZZZZZZZZ";
        END CASE;
    END PROCESS proc2;
END ARCHITECTURE counter;
