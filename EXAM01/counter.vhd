---------------------------------------------------
-- EXAM 01 - Counter
-- Author: Jim Lynch
-- Date:   02.11.2023
---------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
---------------------------------------------------
ENTITY counter IS
    PORT( clk: IN STD_LOGIC;
	count: OUT INTEGER RANGE 0 TO 9); --max_count)
END ENTITY counter;
---------------------------------------------------
ARCHITECTURE counter OF counter IS
BEGIN
    PROCESS (clk)
    VARIABLE temp: INTEGER RANGE 0 TO 9; --(max_count+1);
	BEGIN
        IF(rising_edge(clk)) THEN
            temp := temp + 1; 
            IF (temp = 9) THEN --(max_count+1)) THEN
                temp := 0;     
            END IF; 
            count <= temp;
        END IF;
    END PROCESS;
END ARCHITECTURE counter;

-- ENTITY counter IS
--     GENERIC (max_count: INTEGER := 2);
--     PORT( clk: IN STD_LOGIC;
--     	--max_count: IN STD_LOGIC;
-- 		count: OUT INTEGER RANGE 0 TO max_count);
-- END ENTITY counter;
-- ---------------------------------------------------
-- ARCHITECTURE counter OF counter IS
-- BEGIN
--     PROCESS (clk)
--     VARIABLE temp: INTEGER RANGE 0 TO (max_count+1);
-- 	BEGIN
--         --IF (clk'EVENT AND clk = '1') THEN
--         IF(rising_edge(clk)) THEN
--             temp := temp + 1; 
--             IF (temp = (max_count+1)) THEN
--                 temp := 0;     
--             END IF; 
--             count <= temp;
--         END IF;
--     END PROCESS;
-- END ARCHITECTURE counter;


-- Library ieee;
-- USE ieee.std_logic_1164.ALL;
