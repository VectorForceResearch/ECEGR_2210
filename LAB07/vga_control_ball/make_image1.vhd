-- Generate the image: square ball moving up and down in the center of the screen
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity make_image1 is
	port(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0);
end;

architecture image of make_image1 is
	SIGNAL ball_on: 		STD_LOGIC;
	SIGNAL size : 			integer range 0 to 15;   
	SIGNAL ball_y_motion: integer range -10 to 10; 
	SIGNAL ball_y_pos: 	 integer range 0 to 480; 
	SIGNAL ball_x_pos:    integer range 0 to 640; 
	CONSTANT bottom_of_screen: integer := 480;
	CONSTANT top_of_screen: integer := 1;
BEGIN 
			
	size <= 8;  			--size of ball
	ball_x_pos <= 320;   -- x position of ball's left top corner 
	-- x position of the square goes from (ball_x_pos) to (ball_x_pos + size)
	-- y position of the square goes from (ball_y_pos) to (ball_y_pos + size)

------------------------------------
	--check if pixel scanned in located within the square ball
	check_pixel:  PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
   BEGIN	                                
		IF (pixel_column >= ball_x_pos) AND (pixel_column <= ball_x_pos + size) AND  
 	   	(pixel_row >= ball_y_pos) AND (pixel_row <= ball_y_pos + size)  
      THEN
			ball_on <= '1';						
 		ELSE
			ball_on <= '0';
		END IF;
	END PROCESS;
--------------------------------	
	setcolor:  PROCESS (ball_on)
	BEGIN
		CASE ball_on IS
			WHEN '1' =>
				red <=  (OTHERS => '1');  -- make the ball red
				green <= (OTHERS => '0'); -- turn off green when displaying ball
				blue  <= (OTHERS => '0'); -- turn off blue when displaying ball
			WHEN OTHERS =>
				red <=  (OTHERS => '1');  -- the background will be white (all colors set to 1 makes white)
				green <= (OTHERS => '1');
				blue  <= (OTHERS => '1');			
		END CASE;
	END PROCESS;
------------------------------------	
	--update position of ball once every screen refresh cycle
	motion: PROCESS			
	BEGIN				
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF (ball_y_pos + size) = bottom_of_screen  THEN	  --reached bottom of monitor    			
			ball_y_motion <= - 1;			                 -- start moving up by 1 pixel
		ELSIF 
			ball_y_pos = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_y_motion <= 1;                         -- start moving down by 1 pixel
		END IF;					
		ball_y_pos <= ball_y_pos + ball_y_motion;		--compute next position in the y-axis 
	END PROCESS;

END;
