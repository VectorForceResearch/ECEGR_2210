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
SIGNAL ball_on: STD_LOGIC;
SIGNAL paddle_on: STD_LOGIC;
SIGNAL size : integer range 0 to 20;  
SIGNAL ball_x_motion: integer range -10 to 10;
SIGNAL ball_y_motion: integer range -10 to 10;
SIGNAL ball_y_pos: integer range 0 to 480;
SIGNAL ball_x_pos: integer range 0 to 640;
SIGNAL ball_on_2: STD_LOGIC;
SIGNAL size_2 : integer range 0 to 20;  
SIGNAL ball_x_motion_2: integer range -10 to 10;
SIGNAL ball_y_motion_2: integer range -10 to 10;
SIGNAL ball_y_pos_2: integer range 0 to 480;
SIGNAL ball_x_pos_2: integer range 0 to 640;
SIGNAL ball_on_3: STD_LOGIC;
SIGNAL size_3 : integer range 0 to 20;  
SIGNAL ball_x_motion_3: integer range -10 to 10;
SIGNAL ball_y_motion_3: integer range -10 to 10;
SIGNAL ball_y_pos_3: integer range 0 to 480;
SIGNAL ball_x_pos_3: integer range 0 to 640;
SIGNAL last_rand_num: integer range 0 to 640:= 220;
signal last_rand_num_2 : integer range 0 to 640:= 320;
signal last_rand_num_3 : integer range 0 to 640:= 420;



SIGNAL images: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL paddle_x: integer:= 20;
SIGNAL paddle_x_motion: integer range -10 to 10;

CONSTANT bottom_of_screen: integer := 460;
CONSTANT top_of_screen: integer := 20;
CONSTANT right_of_screen: integer := 630;
CONSTANT left_of_screen: integer := 10;
CONSTANT paddle_width: integer:= 60;
CONSTANT paddle_height: integer:= 7;

type my_rom is array (0 to 9) of std_logic_vector (0 to 9);
CONSTANT round_shape: my_rom :=(
    "1111111111",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
    "1111111111"
);

CONSTANT round_shape_2: my_rom :=(
    "1111111111",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
"1000000001",
    "1111111111"
);

CONSTANT round_shape_3: my_rom :=(
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111",
    "1111111111"
);

  BEGIN
size <= round_shape'length-1;   -- size of ball 1
size_2 <= round_shape_2'length-1;
size_3 <= round_shape_3'length-1;


check_pixel_1: PROCESS (ball_x_pos, ball_y_pos, pixel_column, pixel_row, size, paddle_x)
BEGIN
    -- Check if the current pixel being examined is within the rectangular area of the ball
    IF (pixel_column >= ball_x_pos) AND (pixel_column <= ball_x_pos + size) AND
        (pixel_row >= ball_y_pos) AND (pixel_row <= ball_y_pos + size)
    THEN
        -- Check if the ball is colliding with the paddle
        IF (pixel_column >= paddle_x) AND (pixel_column <= paddle_x + paddle_width) AND
            (pixel_row >= bottom_of_screen - 20 - paddle_height) AND (pixel_row <= bottom_of_screen - 20)
        THEN
            -- If the ball is colliding with the paddle, turn it off until it reaches the bottom of the screen again
            ball_on <= '0';
        ELSE
            ball_on <= round_shape(pixel_row - ball_y_pos)(pixel_column - ball_x_pos);
        END IF;
    ELSE
        ball_on <= '0';
    END IF;
END PROCESS;


check_pixel_2: PROCESS (ball_x_pos_2, ball_y_pos_2, pixel_column, pixel_row, size_2, paddle_x)
BEGIN
    -- Check if the current pixel being examined is within the rectangular area of the ball
    IF (pixel_column >= ball_x_pos_2) AND (pixel_column <= ball_x_pos_2 + size_2) AND
        (pixel_row >= ball_y_pos_2) AND (pixel_row <= ball_y_pos_2 + size_2)
    THEN
        -- Check if the ball is colliding with the paddle
        IF (pixel_column >= paddle_x) AND (pixel_column <= paddle_x + paddle_width) AND
            (pixel_row >= bottom_of_screen - 20 - paddle_height) AND (pixel_row <= bottom_of_screen - 20)
        THEN
            -- If the ball is colliding with the paddle, turn it off until it reaches the bottom of the screen again
            ball_on_2 <= '0';
        ELSE
            ball_on_2 <= round_shape_2(pixel_row - ball_y_pos_2)(pixel_column - ball_x_pos_2);
        END IF;
    ELSE
        ball_on_2 <= '0';
    END IF;
END PROCESS;

