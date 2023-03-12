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
ENTITY squares IS
	PORT(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0) ;
		red_switch, green_switch, blue_switch: in std_logic) ;
END squares;

ARCHITECTURE square_blocks OF squares IS
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
	-- SET DIGIT LOCATION --


	-- MAKE OBJECT SIZES --
	solid_square_size	<= solid_square_shape'length-1; --size of solid square
	boxed_square_size 	<= solid_square_shape'length-1; --size of boxed square

	-- SET PADDLE LOCATION --
	paddle_y_pos 		<= bottom_of_screen + paddle_shape / 2;   -- x position of ball's left top corner 


	--ball_x_pos <= 320;   -- x position of ball's left top corner 
	-- x position of the square goes from (ball_x_pos) to (ball_x_pos + size)
	-- y position of the square goes from (ball_y_pos) to (ball_y_pos + size)

------------------------------------
-- CHECK THE LOCATION OF THE OBJECTS THAT CAN CHANGE LOCATIONS --

	--BOARDER check if pixel scanned in located within the square ball
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

	--SOLID SQUARE check if pixel scanned in located within the square ball
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

	--BOXED SQUARE check if pixel scanned in located within the square ball
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
--		CAS

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


	---------------------------------
	--update position of ball once every screen refresh cycle
	SCORE: PROCESS			
	BEGIN

		
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
		
		digit_solid_U <= number_grabber(scoreSolid_U);
		digit_solid_T <= number_grabber(scoreSolid_T);
		digit_boxed_U <= number_grabber(scoreSolid_U); 
		digit_boxed_T <= number_grabber(scoreSolid_T);	 
	END PROCESS;
	
END;





