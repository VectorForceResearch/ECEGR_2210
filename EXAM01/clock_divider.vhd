---------------------------------------------------
-- EXAM 01 - Clock Divider
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------


--Creates a signal with a frequency of 1/6 of clk_in
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
------------------------------------------------
ENTITY clock_divider IS
	GENERIC (n: INTEGER := 5); -- the period will be 2n
	PORT(clk_in: IN STD_LOGIC;
	     clk_out: OUT STD_LOGIC);  
END ENTITY clock_divider;
-------------------------------------------------
ARCHITECTURE rtl OF clock_divider IS
   	SIGNAL count: INTEGER RANGE 0 TO n;  
	SIGNAL internal: STD_LOGIC:='0';
BEGIN
	PROCESS (clk_in)
	BEGIN
	 	IF (clk_in'event AND clk_in = '1') THEN
			count <= count + 1;      --initial value of count is 0
      		IF (count = n-1) THEN
				internal <= NOT internal;
				clk_out <= internal; 
  	    		count <= 0; 
			END IF;
	 	END IF;
	END PROCESS;
END ARCHITECTURE rtl;

-- library IEEE;
-- use  IEEE.STD_LOGIC_1164.all;
-- ---------------------------------------------------
-- ENTITY clock_divider IS
-- 	GENERIC (clk_div: INTEGER := 2);
-- 	PORT(clk_in: IN STD_LOGIC;
-- 		--clk_div: IN STD_LOGIC;
-- 	    clk_out: OUT STD_LOGIC);  
-- END ENTITY clock_divider;
-- ---------------------------------------------------
-- ARCHITECTURE rtl OF clock_divider IS
--    	SIGNAL count: INTEGER range 0 to clk_div;  
-- 	SIGNAL internal: STD_LOGIC:='0';
-- BEGIN
-- 	PROCESS (clk_in)
-- 	BEGIN
-- 	 	IF (clk_in'EVENT AND clk_in = '1') THEN
-- 			count <= count + 1;      --initial value of count is 0
--       		IF (count = clk_div-1) THEN
-- 				internal <= NOT internal;
-- 				clk_out <= internal; 
--   	    		count <= 0; 
-- 			END IF;
-- 	 END IF;
-- 	END PROCESS;
-- END ARCHITECTURE rtl;