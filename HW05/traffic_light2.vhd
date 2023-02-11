
---------------------------------------------------
-- HW 05 Problem 1 - traffic light
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY traffic_light IS
    PORT( clock_signal: IN STD_LOGIC;
        --streetA_g, streetA_y, streetA_r: OUT STD_LOGIC;
        --streetB_g, streetB_y, streetB_r: OUT STD_LOGIC;
        --streetA_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --streetB_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        danny_street: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) );
END ENTITY traffic_light;
---------------------------------------------------
ARCHITECTURE controller OF traffic_light IS
    TYPE state IS (s0,s1,s2,s3);
    SIGNAL pre_state, nxt_state: state;
    SHARED VARIABLE temp: INTEGER RANGE 0 TO 4;
    SIGNAL danny_beat: INTEGER RANGE 0 TO 3;
    ATTRIBUTE enum_encoding: STRING;
	ATTRIBUTE enum_encoding OF state: TYPE IS "sequential";
BEGIN

    -----------------------------------------------
    proc1: PROCESS (clock_signal)	
    BEGIN
        IF (rising_edge(clock_signal)) THEN
            temp := temp + 1; 
  	        IF (temp = 4) THEN
                temp := 0;     
            END IF; 
	        danny_beat <= temp;
        END IF;
    END PROCESS proc1;

    ------sequential logic------
	proc2: PROCESS (clock_signal, danny_beat)
	BEGIN
		IF (danny_beat = 0) THEN
			pre_state <= s0;
		ELSIF (rising_edge(clock_signal)) THEN
			pre_state <= nxt_state;
		END IF;
	END PROCESS proc2;

    ------combinational logic------
    proc3: PROCESS (pr_state)
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
            WHEN OTHERS => 
                danny_street <= "111111";
        END CASE;
    END PROCESS proc3;
END ARCHITECTURE controller;