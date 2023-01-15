----------------------------------------------------------------
--
-- HW 01 Problem 2 - Priority Encoder
-- 
-- Author: Jim Lynch
-- Date:   01.15.2023
--
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
  PORT( d: IN std_logic_vector(7 DOWNTO 1);
	    y: OUT INTEGER := 3);
END ENTITY priority_encoder;

ARCHITECTURE encoding OF priority_encoder IS
  BEGIN
	y <= 0 WHEN d = "0000000" ELSE
         1 WHEN d = "0000001" ELSE
         2 WHEN d(7 DOWNTO 2) = "000001" ELSE
         3 WHEN d(7 DOWNTO 3) = "00001" ELSE
         4 WHEN d(7 DOWNTO 4) = "0001" ELSE
         5 WHEN d(7 DOWNTO 5) = "001" ELSE
         6 WHEN d(7 DOWNTO 6) = "01" ELSE
         7 WHEN d(7 DOWNTO 7) = "1";
END ARCHITECTURE encoding;