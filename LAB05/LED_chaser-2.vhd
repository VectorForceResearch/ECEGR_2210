--Creates a pattern of LED lights

--mode=0: light moves from right to left
--mode=1: light moves from left to right

library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use work.mypack.all;
------------------------------------------------
ENTITY LED_chaser IS
	GENERIC (n: INTEGER := 2); 
	PORT(	fast_clock, rst: IN STD_LOGIC;
	     	mode: IN STD_LOGIC;
		LED: OUT STD_LOGIC_VECTOR(9 DOWNTO 0) );  
END;
-------------------------------------------------
ARCHITECTURE behavior OF LED_chaser IS
	TYPE state IS (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9);
   	SIGNAL pr_state, nxt_state: state;
	SIGNAL slow_clock: STD_LOGIC;
	ATTRIBUTE enum_encoding: STRING;
	ATTRIBUTE enum_encoding OF state: TYPE IS "sequential";
BEGIN
	myclock: clock_divider generic map(n) port map(fast_clock, slow_clock);

	------sequential logic------
	PROCESS (slow_clock, rst)
	BEGIN
		IF (rst = '0') THEN --key is active low
			pr_state <= s0;
		ELSIF (slow_clock'event AND slow_clock = '1') THEN
			pr_state <= nxt_state;
		END IF;
	END PROCESS;

	------combinational logic------
	PROCESS (pr_state, mode)
	BEGIN
		CASE pr_state IS
			when s0 => LED <= "0000000001";
				IF mode = '0' THEN
					nxt_state <= s1;
				ELSE
					nxt_state <= s9;
				END IF;
			when s1 => LED <= "0000000010";
				IF mode = '0' THEN
					nxt_state <= s2;
				ELSE
					nxt_state <= s0;
				END IF;
			when s2 => LED <= "0000000100";
				IF mode = '0' THEN
					nxt_state <= s3;
				ELSE
					nxt_state <= s1;
				END IF;
			when s3 => LED <= "0000001000";
				IF mode = '0' THEN
					nxt_state <= s4;
				ELSE
					nxt_state <= s2;
				END IF;
			when s4 => LED <= "0000010000";
				IF mode = '0' THEN
					nxt_state <= s5;
				ELSE
					nxt_state <= s3;
				END IF;
			when s5 => LED <= "0000100000";
				IF mode = '0' THEN
					nxt_state <= s6;
				ELSE
					nxt_state <= s4;
				END IF;
			when s6 => LED <= "0001000000";
				IF mode = '0' THEN
					nxt_state <= s7;
				ELSE
					nxt_state <= s5;
				END IF;
			when s7 => LED <= "0010000000";
				IF mode = '0' THEN
					nxt_state <= s8;
				ELSE
					nxt_state <= s6;
				END IF;
			when s8 => LED <= "0100000000";
				IF mode = '0' THEN
					nxt_state <= s9;
				ELSE
					nxt_state <= s7;
				END IF;
			when s9 => LED <= "1000000000";
				IF mode = '0' THEN
					nxt_state <= s0;
				ELSE
					nxt_state <= s8;
				END IF;
		END CASE;
	END PROCESS;

END ARCHITECTURE behavior;