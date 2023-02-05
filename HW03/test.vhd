----------------------------------------------------------------
-- HW 03 Problem 1 - Test
-- Author: Jim Lynch
-- Date:   01.28.2023
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
  PORT( d, clk, rst: IN BIT;
		q: OUT BIT );
END ENTITY test;
---------------------------------------------------
ARCHITECTURE circuit OF test IS
BEGIN
    PROCESS (d, clk, rst)
	BEGIN
        IF (rst ='1') THEN
            q <= '0'; 
        ELSIF (clk = '1') THEN
            q <= d; 
        END IF;
    END PROCESS;
END ARCHITECTURE circuit;

ARCHITECTURE circuit OF test IS
BEGIN
    PROCESS (clk)
	BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (rst = '1') THEN
                q <= '0'; 
            ELSE
                q <= d;        
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE circuit;

ARCHITECTURE circuit OF test IS
BEGIN
    PROCESS (clk)
	BEGIN
        IF (clk = '1') THEN
            IF (rst = '1') THEN
                q <= '0'; 
            ELSE
                q <= d;        
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE circuit;

