---------------------------------------------------
-- HW 05 Problem 5 - traffic light
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.mypack.all;
---------------------------------------------------
ENTITY traffic_light IS
    GENERIC( timeAG: POSITIVE := 9;
        timeAGBR: POSITIVE := 9;
        timeAYBY: POSITIVE := 3;
        timeARBG: POSITIVE := 6;
        timeYY: POSITIVE := 1;
        timeMAX: POSITIVE := 2700;
        timeTEST: POSITIVE := 60;
        n: INTEGER := 2);
    PORT( clock_signal, standby: IN STD_LOGIC;
        --streetA_g, streetA_y, streetA_r: OUT STD_LOGIC;
        --streetB_g, streetB_y, streetB_r: OUT STD_LOGIC;
        --streetA_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --streetB_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        danny_street: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) );
END ENTITY traffic_light;
---------------------------------------------------
ARCHITECTURE controller OF traffic_light IS
    SIGNAL slow_clock: STD_LOGIC;
    SIGNAL count: INTEGER RANGE 0 TO 10;
    SIGNAL count_temp: STD_LOGIC_VECTOR(3 DOWNTO 0)
    SIGNAL timer: INTEGER RANGE 0 TO timeMAX;
    TYPE state IS (AGBR,AYBY,ARBG,YY);
    SIGNAL pre_state, nxt_state, store_state: state;
    ATTRIBUTE enum_encoding: STRING;
    ATTRIBUTE enum_encoding OF state: TYPE IS "sequential";
BEGIN
    rtl0: clock_divider     GENERIC MAP(n) PORT MAP(clock_signal, slow_clock);
    rtl1: counter 	        PORT MAP(slow_clock, count);
    rtl2: sevenseg_disp 	PORT MAP(count_temp, segment);
    -------------sequential logic--------------
    proc1: PROCESS (clock_signal, standby)	
    VARIABLE count: INTEGER RANGE 0 TO (timeMAX+1);
    BEGIN
	    IF (standby = '1') THEN
	        pre_state <= s4;
	        count := 0;	
        ELSIF (rising_edge(clock_signal)) THEN
            count := count + 1; 
  	        IF (count >= timer) THEN 
		        pre_state <= nxt_state;
		        count := 0;   
	        END IF;
        END IF;
    END PROCESS proc1;
    -------------combinational logic-----------
    proc2: PROCESS (pre_state, standby)
    VARIABLE direction, sel: INTEGER RANGE 0 TO 1;
	BEGIN
        CASE pre_state IS
            WHEN AGBR => 
                danny_street <= "100001";
                IF (standby = '0') THEN
                    timer <= timeAGBR;
                    direction := 1;
                    nxt_state <= AYBY;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY
                END IF;
            WHEN AYBY => 
                danny_street <= "010010";
                IF (standby = '0') THEN
                    timer <= timeAYBY;
                    IF (direction = 1) THEN
                        nxt_state <= ARBG;
                    ELSE
                        nxt_state <= AGBR;
                    END IF;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY
                END IF;
            WHEN ARBG => 
                danny_street <= "001100";
                IF (standby = '0') THEN
                    timer <= timeAYBY;
                    direction := 0;
                    nxt_state <= AYBY;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY
                END IF;
            WHEN YY =>
                sel := 0;
                LOOP -- WHILE (standby /= '0') LOOP
                    IF (standby = '1') THEN
                        IF (sel = 0) THEN
                            danny_street <= "010010";
                            timer <= timeAYBY;
                            sel = 1;
                        ELSE
                            danny_street <= "000000";
                            timer <= timeAYBY;
                        END IF;                        
                    ELSE
                        nxt_state <= store_state;
                        EXIT;
                    END IF;
                END LOOP;
            WHEN OTHERS => 
                danny_street <= "111111";
        END CASE;
    END PROCESS proc2;
END ARCHITECTURE controller;

-- WHILE (standby /= '0') LOOP
--     IF (sel = 0) THEN
--         danny_street <= "010010";
--         timer <= timeAYBY;
--         sel = 1;
--     ELSE
--         danny_street <= "000000";
--         timer <= timeAYBY;
--     END IF;                        
-- END LOOP;
-- nxt_state <= store_state;





-- radix symbolic
-- force clock_signal 0 0ns, 1 6ns -r 12ns
-- force standby 0 0ns, 1 200ns
-- force standby 0
-- run 500ns

-- Your generic statement should include the following:
--     • n (for the clock divider code). Set this to 2 or 3.
--     • the number of clock cycles green A and red B should stay ON (9 clock cycles)
--     • the number of clock cycles yellow A and yellow B should stay ON (3 clock cycles)
--     • the number of clock cycles Green B and Red A should be ON (6 clock cycles)
--     • The number of clock cycles when both yellow lights should be flashing in case of
--     malfunction. The green and red lights must be OFF. Both yellow lights are ON for one clock
--     cycle and are OFF for the next clock cycle, repeating this ON-OFF sequence.
--     • maximum number of cycles (similar to timeMAX in Pedroni’s code, but in cycles instead of
--     seconds)

                -- FullAdd4: FOR i IN 0 TO timeMAX GENERATE
                --     counteri: counter PORT MAP (slow_clock, timeMAX);
                -- END GENERATE;
                -- PROCESS IS
                --     VARIABLE i : INTEGER := 0;
                --     BEGIN
                --         WHILE i < 10 LOOP
                --         i := i + 2;
                --     END LOOP;
                -- WAIT;





-- ENTITY YY_WhileLoop_YY IS
-- END ENTITY YY_WhileLoop_YY;

-- ARCHITECTURE sim OF YY_WhileLoop_YY IS
-- BEGIN

--     PROCESS IS
--         variable i : integer := 0;
--     begin

--         while i < 10 loop
--             report "i=" & integer'image(i);
--             i := i + 2;
--         end loop;
--         wait;

--     end process;

-- end architecture;




