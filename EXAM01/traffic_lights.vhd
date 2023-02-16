---------------------------------------------------
-- EXAM 01 -Traffic Light Controller
-- Author: Jim Lynch
-- Date:   02.12.2023
---------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.mypack.all;
---------------------------------------------------
ENTITY traffic_light IS
    GENERIC(
        timeG: POSITIVE := 6;
        timeY: POSITIVE := 3;
        timeR: POSITIVE := 9;
        timeYY: POSITIVE := 1;
        timeMAX: POSITIVE := 2700;
        timeTEST: POSITIVE := 60;
        n: INTEGER := 2);
    PORT( clock_signal, standby: IN STD_LOGIC;
        streetA_g, streetA_y, streetA_r: OUT STD_LOGIC;
        streetB_g, streetB_y, streetB_r: OUT STD_LOGIC;
        --streetA_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --streetB_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --danny_street: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) );
END ENTITY traffic_light;
---------------------------------------------------
ARCHITECTURE controller OF traffic_light IS
    SIGNAL slow_clock: STD_LOGIC;
    SIGNAL count: INTEGER RANGE 0 TO 10;
    --SIGNAL count_temp: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL timer: INTEGER RANGE 0 TO timeMAX;
    SHARED VARIABLE direction: INTEGER RANGE 0 TO 1;
    TYPE state IS (AGBR,AYBR,ARBG,ARBY,YY0,YY1);
    SIGNAL pre_state, nxt_state: state;
    ATTRIBUTE enum_encoding: STRING;
    ATTRIBUTE enum_encoding OF state: TYPE IS "sequential";
BEGIN
    rtl0: clock_divider     GENERIC MAP(n) PORT MAP(clock_signal, slow_clock);
    rtl1: counter 	        PORT MAP(slow_clock, count);

    enoutSignal <= (enout32 & enout16 & enout8); -- Concatenate the enables for the enable input

    -------------sequential logic--------------
    proc1: PROCESS (clock_signal, standby)	
    VARIABLE count: INTEGER RANGE 0 TO (timeMAX+1);
    BEGIN
	    IF (standby = '1') THEN
            IF (direction = 0) THEN
    	        pre_state <= AGBR;
	            count := 0;	
            ELSE
                pre_state <= nxt_state;
            END IF;
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
	BEGIN
        CASE pre_state IS
            WHEN AGBR => 
                --danny_street <= "100001";
                streetA_g <= '1';
                streetA_y <= '0';
                streetA_r <= '0';
                streetB_g <= '0';
                streetB_y <= '0';
                streetB_r <= '1';
                IF (standby = '0') THEN
                    timer <= timeG
                    nxt_state <= AYBR;
                    direction := 1;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY1;
                END IF;
            WHEN AYBR => 
                --danny_street <= "010010";
                streetA_g <= '0';
                streetA_y <= '1';
                streetA_r <= '0';
                streetB_g <= '0';
                streetB_y <= '0';
                streetB_r <= '1';
                IF (standby = '0') THEN
                    timer <= timeY;
                    nxt_state <= ARBG;
                    direction := 1;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY1;
                END IF;
            WHEN ARBG => 
                --danny_street <= "001100";
                streetA_g <= '0';
                streetA_y <= '0';
                streetA_r <= '1';
                streetB_g <= '1';
                streetB_y <= '0';
                streetB_r <= '0';
                IF (standby = '0') THEN
                    timer <= timeG;
                    nxt_state <= AYBY;
                    direction := 1;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY1;
                END IF;
            WHEN ARBY => 
                --danny_street <= "001100";
                streetA_g <= '0';
                streetA_y <= '0';
                streetA_r <= '1';
                streetB_g <= '0';
                streetB_y <= '1';
                streetB_r <= '0';
                IF (standby = '0') THEN
                    timer <= timeY;
                    nxt_state <= ARBG;
                    direction := 1;
                ELSE
                    store_state <= pre_state;
                    nxt_state <= YY1;
                END IF;
            WHEN YY1 =>
                --danny_street <= "010010";
                streetA_g <= '0';
                streetA_y <= '1';
                streetA_r <= '0';
                streetB_g <= '0';
                streetB_y <= '1';
                streetB_r <= '0';
                IF (standby /= '0') THEN
         	        timer <= timeYY;
		            nxt_state <= YY0; 
		        ELSE
                    direction := 0;
		        END IF;
	        WHEN YY0 =>
                --danny_street <= "000000";
                streetA_g <= '0';
                streetA_y <= '0';
                streetA_r <= '0';
                streetB_g <= '0';
                streetB_y <= '0';
                streetB_r <= '0';
     		    IF (standby /= '0') THEN
         	        timer <= timeYY;
		            nxt_state <= YY1;   
		        ELSE
		            direction := 0;
		        END IF;
	        WHEN OTHERS => danny_street <= "111111";
        END CASE;
    END PROCESS proc2;
END ARCHITECTURE controller;

force clock_signal 0 0ns, 1 6ns -r 12ns
force standby 0 0ns, 1 450ns, 0 700ns
run 1000ns