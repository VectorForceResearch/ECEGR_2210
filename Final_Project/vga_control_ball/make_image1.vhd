---------------------------------------------------
-- Final Project - Skull Catcher
-- Author: Caleb Villegas and Jim Lynch
-- Date:   03.10.2023
---------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity make_image1 is
port(

vsync:  in std_logic;
pixel_row:  in integer range 50 to 430;
pixel_column: in integer range 0 to 640;
push_up: in std_logic;
push_down: in std_logic;
red, green, blue: out std_logic_vector(7 downto 0);
rand_Num: in integer range 0 to 510;
rand_Num_2: in integer range 0 to 510;
rand_Num_3: in integer range 0 to 510
);
end;

architecture image of make_image1 is
    -- BOARDER --
    -- CONSTANT bottom_of_screen: INTEGER := 460;
    -- CONSTANT top_of_screen: INTEGER := 20;
    -- CONSTANT right_of_screen: INTEGER := 630;
    -- CONSTANT left_of_screen: INTEGER := 10;
	-- BOARDER --
	SIGNAL boarder_on: 		STD_LOGIC;
	SIGNAL boarder_y_pos: 	integer range 0 to 480; 
	SIGNAL boarder_x_pos:   integer range 0 to 640;
	CONSTANT bottom_of_screen: integer := 459;
	CONSTANT top_of_screen: 	integer := 20;
	CONSTANT right_of_screen: 	integer := 619;
	CONSTANT left_of_screen: 	integer := 20;
	-- BALL --
    SIGNAL ball_on: STD_LOGIC;
    SIGNAL size : INTEGER RANGE 0 TO 20;  
    SIGNAL ball_x_motion: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_motion: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_pos: INTEGER RANGE 0 TO 480;
    SIGNAL ball_x_pos: INTEGER RANGE 0 TO 640;
	-- BALL 1 --
    SIGNAL ball_on_2: STD_LOGIC;
    SIGNAL size_2 : INTEGER RANGE 0 TO 20;   
    SIGNAL ball_x_motion_2: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_motion_2: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_pos_2: INTEGER RANGE 0 TO 480;
    SIGNAL ball_x_pos_2: INTEGER RANGE 0 TO 640;
	-- BALL 2 --
    SIGNAL ball_on_3: STD_LOGIC;
    SIGNAL size_3 : INTEGER RANGE 0 TO 20;   
    SIGNAL ball_x_motion_3: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_motion_3: INTEGER RANGE -10 TO 10;
    SIGNAL ball_y_pos_3: INTEGER RANGE 0 TO 480;
    SIGNAL ball_x_pos_3: INTEGER RANGE 0 TO 640;
	-- PADDLE --
    SIGNAL paddle_on: STD_LOGIC;
    SIGNAL paddle_x: INTEGER := 20;
    SIGNAL paddle_x_motion: INTEGER RANGE -10 TO 10;
    CONSTANT paddle_width: INTEGER:= 60;
    CONSTANT paddle_height: INTEGER:= 7;
	-- RANDOM NUMNBER --
    SIGNAL last_rand_num: INTEGER RANGE 0 TO 640:= 220;
    SIGNAL last_rand_num_2 : INTEGER RANGE 0 TO 640:= 320;
    SIGNAL last_rand_num_3 : INTEGER RANGE 0 TO 640:= 420;
    -- IMAGES ON OR OFF --
    SIGNAL images: STD_LOGIC_VECTOR(3 downto 0);
	-- SCORE --
	SIGNAL scoreSolid_T, scoreBoxed_T: INTEGER RANGE 0 TO 9;
	SHARED VARIABLE score_Solid, score_Boxed: INTEGER RANGE 0 TO 10;
	-- Solid SCORE --	
	SIGNAL player_score_on: 			STD_LOGIC;
	SIGNAL player_score_size : 		integer range 0 to 20;   
	SIGNAL player_score_y_motion: 	integer range -10 to 10; 
	SIGNAL player_score_x_motion: 	integer range -10 to 10; 
	SIGNAL player_score_y_pos: 	 	integer range 0 to 480; 
	SIGNAL player_score_x_pos:    	integer range 0 to 640; 
    -- Boxed SCORE --
	SIGNAL boxed_score_on: 			STD_LOGIC;
	SIGNAL boxed_score_size : 		integer range 0 to 20;   
	SIGNAL boxed_score_y_motion: 	integer range -10 to 10; 
	SIGNAL boxed_score_x_motion: 	integer range -10 to 10; 
	SIGNAL boxed_score_y_pos: 	 	integer range 0 to 480; 
	SIGNAL boxed_score_x_pos:    	integer range 0 to 640; 

type my_rom_1 is array (0 to 15) of std_logic_vector (0 to 15);

constant round_shape: my_rom_1:= (
    "0000111111110000",
    "0011111111111100",
    "1111111111111111",
    "1110000110000111",
    "1100000110000011",
    "1100001110000011",
    "0110111111110110",
    "0011111001111100",
    "0011111111111100",
    "0001100110011000",
    "0001100110011000",
    others => "0000000000000000"
);

type my_rom_2 is array (0 to 15) of std_logic_vector (0 to 15);

constant round_shape_2: my_rom_2:= (
    "0000111111110000",
    "0011111111111100",
    "1111111111111111",
    "1110000110000111",
    "1100000110000011",
    "1100001110000011",
    "0110111111110110",
    "0011111001111100",
    "0011111111111100",
    "0001100110011000",
    "0001100110011000",
    others => "0000000000000000"
);

type my_rom_3 is array (0 to 15) of std_logic_vector (0 to 15);

constant round_shape_3: my_rom_3:= (
    "0000111111110000",
    "0011111111111100",
    "1111111111111111",
    "1110000110000111",
    "1100000110000011",
    "1100001110000011",
    "0110111111110110",
    "0011111001111100",
    "0011111111111100",
    "0001100110011000",
    "0001100110011000",
    others => "0000000000000000"
);

