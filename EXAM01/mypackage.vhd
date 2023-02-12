---------------------------------------------------
-- EXAM 01 - MyPackage
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------
PACKAGE mypack IS
---------------------------------------------------
COMPONENT clock_divider
	GENERIC( n: INTEGER := 4);
	PORT( clk_in: IN STD_LOGIC;
		--clk_div: IN STD_LOGIC;
		clk_out: OUT STD_LOGIC);
END COMPONENT clock_divider;
---------------------------------------------------
COMPONENT counter
	--GENERIC( n: INTEGER := 4);
	PORT( clk: IN STD_LOGIC;
		--max_count: IN STD_LOGIC;
		count: OUT INTEGER RANGE 0 TO 9);
END COMPONENT counter;
---------------------------------------------------
COMPONENT sevenseg_disp
	PORT( input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		output: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) );
END COMPONENT sevenseg_disp;
---------------------------------------------------
END PACKAGE mypack;

