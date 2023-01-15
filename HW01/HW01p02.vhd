----------------------------------------------------------------
--
-- HW 01 Problem 2 - Priority Ecoder
-- 
-- Author: Jim Lynch
-- Date:   01.15.2023
--
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
  PORT( d: IN std_logic_vector(7 DOWNTO 0);
	    y: OUT INTEGER := 3);
END ENTITY priority_encoder;

ARCHITECTURE encoding OF priority_encoder IS
  BEGIN
	y <= 0 WHEN d = "0000000" else
         1 WHEN d = "0000001" else
         2 WHEN d(7 downto 2) = "000001" else
         3 WHEN d(7 downto 3) = "00001" else
         4 WHEN d(7 downto 4) = "0001" else
         5 WHEN d(7 downto 5) = "001" else
         6 WHEN d(7 downto 6) = "01" else
         7 WHEN d(7 downto 7) = "1";
END ARCHITECTURE encoding;