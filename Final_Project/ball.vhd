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
------------------------------------------------------------------
entity make_image0 is
	port(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0) ;
		red_switch, green_switch, blue_switch: in std_logic) ;
end;
		
architecture myimage of make_image0 is
	
	SIGNAL images: STD_LOGIC_VECTOR(2 DOWNTO 0);
	-- Boundaries --
	CONSTANT bottom_of_screen: integer := 430;
	CONSTANT top_of_screen: integer := 49;
	CONSTANT right_of_screen: integer := 590;
	CONSTANT left_of_screen: integer := 49;
	-- Boarder --
	SIGNAL boarder_on: STD_LOGIC;
	SIGNAL boarder_y_pos: 	 integer range 0 to 480; 
	SIGNAL boarder_x_pos:    integer range 0 to 640;
	-- Paddle --
	SIGNAL paddle_on: 		STD_LOGIC;
	SIGNAL paddle_size: 			integer range 0 to 20;   
	SIGNAL paddle_y_motion: integer range -10 to 10; 
	SIGNAL paddle_x_motion: integer range -10 to 10; 
	SIGNAL paddle_y_pos: 	 integer range 0 to 480; 
	SIGNAL paddle_x_pos:    integer range 0 to 640; 
	-- BALL --
	SIGNAL ball_on: 		STD_LOGIC;
	SIGNAL ball_size : 			integer range 0 to 20;   
	SIGNAL ball_y_motion: integer range -10 to 10; 
	SIGNAL ball_x_motion: integer range -10 to 10; 
	SIGNAL ball_y_pos: 	 integer range 0 to 480; 
	SIGNAL ball_x_pos:    integer range 0 to 640; 

	TYPE my_rom IS ARRAY (0 TO 20) OF STD_LOGIC_VECTOR (0 TO 20);
	CONSTANT round_shape: my_rom :=( "110000000111000000011",
									"000000001111100000000",
									"000000011111110000000",
									"000000111111111000000",
									"000001111111111100000",
									"000011111111111110000",
									"000111111111111111000",
									"001111111111111111100",
									"011111110000011111110",
									"111111111000111111111",
									"111111000000000111111",
									"111111111000111111111",
									"011111110000011111110",
									"001111111111111111100",
									"000111111111111111000",
									"000011111111111110000",
									"000001111111111100000",
									"000000111111111000000",
									"000000011111110000000",
									"000000001111100000000",
									"110000000111000000011" );
												
	TYPE my_prom IS ARRAY (0 TO 20) OF STD_LOGIC_VECTOR (0 TO 10);
	CONSTANT square_shape: my_prom :=( "11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
									"11111111111",
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
	
BEGIN
	size <= round_shape'length-1; --size of ball
	--ball_x_pos <= 320;   -- x position of ball's left top corner 
	paddle_y_pos <= 240;   -- x position of ball's left top corner 
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
	


END;




