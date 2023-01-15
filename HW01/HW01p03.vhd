----------------------------------------------------------------
--
-- HW 01 Problem 3 - Priority Encoder
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
    WITH d SELECT
      y <= 0 WHEN "0000000",
           1 WHEN "0000001",
           2 WHEN "0000010" to "0000011",
           3 WHEN "0000100" to "0000111",
           4 WHEN "0001000" to "0001111",
           5 WHEN "0010000" to "0011111",
           6 WHEN "0100000" to "0111111",
           7 WHEN "1000000" to "1111111";
END ARCHITECTURE encoding;