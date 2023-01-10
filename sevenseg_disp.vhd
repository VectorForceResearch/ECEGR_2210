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
		WITH input SELECT
			internal <= x"40" WHEN x"0",
							x"79" WHEN x"1",
							x"24" WHEN x"2",
							x"30" WHEN x"3",
							x"19" WHEN x"4",
							x"12" WHEN x"5",
							x"02" WHEN x"6",
							x"78" WHEN x"7",
							x"00" WHEN x"8",
							x"18" WHEN x"9",
							x"71" WHEN OTHERS;
		output <= internal(6 DOWNTO 0);
END;