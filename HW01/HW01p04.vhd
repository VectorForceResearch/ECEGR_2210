----------------------------------------------------------------
--
-- HW 01 Problem 4 - Priority Encoder
-- 
-- Author: Jim Lynch
-- Date:   01.15.2023
--
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
  PORT( d: IN INTEGER RANGE 0 to 127;
		y: OUT std_logic_vector(2 DOWNTO 0) );
END ENTITY priority_encoder;

ARCHITECTURE encoding OF priority_encoder IS
  BEGIN
    WITH d SELECT
	  y <= "000" WHEN 0,
           "001" WHEN 1,
           "010" WHEN 2 to 3,
           "011" WHEN 4 to 7,
           "100" WHEN 8 to 15
           "101" WHEN 16 to 31
           "110" WHEN 32 to 63
           "111" WHEN 64 to 127;
END ARCHITECTURE encoding;