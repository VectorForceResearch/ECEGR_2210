---------------------------------------------------
-- HW 04 Problem 1 - counter_with_sharedvar
-- Author: Jim Lynch
-- Date:   02.05.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_with_sharedvar IS
  PORT( clk: IN BIT;
		digit1, digit2: OUT INTEGER RANGE 0 TO 9);
END ENTITY counter_with_sharedvar;
---------------------------------------------------
ARCHITECTURE counter OF counter_with_sharedvar IS
    SHARED VARIABLE temp1, temp2: INTEGER RANGE 0 TO 9;
BEGIN
    -----------------------------------------------
    proc1: PROCESS (clk)	
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (temp1 = 9) THEN
                temp1 := 0;
            ELSE
                temp1 := temp1 + 1;
            END IF;
        END IF;
    END PROCESS proc1;
    -----------------------------------------------
    proc2: PROCESS (clk)
	BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (temp1 = 9) THEN
                IF (temp2 = 9) THEN
                    temp2 := 0;
                ELSE
                    temp2 := temp2 + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS proc2;
    -----------------------------------------------
    digit1 <= temp1;
    digit2 <= temp2;
END ARCHITECTURE counter;


Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_with_sharedvar IS
    GENERIC(n: INTEGGER := 7);
    PORT( clk: IN BIT;
	    digit1, digit2: OUT std_logic_vector(n+1 DOWNTO 0) );
END ENTITY counter;
---------------------------------------------------
ARCHITECTURE counter OF counter_with_sharedvar IS
    SIGNAL internal_data: std_logic_vector(n+1 DOWNTO 0);
    SHARED VARIABLE temp1, temp2: std_logic_vector(n+1 DOWNTO 0);
BEGIN
    -----------------------------------------------
    proc1: PROCESS (clk)
    PROCESS (clk)	
    BEGIN
        IF (rising_edge(clk)) THEN
            internal_data <= data_in;
            temp1 <= temp1 + 1;
            IF (temp1 = 9) THEN
                temp1 <= 0;
            END IF;
        END IF;
        digit1 <= temp1;
    END PROCESS proc1;
    -----------------------------------------------
    proc2: PROCESS (clk)
        VARIABLE data_in: std_logic_vector(n+1 DOWNTO 0);
	BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            temp2 <= temp2 + 1;
            IF (temp2 = 9) THEN
                temp2 := 0;
            END IF;
        END IF;
        digit2 <= temp2;
    END PROCESS proc2;
END ARCHITECTURE counter;

