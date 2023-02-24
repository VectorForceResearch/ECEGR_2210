library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.mypack.all;
---------------------
ENTITY main_entity IS
	GENERIC(	n: INTEGER := 6);
	PORT(		clock_in: STD_LOGIC;
				segment: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) );
END ENTITY main_entity;
-------------------------------------------------
ARCHITECTURE segment_controller OF main_entity IS
	SIGNAL slow_clock: STD_LOGIC;
	SIGNAL count: INTEGER RANGE 0 TO 10;
	SIGNAL count_temp: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	s1: clock_divider GENERIC MAP(n) PORT MAP (clock_in, slow_clock);
	s2: counter 	PORT MAP (slow_clock, count);
	s3: sevenseg_disp 	PORT MAP (count_temp, segment);
	count_temp <= CONV_STD_LOGIC_VECTOR(count,4);
END ARCHITECTURE segment_controller;