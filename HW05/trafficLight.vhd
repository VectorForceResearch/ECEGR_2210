---------------------------------------------------
-- HW 05 Problem 1 - traffic light
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY traffic_light IS
    GENERIC(clk: INTEGER := 2*10**7);
    PORT( clock_signal: IN STD_LOGIC;
        --streetA_g, streetA_y, streetA_r: OUT STD_LOGIC;
        --streetB_g, streetB_y, streetB_r: OUT STD_LOGIC;
        --streetA_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --streetB_output: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        danny_street: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) );
END ENTITY traffic_light;
---------------------------------------------------
ARCHITECTURE controller OF traffic_light IS
    SIGNAL temp: INTEGER RANGE 0 TO 4;
    SIGNAL danny_beat: INTEGER RANGE 0 TO 3;
BEGIN
    -----------------------------------------------
    proc1: PROCESS (clock_signal)	
    BEGIN
        IF (rising_edge(clock_signal)) THEN
            IF (temp = 4) THEN
                temp <= 0;
            ELSE
                temp <= temp + 1;
            END IF;
            danny_beat <= temp;
        END IF;
    END PROCESS proc1;
    -----------------------------------------------
    proc2: PROCESS (danny_beat)
	BEGIN
        CASE danny_beat IS
            WHEN 0 => 
                danny_street <= "100001";
            WHEN 1 => 
                danny_street <= "010001";
            WHEN 2 => 
                danny_street <= "001100";
            WHEN 3 => 
                danny_street <= "001010";
            WHEN OTHERS => 
                danny_street <= "111111";
        END CASE;
    END PROCESS proc2;
END ARCHITECTURE controller;

force clock_signal 0 0ns, 1 10ns -r 20ns
run 200ns


