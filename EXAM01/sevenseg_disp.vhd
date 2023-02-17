----------------------------------------------------------------
--
-- Lab 01 - Seven-Segment Decoder
-- This is the decoder VHDL for running a seven-segment display.
-- Author: Jim Lynch
-- Date:   01.10.2023
--
----------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevenseg_disp IS
	PORT( input: IN std_logic_vector(3 DOWNTO 0);
			output: OUT std_logic_vector(6 DOWNTO 0) );
END;

ARCHITECTURE encoding OF sevenseg_disp IS
	SIGNAL internal: std_logic_vector(7 DOWNTO 0);
	begin
		--WITH input SELECT
			internal <= x"40" WHEN input = x"0" ELSE
							x"79" WHEN input = x"1" ELSE
							x"24" WHEN input = x"2" ELSE
							x"30" WHEN input = x"3" ELSE
							x"19" WHEN input = x"4" ELSE
							x"12" WHEN input = x"5" ELSE
							x"02" WHEN input = x"6" ELSE
							x"78" WHEN input = x"7" ELSE
							x"00" WHEN input = x"8" ELSE
							x"18" WHEN input = x"9";
							--x"71" WHEN OTHERS;
		output <= internal(6 DOWNTO 0);
END;