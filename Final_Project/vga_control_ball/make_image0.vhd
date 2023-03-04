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
use ieee.numeric_std.all;
------------------------------------------------------------------
entity make_image0 is
	port(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0) ;
		red_switch, green_switch, blue_switch: in std_logic) ;
end;


entity font_rom is port(
clk: in std_logic;
addr: in std_logic_vector(10 downto 0); data: out std_logic_vector(7 downto 0)
);
end font_rom;
		


architecture myimage of make_image0 is
	-- Boarder --
	SIGNAL boarder_on: 		STD_LOGIC;
	SIGNAL boarder_y_pos: 	integer range 0 to 480; 
	SIGNAL boarder_x_pos:   integer range 0 to 640;

	-- Boundaries --
	CONSTANT bottom_of_screen: integer := 460;
	CONSTANT top_of_screen: integer := 19;
	CONSTANT right_of_screen: integer := 620;
	CONSTANT left_of_screen: integer := 19;

	-- Digit Placement --
	--CONSTANT bottom_of_screen: integer := 460;
	--CONSTANT top_of_screen: integer := 19;
	--CONSTANT right_of_screen: integer := 620;
	--CONSTANT left_of_screen: integer := 19;

	-- Digit Design --
	--TYPE digit6x8 IS ARRAY (1 TO 8, 1 TO 6) OF STD_LOGIC;
	--TYPE digit8x16 IS ARRAY (1 TO 16, 1 TO 8) OF STD_LOGIC;
	TYPE digit8x16 IS ARRAY (0 TO 8) OF STD_LOGIC_VECOR(0 TO 15);
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

	SIGNAL images: STD_LOGIC_VECTOR(3 DOWNTO 0);
	-- Paddle --
	SIGNAL paddle_on: 		STD_LOGIC;
	SIGNAL paddle_size: 	integer range 0 to 20;   
	SIGNAL paddle_y_motion: integer range -10 to 10; 
	SIGNAL paddle_x_motion: integer range -10 to 10; 
	SIGNAL paddle_y_pos: 	integer range 0 to 480; 
	SIGNAL paddle_x_pos:    integer range 0 to 640; 
	-- BALL --
	SIGNAL ball_on: 		STD_LOGIC;
	SIGNAL ball_size : 		integer range 0 to 20;   
	SIGNAL ball_y_motion: 	integer range -10 to 10; 
	SIGNAL ball_x_motion: 	integer range -10 to 10; 
	SIGNAL ball_y_pos: 	 	integer range 0 to 480; 
	SIGNAL ball_x_pos:    	integer range 0 to 640; 
	-- Solid Squard --
	SIGNAL solid_square_on: 		STD_LOGIC;
	SIGNAL solid_square_size : 		integer range 0 to 10;   
	SIGNAL solid_square_y_motion: 	integer range -10 to 10; 
	SIGNAL solid_square_x_motion: 	integer range -10 to 10; 
	SIGNAL solid_square_y_pos: 	 	integer range 0 to 480; 
	SIGNAL solid_square_x_pos:    	integer range 0 to 640; 
	-- Boxed Square --
	SIGNAL boxed_square_on: 		STD_LOGIC;
	SIGNAL boxed_square_size : 		integer range 0 to 20;   
	SIGNAL boxed_square_y_motion: 	integer range -10 to 10; 
	SIGNAL boxed_square_x_motion: 	integer range -10 to 10; 
	SIGNAL boxed_square_y_pos: 	 	integer range 0 to 480; 
	SIGNAL boxed_square_x_pos:    	integer range 0 to 640; 

	TYPE my_rom IS ARRAY (0 TO 5) OF STD_LOGIC_VECTOR (0 TO 60);
	CONSTANT paddle_shape: my_rom :=( "1111111111111111111111111111111111111111111111111111111111111",
									"1111111111111111111111111111111111111111111111111111111111111",
									"1111111111111111111111111111111111111111111111111111111111111",
									"1111111111111111111111111111111111111111111111111111111111111",
									"1111111111111111111111111111111111111111111111111111111111111",
									"1111111111111111111111111111111111111111111111111111111111111" );
												
	TYPE my_rom IS ARRAY (0 TO 10) OF STD_LOGIC_VECTOR (0 TO 10);
	CONSTANT solid_square_shape: my_rom :=( "11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111" );
	CONSTANT boxed_square_shape: my_rom :=( "11111111111",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"10000000001",
									"11111111111" );
	
