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
    CONSTANT bottom_of_screen: integer := 459;
    CONSTANT top_of_screen:     integer := 20;
    CONSTANT right_of_screen:   integer := 619;
    CONSTANT left_of_screen:    integer := 20;
	 CONSTANT paddle_y: integer := 423;

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
    SIGNAL images: STD_LOGIC_VECTOR(5 downto 0);
    -- SCORE --
    SIGNAL scorePlayer_T, scoreBoxed_T: INTEGER RANGE 0 TO 9;
    SHARED VARIABLE score_Player, score_Boxed: INTEGER RANGE 0 TO 10;
    -- Solid SCORE --  
    SIGNAL player_score_on:             STD_LOGIC;
    SIGNAL player_score_size :      integer range 0 to 20;  
    SIGNAL player_score_y_motion:   integer range -10 to 10;
    SIGNAL player_score_x_motion:   integer range -10 to 10;
    SIGNAL player_score_y_pos:      integer range 0 to 480;
    SIGNAL player_score_x_pos:      integer range 0 to 640;
    -- Boxed SCORE --
    SIGNAL boxed_score_on:          STD_LOGIC;
    SIGNAL boxed_score_size :       integer range 0 to 20;  
    SIGNAL boxed_score_y_motion:    integer range -10 to 10;
    SIGNAL boxed_score_x_motion:    integer range -10 to 10;
    SIGNAL boxed_score_y_pos:       integer range 0 to 480;
    SIGNAL boxed_score_x_pos:       integer range 0 to 640;

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
     
    SIGNAL digit_player_T, digit_boxed_T: digit12x12;
   
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
    boxed_score_x_pos <= 559;--right_x;  
    boxed_score_y_pos <= 30;--right_y;
   
    -- OBJECT SIZE --
    size <= round_shape'length-1;   -- size of ball 1
    size_2 <= round_shape_2'length-1;
    size_3 <= round_shape_3'length-1;
   
---------------------------------
--------     PIXELS     ---------
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
-------------------------------------
--check if pixel scanned in located within the boxed square
	check_pixel_player_score: PROCESS (player_score_x_pos, player_score_y_pos, pixel_column, pixel_row, player_score_size)
   	BEGIN	                                
		IF (pixel_column >= player_score_x_pos) AND (pixel_column <= player_score_x_pos + player_score_size) AND  
 	   	(pixel_row >= player_score_y_pos) AND (pixel_row <= player_score_y_pos + player_score_size)  
      THEN					
			player_score_on <= digit_player_T(pixel_row - player_score_y_pos)(pixel_column - player_score_x_pos);
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
        score_Player := score_Player + 1; -- add 1 to the player's score
        IF (score_Player = 10) THEN -- if the score reaches 10, reset it to 0
            score_Player := 0;
        END IF;
        scorePlayer_T <= score_Player; -- update the player's score in the display
    ELSE
        -- update ball position and reset speed to 1 when the ball reaches the bottom of the screen
        IF ball_y_pos + size >= bottom_of_screen THEN
            last_rand_num <= rand_Num;
            ball_x_pos <= last_rand_num;
            ball_y_pos <= top_of_screen;
            score_Boxed := score_Boxed + 1; -- add 1 to the boxed score
            IF (score_Boxed = 10) THEN -- if the score reaches 10, reset it to 0
                score_Boxed := 0;
            END IF;
            scoreBoxed_T <= score_Boxed; -- update the boxed score in the display
        ELSE
            ball_y_pos <= ball_y_pos + ball_y_motion;
        END IF;
    END IF;
    digit_player_T <= number_grabber(scorePlayer_T);
    digit_boxed_T <= number_grabber(scoreBoxed_T);
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
--score: PROCESS     
--BEGIN
--    --MOTION: FOR i in 50 to 430 GENERATE  
--    WAIT UNTIL (vsync'event AND vsync = '1');                      
--    IF (ball_x_pos + size) >= (right_of_screen + 1)  THEN --AND (ball_y_pos + size) = bottom_of_screen THEN      --reached bottom of monitor
--        score_Boxed := score_Boxed + 1;
--        IF (score_Boxed = 10) THEN
--            score_Boxed := 0;
--        END IF;
--        scoreBoxed_T <= score_Boxed;
--    ELSIF (ball_x_pos) <= (left_of_screen - 1) THEN --AND (ball_y_pos + size) = top_of_screen THEN               -- reached top of monitor                      
--        score_Player := score_Player + 1;
--        IF (score_Player = 10) THEN
--            score_Player := 0;
--        END IF;
--        scorePlayer_T <= score_Player;
--    END IF;
--    digit_player_T <= number_grabber(scorePlayer_T);
--    digit_boxed_T <= number_grabber(scoreBoxed_T);
--END PROCESS;
--------------------------------------------------------------

-----------------------------------------------
---------------Set color-----------------------
-----------------------------------------------
images <= ball_on & ball_on_2 & ball_on_3 & paddle_on & player_score_on & boxed_score_on; -- add third ball to images signal
setcolor: PROCESS (images)
BEGIN
  CASE images IS
    WHEN "000100" =>  -- paddle
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '1');
    WHEN "001000" =>  -- ball 3
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "010000" =>  -- ball 2
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '0');
    WHEN "011000" =>  -- ball 2 and 3
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '0');
    WHEN "100000" =>  -- ball 1
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '0');
    WHEN "101000" =>  -- ball 1 and 3
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '0');
    WHEN "110000" =>  -- balls 1 and 2
      red <= (OTHERS => '0');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '0');
    WHEN "111000" =>  -- all three balls
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "000010" =>  -- player score
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "000001" =>  -- boxed score
      red <= (OTHERS => '1');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN OTHERS =>  -- white background
      red <= (OTHERS => '1');
      green <= (OTHERS => '1');
      blue <= (OTHERS => '1');
  END CASE;
END PROCESS;

END;
