---------------------------------------------------
-- HW 04 Problem 2 - counter_with_sharedvar
-- Author: Jim Lynch
-- Date:   02.05.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_with_sharedvar IS
    GENERIC(n: INTEGGER := 7);
    PORT( clk: IN BIT;
        enable: IN BIT;
        data_in: IN std_logic_vector(n+1 DOWNTO 0)
	    data_out: OUT std_logic_vector(n+1 DOWNTO 0) );
END ENTITY counter_with_sharedvar;
---------------------------------------------------
ARCHITECTURE counter OF counter_with_sharedvar IS
    SIGNAL internal_data: std_logic_vector(n+1 DOWNTO 0);
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
        data_out <= 'Z'             WHEN enable = '0' ELSE
                    internal_data   WHEN enable = '1' ELSE
                    'Z'             WHEN OTHERS; 
        --WITH enable SELECT
        --    data_out <= 'Z'             WHEN '0',
        --                internal_data   WHEN '1',
        --                'Z'             WHEN OTHERS; 
    END PROCESS proc2;
END ARCHITECTURE counter;


force clk 0 0ns, 1 6ns -r 12ns
force enable 0 0ns, 1 21ns, 0 40ns, 1 45ns, 0 65ns, 1 86ns
force data_in 16#34 0ns, 16#FF 15ns, 16#0F 25ns, 16#11 35ns, 16#0C 47ns, 16#35 55ns, 16#00 73ns, 16#2F 81ns run 100ns