BEGIN
	solid_square_size	<= solid_square_shape'length-1; --size of solid square
	boxed_square_size 	<= solid_square_shape'length-1; --size of boxed square
	paddle_y_pos 		<= bottom_of_screen + paddle_shape / 2;   -- x position of ball's left top corner 


	--ball_x_pos <= 320;   -- x position of ball's left top corner 
	-- x position of the square goes from (ball_x_pos) to (ball_x_pos + size)
	-- y position of the square goes from (ball_y_pos) to (ball_y_pos + size)
------------------------------------
	--check if pixel scanned in located within the square ball
	check_pixel_boarder: PROCESS (pixel_column, pixel_row)
   	BEGIN	                                
		IF (pixel_column > right_of_screen AND pixel_column <= 639) or (pixel_column < left_of_screen AND pixel_column >= 0) or  
 	   	(pixel_row < top_of_screen AND pixel_row >= 0) or (pixel_row > bottom_of_screen AND pixel_row <= 479)  
      THEN
			boarder_on <= '1';						
 		ELSE
			boarder_on <= '0';
		END IF;
	END PROCESS;
------------------------------------
	--check if pixel scanned in located within the square ball
	check_pixel_ball:  PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
   	BEGIN	                                
		IF (pixel_column >= ball_x_pos) 
			AND (pixel_column <= ball_x_pos + size) 
			AND  (pixel_row >= ball_y_pos) 
			AND (pixel_row <= ball_y_pos + size) THEN					
			ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
 		ELSE
			ball_on <= '0';
		END IF;
		IF (pixel_column >= ball_x_pos) 
			AND (pixel_column <= ball_x_pos + size) 
			AND  (pixel_row >= ball_y_pos) 
			AND (pixel_row <= ball_y_pos + size) THEN					
			ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
	 	ELSE
			ball_on <= '0';
		END IF;
	END PROCESS;
--------------------------------
		--check if pixel scanned in located within the square ball
	check_pixel_paddle:  PROCESS (paddle_x_pos, paddle_y_pos, pixel_column, pixel_row, paddle_size)
   	BEGIN	                                
		IF (pixel_column >= paddle_x_pos) AND (pixel_column <= paddle_x_pos + size) AND  
 	   	(pixel_row >= paddle_y_pos) AND (pixel_row <= paddle_y_pos + size)  
      THEN					
			paddle_on <= square_shape(pixel_row - paddle_y_pos)(pixel_column - paddle_x_pos);
 		ELSE
			paddle_on <= '0';
		END IF;
		paddle_x_pos <= 50;
		paddle_y_pos <= 220;
	END PROCESS;
--------------------------------	
	--check if pixel scanned in located within the square ball
