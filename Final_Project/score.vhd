---------------------------------------------------
-- Final Project - Game
-- Author: Jim Lynch
-- Date: 02.21.2023
---------------------------------------------------


-- Generates 8 horizontal stripes of different colors
-- 3 switches (red_switch, green_switch, blue_switch) control the 
-- color of the top horizontal stripes
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;    	-- for uniform & trunc functions
use ieee.numeric_std.all;	-- for to_unsigned functionv
------------------------------------------------------------------
ENTITY score IS
	PORT(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0) ;
		red_switch, green_switch, blue_switch: in std_logic) ;
END;

ARCHITECTURE score_display OF score IS
    -- Digit Placement --
	CONSTANT left_x: INTEGER := 60;
	CONSTANT left_y: INTEGER := 60;
	CONSTANT right_x: INTEGER := 400;
	CONSTANT right_y: INTEGER := 60;

	-- Digit Design --
	--TYPE digit6x8 IS ARRAY (1 TO 8, 1 TO 6) OF STD_LOGIC;
	--TYPE digit8x16 IS ARRAY (1 TO 16, 1 TO 8) OF STD_LOGIC;
	TYPE digit8x16 IS ARRAY (0 TO 8) OF STD_LOGIC_VECOR (0 TO 15);
	SIGNAL digit_solid_U, digit_solid_T: digit8x16;
	SIGNAL digit_boxed_U, digit_boxed_T: digit8x16;	 

	-- -- 2^7 charactors
    -- -- + 2^4 row per charactor 
    -- -- therefore the total array size is 2^11 = 2048
	-- type rom_type is array (0 to 2**11-1) of std_logic_vector(FONT_WIDTH-1 downto 0);
	-- -- ROM definition
	-- signal ROM: rom_type := (   -- 2^11-by-8

	CONSTANT zero: digit8x16 := (
	-- 0: code x30
	"00000000", -- 0
	"00000000", -- 1
	"01111100", -- 2  *****
	"11000110", -- 3 **   **
	"11000110", -- 4 **   **
	"11001110", -- 5 **  ***
	"11011110", -- 6 ** ****
	"11110110", -- 7 **** **
	"11100110", -- 8 ***  **
	"11000110", -- 9 **   **
	"11000110", -- a **   **
	"01111100", -- b  *****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f 
	);

	CONSTANT one: digit8x16 := (
	-- 1: code x31
	"00000000", -- 0
	"00000000", -- 1
	"00011000", -- 2
	"00111000", -- 3
	"01111000", -- 4    **
	"00011000", -- 5   ***
	"00011000", -- 6  ****
	"00011000", -- 7    **
	"00011000", -- 8    **
	"00011000", -- 9    **
	"00011000", -- a    **
	"01111110", -- b    **
	"00000000", -- c    **
	"00000000", -- d  ******
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT two: digit8x16 := (
	-- 2: code x32
	"00000000", -- 0
	"00000000", -- 1
	"01111100", -- 2  *****
	"11000110", -- 3 **   **
	"00000110", -- 4      **
	"00001100", -- 5     **
	"00011000", -- 6    **
	"00110000", -- 7   **
	"01100000", -- 8  **
	"11000000", -- 9 **
	"11000110", -- a **   **
	"11111110", -- b *******
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT three: digit8x16 := (
	-- 3: code x33
	"00000000", -- 0
	"00000000", -- 1
	"01111100", -- 2  *****
	"11000110", -- 3 **   **
	"00000110", -- 4      **
	"00000110", -- 5      **
	"00111100", -- 6   ****
	"00000110", -- 7      **
	"00000110", -- 8      **
	"00000110", -- 9      **
	"11000110", -- a **   **
	"01111100", -- b  *****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT four: digit8x16 := (
	-- 4: code x34
	"00000000", -- 0
	"00000000", -- 1
	"00001100", -- 2     **
	"00011100", -- 3    ***
	"00111100", -- 4   ****
	"01101100", -- 5  ** **
	"11001100", -- 6 **  **
	"11111110", -- 7 *******
	"00001100", -- 8     **
	"00001100", -- 9     **
	"00001100", -- a     **
	"00011110", -- b    ****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT five: digit8x16 := (
	-- code x35
	"00000000", -- 0
	"00000000", -- 1
	"11111110", -- 2 *******
	"11000000", -- 3 **
	"11000000", -- 4 **
	"11000000", -- 5 **
	"11111100", -- 6 ******
	"00000110", -- 7      **
	"00000110", -- 8      **
	"00000110", -- 9      **
	"11000110", -- a **   **
	"01111100", -- b  *****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT six: digit8x16 := (
	-- code x36
	"00000000", -- 0
	"00000000", -- 1
	"00111000", -- 2   ***
	"01100000", -- 3  **
	"11000000", -- 4 **
	"11000000", -- 5 **
	"11111100", -- 6 ******
	"11000110", -- 7 **   **
	"11000110", -- 8 **   **
	"11000110", -- 9 **   **
	"11000110", -- a **   **
	"01111100", -- b  *****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT seven: digit8x16 := (
	-- code x37
	"00000000", -- 0
	"00000000", -- 1
	"11111110", -- 2 *******
	"11000110", -- 3 **   **
	"00000110", -- 4      **
	"00000110", -- 5      **
	"00001100", -- 6     **
	"00011000", -- 7    **
	"00110000", -- 8   **
	"00110000", -- 9   **
	"00110000", -- a   **
	"00110000", -- b   **
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT eight: digit8x16 := (
	-- code x38
	"00000000", -- 0
	"00000000", -- 1
	"01111100", -- 2  *****
	"11000110", -- 3 **   **
	"11000110", -- 4 **   **
	"11000110", -- 5 **   **
	"01111100", -- 6  *****
	"11000110", -- 7 **   **
	"11000110", -- 8 **   **
	"11000110", -- 9 **   **
	"11000110", -- a **   **
	"01111100", -- b  *****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	CONSTANT nine: digit8x16 := (
	-- code x39
	"00000000", -- 0
	"00000000", -- 1
	"01111100", -- 2  *****
	"11000110", -- 3 **   **
	"11000110", -- 4 **   **
	"11000110", -- 5 **   **
	"01111110", -- 6  ******
	"00000110", -- 7      **
	"00000110", -- 8      **
	"00000110", -- 9      **
	"00001100", -- a     **
	"01111000", -- b  ****
	"00000000", -- c
	"00000000", -- d
	"00000000", -- e
	"00000000" -- f
	);

	FUNCTION number_grabber (SIGNAL input: INTEGER) RETURN digit8x16 IS
	BEGIN
		CASE input IS
			WHEN 0 => RETURN zero;
			WHEN 1 => RETURN one;
			WHEN 2 => RETURN two;
			WHEN 3 => RETURN three;
			WHEN 4 => RETURN four;
			WHEN 5 => RETURN five;
			WHEN 6 => RETURN six;
			WHEN 7 => RETURN seven;
			WHEN 8 => RETURN eight;
			WHEN 9 => RETURN nine;
		END CASE;
	END number_grabber;

	-- Solid SCORE --
	SIGNAL solid_score_on: 		STD_LOGIC;
	SIGNAL solid_score_size : 		integer range 0 to 10;   
	SIGNAL solid_score_y_motion: 	integer range -10 to 10; 
	SIGNAL solid_score_x_motion: 	integer range -10 to 10; 
	SIGNAL solid_score_y_pos: 	 	integer range 0 to 480; 
	SIGNAL solid_score_x_pos:    	integer range 0 to 640; 
	-- Boxed SCORE --
	SIGNAL boxed_score_on: 		STD_LOGIC;
	SIGNAL boxed_score_y_motion: 	integer range -10 to 10; 
	SIGNAL boxed_score_x_motion: 	integer range -10 to 10; 
	SIGNAL boxed_score_y_pos: 	 	integer range 0 to 480; 
	SIGNAL boxed_score_x_pos:    	integer range 0 to 640; 	

BEGIN
	-- addr register to infer block RAM
	setRegA: PROCESS (clkA)
	BEGIN
		IF rising_edge(clkA) THEN
		
			-- Write to rom
			IF(writeEnableA = '1') THEN
				ROM(to_integer(unsigned(addrA))) <= dataInA;
			END IF;
			-- Read from it
			dataOutA <= ROM(to_integer(unsigned(addrA)));

		END IF;
	END PROCESS;
END;