TYPE digit12x12 IS ARRAY (0 TO 11) OF STD_LOGIC_VECTOR (0 TO 11);

	CONSTANT zero: digit12x12 := (
	-- 0: code x30
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100111000", -- 5 **  ***
	"001101111000", -- 6 ** ****
	"001111011000", -- 7 **** **
	"001110011000", -- 8 ***  **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT one: digit12x12 := (
	-- 1: code x31
	"000000000000", -- 1
	"000001100000", -- 2    **
	"000011100000", -- 3   ***
	"000111100000", -- 4  ****
	"000001100000", -- 5    **
	"000001100000", -- 6    **
	"000001100000", -- 7    **
	"000001100000", -- 8    **
	"000001100000", -- 9    **
	"000001100000", -- a    **
	"000111111000", -- b  ******
	"000000000000" -- f
	);

	CONSTANT two: digit12x12 := (
	-- 2: code x32
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000110000", -- 5     **
	"000001100000", -- 6    **
	"000011000000", -- 7   **
	"000110000000", -- 8  **
	"001100000000", -- 9 **
	"001100011000", -- a **   **
	"001111111000", -- b *******
	"000000000000" -- f
	);

	CONSTANT three: digit12x12 := (
	-- 3: code x33
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000011000", -- 5      **
	"000011110000", -- 6   ****
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT four: digit12x12 := (
	-- 4: code x34
	"000000000000", -- 1
	"000000110000", -- 2     **
	"000001110000", -- 3    ***
	"000011110000", -- 4   ****
	"000110110000", -- 5  ** **
	"001100110000", -- 6 **  **
	"001111111000", -- 7 *******
	"000000110000", -- 8     **
	"000000110000", -- 9     **
	"000000110000", -- a     **
	"000001111000", -- b    ****
	"000000000000" -- f
	);

	CONSTANT five: digit12x12 := (
	-- code x35
	"000000000000", -- 1
	"001111111000", -- 2 *******
	"001100000000", -- 3 **
	"001100000000", -- 4 **
	"001100000000", -- 5 **
	"001111110000", -- 6 ******
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT six: digit12x12 := (
	-- code x36
	"000000000000", -- 1
	"000011100000", -- 2   ***
	"000110000000", -- 3  **
	"001100000000", -- 4 **
	"001100000000", -- 5 **
	"001111110000", -- 6 ******
	"001100011000", -- 7 **   **
	"001100011000", -- 8 **   **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT seven: digit12x12 := (
	-- code x37
	"000000000000", -- 1
	"001111111000", -- 2 *******
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000011000", -- 5      **
	"000000110000", -- 6     **
	"000001100000", -- 7    **
	"000011000000", -- 8   **
	"000011000000", -- 9   **
	"000011000000", -- a   **
	"000011000000", -- b   **
	"000000000000" -- f
	);

	CONSTANT eight: digit12x12 := (
	-- code x38
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100011000", -- 5 **   **
	"000111110000", -- 6  *****
	"001100011000", -- 7 **   **
	"001100011000", -- 8 **   **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT nine: digit12x12 := (
	-- code x39
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100011000", -- 5 **   **
	"000111111000", -- 6  ******
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"000000110000", -- a     **
	"000111100000", -- b  ****
	"000000000000" -- f
	);
	 
	SIGNAL digit_solid_T, digit_boxed_T: digit8x16;
	
	FUNCTION number_grabber (SIGNAL input: INTEGER) RETURN digit12x12 IS
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
			WHEN OTHERS => RETURN nine;
		END CASE;
	END number_grabber;

  BEGIN	
	-- SET SCORE SIZE --	
	player_score_size <= zero'length-1; --boxed_square_shape'length-1;
	boxed_score_size <= nine'length-1; --boxed_square_shape'length-1;
	-- SET SCORE LOCATION --
	player_score_x_pos <= 60;--left_x;
	player_score_y_pos <= 30;--left_y;
	boxed_score_x_pos <= 400;--right_x;  
	boxed_score_y_pos <= 30;--right_y; 
	
	-- OBJECT SIZE --
    size <= round_shape'length-1;   -- size of ball 1
    size_2 <= round_shape_2'length-1;
    size_3 <= round_shape_3'length-1;
	
---------------------------------
--------     PIXELS     ---------
---------------------------------
	-- Boundaries --
	--check if pixel scanned in located within the square ball
	check_pixel_boarder: PROCESS (pixel_column, pixel_row)--, boarder_x_pos, boarder_y_pos)--bottom_of_screen, top_of_screen, right_of_screen, left_of_screen)
   BEGIN	                                
		IF (pixel_column > right_of_screen AND pixel_column <= 640) OR 
			(pixel_column < left_of_screen AND pixel_column >= 0) OR  
 	   	(pixel_row < top_of_screen AND pixel_row >= 0) OR 
			(pixel_row > bottom_of_screen AND pixel_row <= 480)  
      THEN
			boarder_on <= '1';						
 		ELSE
			boarder_on <= '0';
		END IF;
	END PROCESS;
---------------------------------	
check_pixel_ball_1: PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
BEGIN                                
    IF (pixel_column >= ball_x_pos) AND (pixel_column <= ball_x_pos + size) AND  
        (pixel_row >= ball_y_pos) AND (pixel_row <= ball_y_pos + size)  
    THEN
        ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
    ELSE
        ball_on <= '0';
    END IF;
END PROCESS;
---------------------------------	
check_pixel_ball_2: PROCESS (ball_x_pos_2, ball_y_pos_2, pixel_column, pixel_row, size_2)
BEGIN                                
    IF (pixel_column >= ball_x_pos_2) AND (pixel_column <= ball_x_pos_2 + size_2) AND  
        (pixel_row >= ball_y_pos_2) AND (pixel_row <= ball_y_pos_2 + size_2)  
    THEN
        ball_on_2 <= round_shape_2(pixel_row - ball_y_pos_2)(pixel_column - ball_x_pos_2);
    ELSE
        ball_on_2 <= '0';
    END IF;
END PROCESS;
---------------------------------	
check_pixel_ball_3: PROCESS (ball_x_pos_3, ball_y_pos_3, pixel_column, pixel_row, size_3)
BEGIN                                
    IF (pixel_column >= ball_x_pos_3) AND (pixel_column <= ball_x_pos_3 + size_3) AND  
        (pixel_row >= ball_y_pos_3) AND (pixel_row <= ball_y_pos_3 + size_3)  
    THEN
        ball_on_3 <= round_shape_3(pixel_row - ball_y_pos_3)(pixel_column - ball_x_pos_3);
    ELSE
        ball_on_3 <= '0';
    END IF;
END PROCESS;
---------------------------------	
check_paddle: PROCESS (paddle_x, pixel_column, pixel_row)
BEGIN                                
    IF (pixel_column >= paddle_x) AND (pixel_column <= paddle_x + paddle_width) AND  
        (pixel_row >= paddle_y - paddle_height) AND (pixel_row <= paddle_y)  
    THEN
        paddle_on <= '1';
    ELSE
        paddle_on <= '0';
    END IF;
END PROCESS;


---------------------------------
--------    MOVEMENT    ---------
---------------------------------	
paddle_movement: PROCESS (vsync, push_up, push_down)
BEGIN                                
    IF (vsync'event and vsync = '1') THEN
        IF (push_up = '0') THEN
            paddle_x_motion <= -5;
        ELSIF (push_down = '0') THEN
            paddle_x_motion <= 5;
        ELSE
            paddle_x_motion <= 0;
        END IF;
        IF ((paddle_x + paddle_x_motion + paddle_width) > right_of_screen) THEN
            paddle_x_motion <= -1;
        ELSIF ((paddle_x + paddle_x_motion) < left_of_screen) THEN
            paddle_x_motion <= 1;
        END IF;
        paddle_x <= paddle_x + paddle_x_motion;
    END IF;
END PROCESS;
---------------------------------	
Ball1_motion: PROCESS
BEGIN
    ball_y_pos <= top_of_screen;
    ball_y_motion <= 1;
    ball_x_pos <= last_rand_num; -- use last randomized number as starting position
    ball_x_motion <= 0;
     
    WAIT UNTIL vsync'event AND vsync = '1';

    -- check for collisions with the paddle
    IF ball_x_pos >= paddle_x AND ball_x_pos <= paddle_x + paddle_width AND ball_y_pos + size >= paddle_y AND ball_y_pos + size <= paddle_y + paddle_height THEN
        ball_y_pos <= top_of_screen; -- ball touched the paddle, move it back to the top
        last_rand_num <= rand_Num; -- generate a new random number
        ball_x_pos <= last_rand_num; -- assign the new random number to the ball's x position
    ELSE
        -- update ball position and reset speed to 1 when the ball reaches the bottom of the screen
        IF ball_y_pos + size >= bottom_of_screen THEN
            last_rand_num <= rand_Num;
            ball_x_pos <= last_rand_num;
            ball_y_pos <= top_of_screen;
        ELSE
            ball_y_pos <= ball_y_pos + ball_y_motion;
        END IF;
    END IF;
END PROCESS;
---------------------------------	
Ball2_motion: PROCESS
BEGIN
ball_y_pos_2 <= top_of_screen;
ball_y_motion_2 <= 1;
ball_x_pos_2 <= last_rand_num_2; -- use last randomized number as starting position
ball_x_motion_2 <= 0;

WAIT UNTIL vsync'event AND vsync = '1';

-- check for collisions with the paddle
IF ball_x_pos_2 >= paddle_x AND ball_x_pos_2 <= paddle_x + paddle_width AND ball_y_pos_2 + size_2 >= paddle_y AND ball_y_pos_2 + size_2 <= paddle_y + paddle_height THEN
    ball_y_pos_2 <= top_of_screen; -- ball touched the paddle, move it back to the top
last_rand_num_2 <= rand_Num_2; -- generate a new random number
    ball_x_pos_2 <= last_rand_num_2; -- assign the new random number to the ball's x position
ELSE
    -- update ball position and randomize x position when the ball reaches the bottom of the screen
    IF ball_y_pos_2 + size_2 >= bottom_of_screen THEN
        last_rand_num_2 <= rand_Num_2;
        ball_x_pos_2 <= last_rand_num_2;
        ball_y_pos_2 <= top_of_screen;
    ELSE
        ball_y_pos_2 <= ball_y_pos_2 + ball_y_motion_2;
    END IF;
END IF;
END PROCESS;
---------------------------------	
Ball3_motion: PROCESS
BEGIN
ball_y_pos_3 <= top_of_screen;
ball_y_motion_3 <= 1;
ball_x_pos_3 <= last_rand_num_3; -- use last randomized number as starting position
ball_x_motion_3 <= 0;

WAIT UNTIL vsync'event AND vsync = '1';

-- check for collisions with the paddle
IF ball_x_pos_3 >= paddle_x AND ball_x_pos_3 <= paddle_x + paddle_width AND ball_y_pos_3 + size_3 >= paddle_y AND ball_y_pos_3 + size_3 <= paddle_y + paddle_height THEN
    ball_y_pos_3 <= top_of_screen; -- ball touched the paddle, move it back to the top
last_rand_num_3 <= rand_Num_3; -- generate a new random number
    ball_x_pos_3 <= last_rand_num_3; -- assign the new random number to the ball's x position
ELSE
    -- update ball position and randomize x position when the ball reaches the bottom of the screen
    IF ball_y_pos_3 + size_3 >= bottom_of_screen THEN
        last_rand_num_3 <= rand_Num_3;
        ball_x_pos_3 <= last_rand_num_3;
        ball_y_pos_3 <= top_of_screen;
    ELSE
        ball_y_pos_3 <= ball_y_pos_3 + ball_y_motion_3;
    END IF;
END IF;
END PROCESS;
---------------------------------	
score: PROCESS		
BEGIN
    --MOTION: FOR i in 50 to 430 GENERATE	
    WAIT UNTIL (vsync'event AND vsync = '1');		         		
    IF (ball_x_pos + ball_size) >= (right_of_screen + 1)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 
        score_Boxed := score_Boxed + 1;
        IF (score_Boxed = 10) THEN
            score_Boxed := 0;
        END IF;
        scoreBoxed_T <= score_Boxed;
    ELSIF (ball_x_pos) <= (left_of_screen - 1) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
        score_Player := score_Player + 1;
        IF (score_Player = 10) THEN
            score_Player := 0;
        END IF;
        scoreSolid_T <= score_Player;
    END IF;
    digit_player_T <= number_grabber(scorePlayer_T);
    digit_boxed_T <= number_grabber(scoreBoxed_T);
END PROCESS;
---------------------------------
--update position of paddle once every screen refresh cycle
motion_solid: PROCESS	
BEGIN
    --MOTION: FOR i in 50 to 430 GENERATE	
    WAIT UNTIL (vsync'event AND vsync = '1');		         		
    IF	(player_square_y_pos) <=  top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
        player_square_y_motion <= 2;
    ELSIF (player_square_y_pos + player_square_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
        player_square_y_motion <= -2;
    END IF;
    solid_square_y_pos <= player_square_y_pos + player_square_y_motion;
END PROCESS;
---------------------------------
--check if pixel scanned in located within the boxed square
check_pixel_boxed_score:  PROCESS (boxed_score_x_pos, boxed_score_y_pos, pixel_column, pixel_row, boxed_score_size)
BEGIN	                                
 IF (pixel_column >= boxed_score_x_pos) AND (pixel_column <= boxed_score_x_pos + boxed_score_size) AND  
     (pixel_row >= boxed_score_y_pos) AND (pixel_row <= boxed_score_y_pos + boxed_score_size)  
THEN					
     boxed_score_on <= digit_boxed_T(pixel_row - boxed_score_y_pos)(pixel_column - boxed_score_x_pos);
  ELSE
     boxed_score_on <= '0';
 END IF;

END PROCESS;
---------------------------------

images <= ball_on & ball_on_2 & ball_on_3 & paddle_on & player_score_on & boxed_score_on & boarder_on; -- add third ball to images signal
setcolor: PROCESS (images)
BEGIN
  CASE images IS
    WHEN "0001000" =>  -- paddle
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '1');
    WHEN "0010000" =>  -- ball 3
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "0100000" =>  -- ball 2
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "0110000" =>  -- ball 2 and 3
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1000000" =>  -- ball 1
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1010000" =>  -- ball 1 and 3
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1100000" =>  -- balls 1 and 2
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1110000" =>  -- all three balls
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "0000010" =>  -- player score
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "0000001" =>  -- boxed score
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "0000001" =>  -- boarder
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '1');
    WHEN OTHERS =>  -- white background
      red <= (OTHERS => '1');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '1');
  END CASE;
END PROCESS;


---------------------------------
images <= ball_on & boarder_on & paddle_on & solid_square_on & boxed_square_on & player_score_on & boxed_score_on; --images is a signal you declare in the architecture
setcolor: PROCESS (images)
BEGIN
    CASE images IS
        WHEN "1000000" =>
            red <= (OTHERS => '1'); -- make the ball red
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '0'); 
        WHEN "0100000" =>
            red <= (OTHERS => '0'); 
            green <= (OTHERS => '1'); -- make the wall green-blue
            blue <= (OTHERS => '1'); 
        WHEN "0010000" =>
            red <= (OTHERS => '0'); 
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '1'); -- make the paddle blue
        WHEN "1010000" =>
            red <= (OTHERS => '1'); 
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '1'); -- make the paddle blue
        WHEN "0001000" =>
            red <= (OTHERS => '1'); 
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '1'); -- make the paddle blue
        WHEN "0000100" =>
            red <= (OTHERS => '1'); 
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '1'); -- make the paddle blue
        WHEN "0000001" =>
            red <= (OTHERS => '1');  -- score is red
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '0');
        WHEN "0000010" =>
            red <= (OTHERS => '1');  -- score is red
            green <= (OTHERS => '0'); 
            blue <= (OTHERS => '0');
        WHEN OTHERS =>
            red <= (OTHERS => '1'); -- the background will be white
            green <= (OTHERS => '1');
            blue <= (OTHERS => '1');
    END CASE;