check_pixel_3: PROCESS (ball_x_pos_3, ball_y_pos_3, pixel_column, pixel_row, size_3, paddle_x)
BEGIN
    -- Check if the current pixel being examined is within the rectangular area of the ball
    IF (pixel_column >= ball_x_pos_3) AND (pixel_column <= ball_x_pos_3 + size_3) AND
        (pixel_row >= ball_y_pos_3) AND (pixel_row <= ball_y_pos_3 + size_3)
    THEN
        -- Check if the ball is colliding with the paddle
        IF (pixel_column >= paddle_x) AND (pixel_column <= paddle_x + paddle_width) AND
            (pixel_row >= bottom_of_screen - 20 - paddle_height) AND (pixel_row <= bottom_of_screen - 20)
        THEN
            -- If the ball is colliding with the paddle, turn it off until it reaches the bottom of the screen again
            ball_on_3 <= '0'; -- this is where exploded shape goes
        ELSE
            ball_on_3 <= round_shape_3(pixel_row - ball_y_pos_3)(pixel_column - ball_x_pos_3);
        END IF;
    ELSE
        ball_on_3 <= '0';
    END IF;
END PROCESS;

check_paddle: PROCESS (paddle_x, pixel_column, pixel_row)
BEGIN                                
    IF (pixel_column >= paddle_x) AND (pixel_column <= paddle_x + paddle_width) AND  
        (pixel_row >= bottom_of_screen - 20 - paddle_height) AND (pixel_row <= bottom_of_screen - 20)  
    THEN
        paddle_on <= '1';
    ELSE
        paddle_on <= '0';
    END IF;
END PROCESS;

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

Ball1_motion: PROCESS
BEGIN
ball_y_pos <= top_of_screen;
ball_y_motion <= 1;
ball_x_pos <= last_rand_num; -- use last randomized number as starting position
ball_x_motion <= 0;

WAIT UNTIL vsync'event AND vsync = '1';

-- update ball position and randomize x position when the ball reaches the bottom of the screen
IF ball_y_pos + size >= bottom_of_screen THEN
last_rand_num <= rand_Num;
ball_x_pos <= last_rand_num;
ball_y_pos <= top_of_screen;
ELSE
ball_y_pos <= ball_y_pos + ball_y_motion;
END IF;
END PROCESS;

Ball2_motion: PROCESS
BEGIN
ball_y_pos_2 <= top_of_screen;
ball_y_motion_2<= 1;
ball_x_pos_2 <= last_rand_num_2; -- use a new randomized number as starting position for ball 2
ball_x_motion_2<= 0;

WAIT UNTIL vsync'event AND vsync = '1';

-- update ball position and randomize x position when the ball reaches the bottom of the screen
IF ball_y_pos_2 + size_2 >= bottom_of_screen THEN
last_rand_num_2 <= rand_Num_2;
ball_x_pos_2 <= last_rand_num_2;
ball_y_pos_2 <= top_of_screen;
ELSE
ball_y_pos_2 <= ball_y_pos_2 + ball_y_motion_2;
END IF;
END PROCESS;

Ball3_motion: PROCESS
BEGIN
ball_y_pos_3 <= top_of_screen;
ball_y_motion_3<= 1;
ball_x_pos_3 <= last_rand_num_3; -- use a new randomized number as starting position for ball 3
ball_x_motion_3<= 0;

WAIT UNTIL vsync'event AND vsync = '1';

-- update ball position and randomize x position when the ball reaches the bottom of the screen
IF ball_y_pos_3 + size_3 >= bottom_of_screen THEN
last_rand_num_3 <= rand_Num_3;
ball_x_pos_3 <= last_rand_num_3;
ball_y_pos_3 <= top_of_screen;
ELSE
ball_y_pos_3 <= ball_y_pos_3 + ball_y_motion_3;
END IF;
END PROCESS;

images <= ball_on & ball_on_2 & ball_on_3 & paddle_on; -- add third ball to images signal
setcolor: PROCESS (images)
BEGIN
  CASE images IS
    WHEN "0001" =>  -- paddle
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '1');
    WHEN "0010" =>  -- ball 3
      red <= (OTHERS => '0');
      green <= (OTHERS => '0');
      blue <= (OTHERS => '0');
    WHEN "0100" =>  -- ball 2
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "0110" =>  -- ball 2 and 3
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1000" =>  -- ball 1
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1010" =>  -- ball 1 and 3
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1100" =>  -- balls 1 and 2
      red <= (OTHERS => '0'); -- changed from '1'
      green <= (OTHERS => '1'); -- changed from '0'
      blue <= (OTHERS => '0');
    WHEN "1110" =>  -- all three balls
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
