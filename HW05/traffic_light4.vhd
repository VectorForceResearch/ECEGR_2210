
---------------------------------------------------
-- HW 05 Problem 2 - traffic light
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY traffic_light IS
    GENERIC (timeMAX: POSITIVE := 50);
    PORT( clock_signal, standby: IN STD_LOGIC;
        danny_street: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) );
END ENTITY traffic_light;
---------------------------------------------------
ARCHITECTURE controller OF traffic_light IS
    TYPE state IS (s0,s1,s2,s3);
    SIGNAL pre_state, nxt_state: state;
    SIGNAL timer: INTEGER RANGE 0 TO timeMAX;
    ATTRIBUTE enum_encoding: STRING;
    ATTRIBUTE enum_encoding OF state: TYPE IS "sequential";

BEGIN
    ------sequential logic------
    proc1: PROCESS (clock_signal, standby)	
    VARIABLE count: INTEGER RANGE 0 TO (timeMAX+1);
    BEGIN
	IF (standby = '1') THEN
	    pre_state <= s0;
	    count := 0;	
        ELSIF (rising_edge(clock_signal)) THEN
            count := count + 1; 
  	    IF (count >= timer) THEN 
		pre_state <= nxt_state;
		count := 1;   
	    END IF;
    END IF;
    END PROCESS proc1;

    ------combinational logic------
    proc3: PROCESS (pre_state)
	BEGIN
        CASE pre_state IS
            WHEN s0 => 
                danny_street <= "100001";
                nxt_state <= s1;
            WHEN s1 => 
                danny_street <= "010001";
                nxt_state <= s2;
            WHEN s2 => 
                danny_street <= "001100";
                nxt_state <= s3;
            WHEN s3 => 
                danny_street <= "001010";
		nxt_state <= s0;
            WHEN OTHERS => 
                danny_street <= "111111";
        END CASE;
    END PROCESS proc3;
END ARCHITECTURE controller;


force clock_signal 0 0ns, 1 6ns -r 12ns
force standby 1 3ns 0
run 100ns