END PROCESS;

---------------------------------

END;




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
		move_up, move_down: IN STD_LOGIC;
		red, green, blue: out std_logic_vector(7 downto 0) );
end;
		
architecture myimage of make_image0 is
--**** SCREEN DESIGN AND LAYOUT ****--
	-- Boarder --
	SIGNAL boarder_on: 		STD_LOGIC;
	SIGNAL boarder_y_pos: 	integer range 0 to 480; 
	SIGNAL boarder_x_pos:   integer range 0 to 640;
	-- Boundaries --
	CONSTANT bottom_of_screen: integer := 459;
	CONSTANT top_of_screen: 	integer := 20;
	CONSTANT right_of_screen: 	integer := 619;
	CONSTANT left_of_screen: 	integer := 20;

	SIGNAL images: STD_LOGIC_VECTOR(6 DOWNTO 0);

--**** SPRITES DESIGN AND LAYOUT ****--	
	-- Paddle --
	SIGNAL paddle_on: 		STD_LOGIC;
	SIGNAL paddle_size: 		integer range 0 to 100;   
	SIGNAL paddle_y_motion: integer range -10 to 10; 
	SIGNAL paddle_x_motion: integer range -10 to 10; 
	SIGNAL paddle_y_pos: 	integer range 0 to 480; 
	SIGNAL paddle_x_pos:    integer range 0 to 640; 
	CONSTANT paddle_width: INTEGER := 60;
	CONSTANT paddle_height: INTEGER := 10;
	
	-- BALL --
	SIGNAL ball_on: 			STD_LOGIC;
	SIGNAL ball_size : 		integer range 0 to 20;   
	SIGNAL ball_y_motion: 	integer range -10 to 10; 
	SIGNAL ball_x_motion: 	integer range -10 to 10; 
	SIGNAL ball_y_pos: 	 	integer range 0 to 480; 
	SIGNAL ball_x_pos:    	integer range 0 to 640; 
	
	-- Solid Squard --
	SIGNAL solid_square_on: 			STD_LOGIC;
	SIGNAL solid_square_size : 		integer range 0 to 20;   
	SIGNAL solid_square_y_motion: 	integer range -10 to 10; 
	SIGNAL solid_square_x_motion: 	integer range -10 to 10; 
	SIGNAL solid_square_y_pos: 	 	integer range 0 to 480; 
	SIGNAL solid_square_x_pos:    	integer range 0 to 640; 
	-- Boxed Square --
	SIGNAL boxed_square_on: 			STD_LOGIC;
	SIGNAL boxed_square_size : 		integer range 0 to 20;   
	SIGNAL boxed_square_y_motion: 	integer range -10 to 10; 
	SIGNAL boxed_square_x_motion: 	integer range -10 to 10; 
	SIGNAL boxed_square_y_pos: 	 	integer range 0 to 480; 
	SIGNAL boxed_square_x_pos:    	integer range 0 to 640; 
	

	
		-- Digit Placement --
	CONSTANT left_x: INTEGER := 60;
	CONSTANT left_y: INTEGER := 60;
	CONSTANT right_x: INTEGER := 400;
	CONSTANT right_y: INTEGER := 60;
	
	
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
												
	CONSTANT explode_shape: my_rom :=( "110000000111000000011",
												"000000001111100000000",
												"011100011111110001110",
												"000000111001111000000",
												"000001001111000100000",
												"000011110011101110000",
												"000111111111110011000",
												"001100111100111111100",
												"011111110000011100110",
												"110000111000111110001",
												"111111000000000111111",
												"111000011000111100111",
												"011111110000011001110",
												"001111111111111111100",
												"000000001110011111000",
												"000011111111111110000",
												"000001111111111100000",
												"000000111000011000000",
												"001100011111110000000",
												"000000001111100000000",
												"110000000111000000011" );											
												
	CONSTANT solid_square_shape: my_rom :=( "111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111",
												"111111111111111111111" );	
														
	CONSTANT boxed_square_shape: my_rom :=( "111111111111111111111",
												"111111111111111111111",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"110000000000000000011",
												"111111111111111111111",
												"111111111111111111111" );	

