----------------------------------------------------------------
--
-- HW 01 Problem 1 - Priority Encoder
-- 
-- Author: Jim Lynch
-- Date:   01.15.2023
--
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
	PORT( d: IN std_logic_vector(7 DOWNTO 1);
			  y: OUT std_logic_vector(2 DOWNTO 0) );
END ENTITY priority_encoder;

ARCHITECTURE encoding OF priority_encoder IS
	BEGIN
		y <= "111" WHEN d(7) = '1' ELSE
         "110" WHEN d(6) = '1' ELSE
         "101" WHEN d(5) = '1' ELSE
         "100" WHEN d(4) = '1' ELSE
         "011" WHEN d(3) = '1' ELSE
         "010" WHEN d(2) = '1' ELSE
         "001" WHEN d(1) = '1' ELSE
         "000";
END ARCHITECTURE encoding;