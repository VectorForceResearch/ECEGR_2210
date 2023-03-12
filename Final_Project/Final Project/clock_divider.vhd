library IEEE;  

use IEEE.STD_LOGIC_1164.all;

ENTITY clock_divider IS

 GENERIC (n: INTEGER := 1*10**7);  

PORT(clk_in: IN STD_LOGIC;

 clk_out: OUT STD_LOGIC);
END;

ARCHITECTURE clock_divider OF clock_divider IS  

SIGNAL count: integer range 0 to n;
SIGNAL internal: STD_LOGIC:='0';  
BEGIN
PROCESS (clk_in)
 BEGIN

   IF (clk_in'event AND clk_in = '1') THEN
        count <= count + 1; --initial value of count is 0
        IF (count = n-1) THEN
            internal <= not internal;
            clk_out <= internal;
            count <= 0;  
        END IF;
   END IF;
 END PROCESS;  
END;