TYPE digit12x12 IS ARRAY (0 TO 11) OF STD_LOGIC_VECTOR (0 TO 11);

	CONSTANT zero: digit12x12 := (
	-- 0: code x30
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100111000", -- 5 **  ***
	"001101111000", -- 6 ** ****
	"001111011000", -- 7 **** **
	"001110011000", -- 8 ***  **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT one: digit12x12 := (
	-- 1: code x31
	"000000000000", -- 1
	"000001100000", -- 2    **
	"000011100000", -- 3   ***
	"000111100000", -- 4  ****
	"000001100000", -- 5    **
	"000001100000", -- 6    **
	"000001100000", -- 7    **
	"000001100000", -- 8    **
	"000001100000", -- 9    **
	"000001100000", -- a    **
	"000111111000", -- b  ******
	"000000000000" -- f
	);

	CONSTANT two: digit12x12 := (
	-- 2: code x32
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000110000", -- 5     **
	"000001100000", -- 6    **
	"000011000000", -- 7   **
	"000110000000", -- 8  **
	"001100000000", -- 9 **
	"001100011000", -- a **   **
	"001111111000", -- b *******
	"000000000000" -- f
	);

	CONSTANT three: digit12x12 := (
	-- 3: code x33
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000011000", -- 5      **
	"000011110000", -- 6   ****
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT four: digit12x12 := (
	-- 4: code x34
	"000000000000", -- 1
	"000000110000", -- 2     **
	"000001110000", -- 3    ***
	"000011110000", -- 4   ****
	"000110110000", -- 5  ** **
	"001100110000", -- 6 **  **
	"001111111000", -- 7 *******
	"000000110000", -- 8     **
	"000000110000", -- 9     **
	"000000110000", -- a     **
	"000001111000", -- b    ****
	"000000000000" -- f
	);

	CONSTANT five: digit12x12 := (
	-- code x35
	"000000000000", -- 1
	"001111111000", -- 2 *******
	"001100000000", -- 3 **
	"001100000000", -- 4 **
	"001100000000", -- 5 **
	"001111110000", -- 6 ******
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT six: digit12x12 := (
	-- code x36
	"000000000000", -- 1
	"000011100000", -- 2   ***
	"000110000000", -- 3  **
	"001100000000", -- 4 **
	"001100000000", -- 5 **
	"001111110000", -- 6 ******
	"001100011000", -- 7 **   **
	"001100011000", -- 8 **   **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT seven: digit12x12 := (
	-- code x37
	"000000000000", -- 1
	"001111111000", -- 2 *******
	"001100011000", -- 3 **   **
	"000000011000", -- 4      **
	"000000011000", -- 5      **
	"000000110000", -- 6     **
	"000001100000", -- 7    **
	"000011000000", -- 8   **
	"000011000000", -- 9   **
	"000011000000", -- a   **
	"000011000000", -- b   **
	"000000000000" -- f
	);

	CONSTANT eight: digit12x12 := (
	-- code x38
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100011000", -- 5 **   **
	"000111110000", -- 6  *****
	"001100011000", -- 7 **   **
	"001100011000", -- 8 **   **
	"001100011000", -- 9 **   **
	"001100011000", -- a **   **
	"000111110000", -- b  *****
	"000000000000" -- f
	);

	CONSTANT nine: digit12x12 := (
	-- code x39
	"000000000000", -- 1
	"000111110000", -- 2  *****
	"001100011000", -- 3 **   **
	"001100011000", -- 4 **   **
	"001100011000", -- 5 **   **
	"000111111000", -- 6  ******
	"000000011000", -- 7      **
	"000000011000", -- 8      **
	"000000011000", -- 9      **
	"000000110000", -- a     **
	"000111100000", -- b  ****
	"000000000000" -- f
	);
	 
	SIGNAL digit_solid_T, digit_boxed_T: digit8x16;
	
	FUNCTION number_grabber (SIGNAL input: INTEGER) RETURN digit12x12 IS
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
			WHEN OTHERS => RETURN nine;
		END CASE;
	END number_grabber;

    TYPE skullNbones IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (0 TO 15);
    CONSTANT one: digit12x12 := (			-- STX: code x02
            "0000000000000000", -- 0
            "0000000000000000", -- 1
            "0000111111110000", -- 2  ******
            "0001111111111000", -- 3 ********
            "0011000110001100", -- 4 ** ** **
            "0011100110011100", -- 5 ********
            "0011111001111100", -- 6 ********
            "0011110000111100", -- 7 **    **
            "0011111111111100", -- 8 ***  ***
            "0011101110110100", -- 9 ********
            "0000000000000000", -- a ********
            "0000000110000000", -- b  ******
            "0000111001110000", -- c
            "0001110000111000", -- d
            "0110110000010110", -- e
            "0000000000000000"-- f
    );
	
	type name_type is array (0 to 2**addrWidth-1) of std_logic_vector(dataWidth-1 downto 0);
	-- ROM definition
	signal ROM: rom_type := (   -- 2^11-by-8
    "00000000", -- 0
    "00000000", -- 1
    "00111100", -- 2   ****
    "01100110", -- 3  **  **
    "11000010", -- 4 **    *
    "11000000", -- 5 **
    "11000000", -- 6 **
    "11011110", -- 7 ** ****
    "11000110", -- 8 **   **
    "11000110", -- 9 **   **
    "01100110", -- a  **  **
    "00111010", -- b   *** *
    "00000000", -- c
    "00000000", -- d
    "00000000", -- e
    "00000000", -- f

    "00000000", -- 0
    "00000000", -- 1
    "11000110", -- 2 **   **
    "11000110", -- 3 **   **
    "11000110", -- 4 **   **
    "11000110", -- 5 **   **
    "11111110", -- 6 *******
    "11000110", -- 7 **   **
    "11000110", -- 8 **   **
    "11000110", -- 9 **   **
    "11000110", -- a **   **
    "11000110", -- b **   **
    "00000000", -- c
    "00000000", -- d
    "00000000", -- e
    "00000000", -- f

    "00000000", -- 0
    "00000000", -- 1
    "01111100", -- 2  *****
    "11000110", -- 3 **   **
    "11000110", -- 4 **   **
    "11000110", -- 5 **   **
    "11000110", -- 6 **   **
    "11000110", -- 7 **   **
    "11000110", -- 8 **   **
    "11000110", -- 9 **   **
    "11000110", -- a **   **
    "01111100", -- b  *****
    "00000000", -- c
    "00000000", -- d
    "00000000", -- e
    "00000000", -- f

    "00000000", -- 0
    "00000000", -- 1
    "01111100", -- 2  *****
    "11000110", -- 3 **   **
    "11000110", -- 4 **   **
    "01100000", -- 5  **
    "00111000", -- 6   ***
    "00001100", -- 7     **
    "00000110", -- 8      **
    "11000110", -- 9 **   **
    "11000110", -- a **   **
    "01111100", -- b  *****
    "00000000", -- c
    "00000000", -- d
    "00000000", -- e
    "00000000", -- f
    -- code x54
    "00000000", -- 0
    "00000000", -- 1
    "11111111", -- 2 ********
    "11011011", -- 3 ** ** **
    "10011001", -- 4 *  **  *
    "00011000", -- 5    **
    "00011000", -- 6    **
    "00011000", -- 7    **
    "00011000", -- 8    **
    "00011000", -- 9    **
    "00011000", -- a    **
    "00111100", -- b   ****
    "00000000", -- c
    "00000000", -- d
    "00000000", -- e
    "00000000", -- f

    );


BEGIN	
	-- INITIALIZE THE SCORE (SHAPE) --
	--digit_solid_T <= number_grabber(scoreSolid_T);
	--digit_boxed_T <= number_grabber(scoreBoxed_T);	
	
	-- SET SCORE SIZE --	
	player_score_size <= zero'length-1; --boxed_square_shape'length-1;
	boxed_score_size <= nine'length-1; --boxed_square_shape'length-1;
	-- SET SCORE LOCATION --
	player_score_x_pos <= 60;--left_x;
	player_score_y_pos <= 30;--left_y;
	boxed_score_x_pos <= 400;--right_x;  
	boxed_score_y_pos <= 30;--right_y; 
	
	-- OBJECT SIZE --
	ball_size <= round_shape'length-1;
	--paddle_size <= paddle_shape(5)(60);
	
	player_square_size <= solid_square_shape'length-1;
	boxed_square_size <= boxed_square_shape'length-1;
	player_square_x_pos <= 150;
	--solid_square_y_pos <= 120;
	boxed_square_x_pos <= 530;
	--boxed_square_y_pos <= 60;
	
	-- OBJECT PLACEMENT --
	paddle_y_pos <= 420;
	

	
--	reset_proc: PROCESS (reset)
--	BEGIN
--		IF	(reset = '0') THEN --AND
--			ball_x_pos <= ball_x_pos + ball_x_motion;
--			ball_y_pos <= ball_y_pos + ball_y_motion;
--			paddle_x_pos <= 310;
--				
--			solid_square_y_pos <= solid_square_y_pos + solid_square_y_motion;
--			boxed_square_y_pos <= boxed_square_y_pos + boxed_square_y_motion;		
--		END IF;
--	
--	END PROCESS reset_proc;
------------------------------------
	-- Boundaries --
--	CONSTANT bottom_of_screen: integer := 459;
--	CONSTANT top_of_screen: 	integer := 20;
--	CONSTANT right_of_screen: 	integer := 619;
--	CONSTANT left_of_screen: 	integer := 20;
	--check if pixel scanned in located within the square ball
	check_pixel_boarder: PROCESS (pixel_column, pixel_row)--, boarder_x_pos, boarder_y_pos)--bottom_of_screen, top_of_screen, right_of_screen, left_of_screen)
   BEGIN	                                
		IF (pixel_column > right_of_screen AND pixel_column <= 640) OR 
			(pixel_column < left_of_screen AND pixel_column >= 0) OR  
 	   	(pixel_row < top_of_screen AND pixel_row >= 0) OR 
			(pixel_row > bottom_of_screen AND pixel_row <= 480)  
      THEN
			boarder_on <= '1';						
 		ELSE
			boarder_on <= '0';
		END IF;
	END PROCESS;
	
	------------------------------------
--check if pixel scanned in located within the square ball
	check_pixel_ball: PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, ball_size,ball_x_pos)
   	BEGIN	                                
		IF (pixel_column >= ball_x_pos) 
			AND (pixel_column <= ball_x_pos + ball_size)
			AND  (pixel_row >= ball_y_pos) 
			AND (pixel_row <= ball_y_pos + ball_size) THEN					
			ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			IF (ball_x_pos + ball_size) >= (right_of_screen + 15)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 		
--				ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			ELSIF (ball_x_pos) <= (left_of_screen - 15) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   			
--				ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			ELSE
--				ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);		
--			END IF;
--			
--	RAZZEL THE SCREEN		
--		ELSIF (ball_x_pos + ball_size) = (right_of_screen + 1)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 		
--			ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--		ELSIF (ball_x_pos) <= (left_of_screen - 1) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   			
--			ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
		ELSE
			ball_on <= '0';
		END IF;
	END PROCESS;
