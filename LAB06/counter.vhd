---------------------------------------------------
--
-- HW 03 Problem 2 - Counter
-- 
-- Author: Jim Lynch
-- Date:   01.28.2023
--
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
  PORT( clk: IN std_logic;
		count: OUT INTEGER RANGE 0 TO 9);
END ENTITY counter;
---------------------------------------------------
ARCHITECTURE counter OF counter IS

    SIGNAL temp: INTEGER RANGE 0 TO 9;
BEGIN
    PROCESS (clk)
        -- VARIABLE temp: INTEGER RANGE 0 TO 10;
	BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (temp = 9) THEN
                temp <= 0;
            ELSE
                temp <= temp + 1;
            END IF;
        END IF;
        count <= temp;
    END PROCESS;
END ARCHITECTURE counter;


