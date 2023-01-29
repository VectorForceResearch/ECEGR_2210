---------------------------------------------------
--
-- HW 03 Problem 4 - Counter
-- 
-- Author: Jim Lynch
-- Date:   01.28.2023
--
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
  PORT( clk: IN BIT;
		count: OUT INTEGER RANGE 0 TO 9);
END ENTITY counter;
---------------------------------------------------
ARCHITECTURE counter OF counter IS
BEGIN
    SIGNAL temp <= INTEGER RANGE 0 TO 9;
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
    END PROCESS
END ARCHITECTURE circuit;

---------------------------------------------------
ARCHITECTURE counter OF counter IS
BEGIN
    PROCESS (clk)
        VARIABLE temp: INTEGER RANGE 0 TO 10;
	BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            temp := temp + 1;
            IF (temp = 10) THEN
                temp := 0;
            END IF;
        END IF;
        count <= temp;
    END PROCESS
END ARCHITECTURE circuit;