--------------------------------------
----check if pixel scanned in located within the square ball
--	check_pixel_ball: PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, ball_size,ball_x_pos)
--   	BEGIN	                                
--		IF (pixel_column >= ball_x_pos) 
--			AND (pixel_column <= ball_x_pos + ball_size) 
--			
--			
--			AND  (pixel_row >= ball_y_pos) 
--			AND (pixel_row <= ball_y_pos + ball_size) THEN					
--			--ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			IF (ball_x_pos + ball_size) >= (right_of_screen + 15)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 		
--				ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			ELSIF (ball_x_pos) <= (left_of_screen - 15) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   			
--				ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--			ELSE
--				ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);		
--			END IF;
--			
----	RAZZEL THE SCREEN		
----		ELSIF (ball_x_pos + ball_size) = (right_of_screen + 1)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 					
----			ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
----		ELSIF (ball_x_pos) <= (left_of_screen - 1) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   			
----			ball_on <= explode_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
--		ELSE
--			ball_on <= '0';
--		END IF;
--	END PROCESS;
---------------------------------
--check if pixel scanned in located within the square ball
	check_pixel_paddle: PROCESS (paddle_x_pos, paddle_y_pos, pixel_column, pixel_row)
   BEGIN	                                
		IF (pixel_column >= paddle_x_pos) AND (pixel_column <= paddle_x_pos + paddle_width) AND  
 	   	(pixel_row >= paddle_y_pos) AND (pixel_row <= paddle_y_pos + paddle_height) THEN					
			paddle_on <= '1'; --paddle_shape(pixel_row - paddle_y_pos)(pixel_column - paddle_x_pos);
		ELSE
			paddle_on <= '0';
		END IF;
	END PROCESS;
	--------------------------------	
	--check if pixel scanned in located within the solid square
	check_pixel_solid_square: PROCESS (solid_square_x_pos, solid_square_y_pos, pixel_column, pixel_row, solid_square_size)
   	BEGIN	                                
		IF (pixel_column >= solid_square_x_pos) AND (pixel_column <= solid_square_x_pos + solid_square_size) AND  
 	   	(pixel_row >= solid_square_y_pos) AND (pixel_row <= solid_square_y_pos + solid_square_size)  
      THEN					
			solid_square_on <= solid_square_shape(pixel_row - solid_square_y_pos)(pixel_column - solid_square_x_pos);
 		ELSE
			solid_square_on <= '0';
		END IF;

	END PROCESS;