--	check_pixel:  PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
--   BEGIN	                                
--		IF (pixel_column >= ball_x_pos) AND (pixel_column <= ball_x_pos + size) AND  
-- 	   	(pixel_row >= ball_y_pos) AND (pixel_row <= ball_y_pos + size)  
--      THEN
--			ball_on <= '1';						
-- 		ELSE
--			ball_on <= '0';
--		END IF;
--	END PROCESS;
--------------------------------	
--	setcolor:  PROCESS (ball_on)
--	BEGIN
--		CASE ball_on IS
--			WHEN '1' =>
--				red <=  (OTHERS => '1');  -- make the ball red
--				green <= (OTHERS => '0'); -- turn off green when displaying ball
--				blue  <= (OTHERS => '0'); -- turn off blue when displaying ball
--			WHEN OTHERS =>
--				red <=  (OTHERS => '1');  -- the background will be white (all colors set to 1 makes white)
--				green <= (OTHERS => '1');
--				blue  <= (OTHERS => '1');			
--		END CASE;
	images <= ball_on & boarder_on & paddle_on; --images is a signal you declare in the architecture
	setcolor: PROCESS (images)
	BEGIN
		CASE images IS
			WHEN "100" =>
				red <= (OTHERS => '1'); -- make the ball red
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			WHEN "010" =>
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '1'); -- make the wall green
				blue <= (OTHERS => '0'); 
			WHEN "001" =>
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN "101" =>
				red <= (OTHERS => '1'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN OTHERS =>
				red <= (OTHERS => '1'); -- the background will be white
				green <= (OTHERS => '1');
				blue <= (OTHERS => '1');
		END CASE;
	END PROCESS;

---------------------------------
		--update position of ball once every screen refresh cycle
	motion: PROCESS			
	BEGIN
		--MOTION: FOR i in 50 to 430 GENERATE	
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF (ball_x_pos + size) >= right_of_screen  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor  
			ball_x_motion <= -1;		
--		ELSIF (ball_x_pos + size) = (paddle_x_pos + paddle_size - 10)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor  
--			ball_x_motion <= 1;				-- start moving up by 1 pixel
		ELSIF 
			(ball_x_pos + size) <= left_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_x_motion <= 8;                         -- start moving down by 1 pixel
		ELSIF 
			(ball_y_pos + size) <= top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_y_motion <= 8; 		
		ELSIF 
			(ball_y_pos + size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_y_motion <= -1; 			
		END IF;
		
		ball_x_pos <= ball_x_pos + ball_x_motion;
		ball_y_pos <= ball_y_pos + ball_y_motion;
	END PROCESS;
	
--	
--	paddle_motion: PROCESS			
--	BEGIN
--		--MOTION: FOR i in 50 to 430 GENERATE	
--		WAIT UNTIL (vsync'event AND vsync = '1');		         		
--		IF (ball_x_pos + size) >= right_of_screen  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor  
--			ball_x_motion <= 0;		
--		ELSIF (ball_x_pos + size) = (paddle_x_pos + paddle_size - 10)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor  
--			ball_x_motion <= 0;				-- start moving up by 1 pixel
--		ELSIF 
--			(ball_x_pos + size) <= left_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--			paddle_x_motion <= 0;                         -- start moving down by 1 pixel
--		ELSIF 
--			(paddle_y_pos + size) <= top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--			paddle_y_motion <= 0; 		
--		ELSIF 
--			(paddle_y_pos + size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--			paddle_y_motion <= 0; 			
--		END IF;
--		
--		ball_x_pos <= ball_x_pos + paddle_x_motion;
--		ball_y_pos <= ball_y_pos + paddle_y_motion;
--	END PROCESS;

END;








--architecture image of make_image0 is
--BEGIN 
--	stripes: PROCESS(pixel_row, red_switch, green_switch, blue_switch)		
--	BEGIN	
--	CASE pixel_column IS  --pixel_row
--	WHEN 420 TO 480 =>
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '0');
--	WHEN 360 TO 419 =>	
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--	WHEN 300 TO 359 =>	
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 
--	WHEN 240 TO 299 =>	
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--	WHEN 180 TO 239 =>	
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '1'); 				
--	WHEN 120 TO 179 => 	
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 						
--	WHEN 60 TO 119 => 
--				red  <=  "11101101";  
--				green <= "10111001";
--				blue  <= "01101111"; 				
--	WHEN OTHERS  => 
--				red   <= (7 => red_switch, others => '0');  
--				green <= (7 => green_switch, others => '0'); 
--				blue  <= (7 => blue_switch, others => '0'); 
--	END CASE;	
--	END PROCESS stripes;
--END;
	
-- same as above but using the IF statement
--		IF pixel_row >= 420 THEN	      			
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 360 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 300 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 
--		ELSIF pixel_row >= 240 THEN
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 180 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '1'); 				
--		ELSIF pixel_row >= 120 THEN
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 						
--		ELSIF pixel_row >= 60 THEN
--				red  <=  "11101101";  
--				green <= "10111001";
--				blue  <= "01101111"; 				
--		ELSE 
--				red   <= (7 => red_switch, others => '0');  
--				green <= (7 => green_switch, others => '0'); 
--				blue  <= (7 => blue_switch, others => '0'); 
--		END IF;