------------------------------------
--check if pixel scanned in located within the boxed square
	check_pixel_boxed_square: PROCESS (boxed_square_x_pos, boxed_square_y_pos, pixel_column, pixel_row, boxed_square_size)
   	BEGIN	                                
		IF (pixel_column >= boxed_square_x_pos) AND (pixel_column <= boxed_square_x_pos + boxed_square_size) AND  
 	   	(pixel_row >= boxed_square_y_pos) AND (pixel_row <= boxed_square_y_pos + boxed_square_size)  
      THEN					
			boxed_square_on <= boxed_square_shape(pixel_row - boxed_square_y_pos)(pixel_column - boxed_square_x_pos);
		ELSE
			boxed_square_on <= '0';
		END IF;

	END PROCESS;
------------------------------------
--check if pixel scanned in located within the boxed square
	check_pixel_solid_score: PROCESS (player_score_x_pos, player_score_y_pos, pixel_column, pixel_row, player_score_size)
   	BEGIN	                                
		IF (pixel_column >= player_score_x_pos) AND (pixel_column <= player_score_x_pos + player_score_size) AND  
 	   	(pixel_row >= player_score_y_pos) AND (pixel_row <= player_score_y_pos + player_score_size)  
      THEN					
            player_score_on <= digit_solid_T(pixel_row - player_score_y_pos)(pixel_column - player_score_x_pos);
 		ELSE
            player_score_on <= '0';
		END IF;

	END PROCESS;
--------------------------------------
--check if pixel scanned in located within the boxed square
	check_pixel_boxed_score:  PROCESS (boxed_score_x_pos, boxed_score_y_pos, pixel_column, pixel_row, boxed_score_size)
   	BEGIN	                                
		IF (pixel_column >= boxed_score_x_pos) AND (pixel_column <= boxed_score_x_pos + boxed_score_size) AND  
 	   	(pixel_row >= boxed_score_y_pos) AND (pixel_row <= boxed_score_y_pos + boxed_score_size)  
      THEN					
			boxed_score_on <= digit_boxed_T(pixel_row - boxed_score_y_pos)(pixel_column - boxed_score_x_pos);
 		ELSE
			boxed_score_on <= '0';
		END IF;

	END PROCESS;
---------------------------------
	images <= ball_on & boarder_on & paddle_on & solid_square_on & boxed_square_on & player_score_on & boxed_score_on; --images is a signal you declare in the architecture
	setcolor: PROCESS (images)
	BEGIN
		CASE images IS
			WHEN "1000000" =>
				red <= (OTHERS => '1'); -- make the ball red
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			WHEN "0100000" =>
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '1'); -- make the wall green-blue
				blue <= (OTHERS => '1'); 
			WHEN "0010000" =>
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN "1010000" =>
				red <= (OTHERS => '1'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN "0001000" =>
				red <= (OTHERS => '1'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN "0000100" =>
				red <= (OTHERS => '1'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1'); -- make the paddle blue
			WHEN "0000001" =>
				red <= (OTHERS => '1');  -- score is red
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0');
			WHEN "0000010" =>
				red <= (OTHERS => '1');  -- score is red
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0');
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
		IF (ball_x_pos + ball_size) >= right_of_screen  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor  
			ball_x_motion <= -1;	
		ELSIF 
			(ball_x_pos) <= left_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_x_motion <= 1;                         -- start moving down by 1 pixel
		ELSIF 
			(ball_y_pos) <= top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_y_motion <= 1; 		
		ELSIF 
			(ball_y_pos + ball_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			ball_y_motion <= -1; 		
		END IF;
		ball_x_pos <= ball_x_pos + ball_x_motion;
		ball_y_pos <= ball_y_pos + ball_y_motion;
	END PROCESS;
---------------------------------	
	score: PROCESS		
	BEGIN
		--MOTION: FOR i in 50 to 430 GENERATE	
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF (ball_x_pos + ball_size) >= (right_of_screen + 1)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN	  --reached bottom of monitor 
			score_Boxed := score_Boxed + 1;
			IF (score_Boxed = 10) THEN
				score_Boxed := 0;
			END IF;
			scoreBoxed_T <= score_Boxed;
		ELSIF (ball_x_pos) <= (left_of_screen - 1) THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
			score_Player := score_Player + 1;
			IF (score_Player = 10) THEN
				score_Player := 0;
			END IF;
			scoreSolid_T <= score_Player;
		END IF;
		digit_player_T <= number_grabber(scorePlayer_T);
		digit_boxed_T <= number_grabber(scoreBoxed_T);
	END PROCESS;
---------------------------------
--update position of paddle once every screen refresh cycle
	motion_paddle: PROCESS	
	BEGIN
		--MOTION: FOR i in 50 to 430 GENERATE	
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF	(move_up = '0') THEN --AND
			IF (paddle_x_pos - 2) >= left_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				paddle_x_motion <= -2;
			ELSE
				paddle_x_motion <= 0;
			END IF;
		ELSIF (move_down = '0') THEN --AND
			IF (paddle_x_pos + paddle_size + 2) <= right_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				paddle_x_motion <= 2;
			ELSE
				paddle_x_motion <= 0;
			END IF;
		ELSIF (move_up = '1') AND (move_down = '1') THEN
			paddle_x_motion <= 0;
--		ELSIF (pixel_column <= paddle_x_pos) OR (pixel_column >= paddle_x_pos + paddle_size) THEN
--				paddle_x_motion <= 0;
--				paddle_x_pos <= 240;
		END IF;
		paddle_x_pos <= paddle_x_pos + paddle_x_motion;
	END PROCESS;
---------------------------------
--update position of paddle once every screen refresh cycle
	motion_solid: PROCESS	
	BEGIN
		--MOTION: FOR i in 50 to 430 GENERATE	
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF	(solid_square_y_pos) <=  top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				solid_square_y_motion <= 2;
		ELSIF (solid_square_y_pos + solid_square_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				solid_square_y_motion <= -2;
		END IF;
		solid_square_y_pos <= solid_square_y_pos + solid_square_y_motion;
	END PROCESS;
---------------------------------
--update position of paddle once every screen refresh cycle
	motion_boxed: PROCESS	
	BEGIN
		--MOTION: FOR i in 50 to 430 GENERATE	
		WAIT UNTIL (vsync'event AND vsync = '1');		         		
		IF	(boxed_square_y_pos) <=  top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				boxed_square_y_motion <= 2;
		ELSIF (boxed_square_y_pos + boxed_square_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
				boxed_square_y_motion <= -2;
		END IF;
		boxed_square_y_pos <= boxed_square_y_pos + boxed_square_y_motion;
	END PROCESS;
-----------------------------------
----update position of paddle once every screen refresh cycle
--	motion_solid_score: PROCESS	
--	BEGIN
--		--MOTION: FOR i in 50 to 430 GENERATE	
--		WAIT UNTIL (vsync'event AND vsync = '1');		         		
--		IF	(solid_score_y_pos) <=  top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--				solid_score_y_motion <= 0;
--				solid_score_y_pos <= 60;
--		ELSIF (solid_score_y_pos + solid_score_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--				solid_score_y_motion <= 0;
--				solid_score_y_pos <= 60;
--		END IF;
--		
--		solid_score_y_pos <= solid_score_y_pos + solid_score_y_motion;
--	END PROCESS;
----	
--	---------------------------------
----update position of paddle once every screen refresh cycle
--	motion_boxed_score: PROCESS		
--	BEGIN
--		--MOTION: FOR i in 50 to 430 GENERATE	
--		WAIT UNTIL (vsync'event AND vsync = '1');		         		
--		IF	(boxed_score_y_pos) <=  top_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--				boxed_score_y_motion <= 0;
--				boxed_score_y_pos <= 400;
--		ELSIF (boxed_score_y_pos + boxed_score_size) >= bottom_of_screen THEN --AND (ball_y_pos + size) = top_of_screen THEN	 		     -- reached top of monitor   	     	 		
--				boxed_score_y_motion <= 0;
--				boxed_score_y_pos <= 400;
--		END IF;
--		
--		boxed_score_y_pos <= boxed_score_y_pos + boxed_score_y_motion;
--	END PROCESS;
---------------------------------
--update position of paddle once every screen refresh cycle
--	score_update: PROCESS	
--	BEGIN
--		--MOTION: FOR i in 50 to 430 GENERATE	
--		WAIT UNTIL (vsync'event AND vsync = '1');		         				
--		--digit_solid_U <= number_grabber(scoreSolid_U);
--		digit_solid_T <= number_grabber(scoreSolid_T);
--		--digit_boxed_U <= number_grabber(scoreSolid_U); 
--		digit_boxed_T <= number_grabber(scoreSolid_T);	
--	END PROCESS;
END;




