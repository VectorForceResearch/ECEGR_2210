-- Generates 8 horizontal stripes of different colors
-- 3 switches (red_switch, green_switch, blue_switch) control the 
-- color of the top horizontal stripes
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------
entity make_image0 is
	port(
		vsync:  in std_logic;
		pixel_row:  in integer range 0 to 480; 
		pixel_column: in integer range 0 to 640;
		red, green, blue: out std_logic_vector(7 downto 0);
		red_switch, green_switch, blue_switch: in std_logic);
end;
-------------------------------------------------------------------
architecture image of make_image0 is
BEGIN 
	stripes: PROCESS(pixel_row, red_switch, green_switch, blue_switch)		
	BEGIN	
	CASE pixel_column IS  --pixel_row
	WHEN 420 TO 480 =>
				red  <=  (OTHERS => '1');  
				green <= (OTHERS => '0'); 
				blue  <= (OTHERS => '0');
	WHEN 360 TO 419 =>	
				red  <=  (OTHERS => '0');  
				green <= (OTHERS => '1'); 
				blue  <= (OTHERS => '0'); 
	WHEN 300 TO 359 =>	
				red  <=  (OTHERS => '0');  
				green <= (OTHERS => '0'); 
				blue  <= (OTHERS => '1'); 
	WHEN 240 TO 299 =>	
				red  <=  (OTHERS => '1');  
				green <= (OTHERS => '1'); 
				blue  <= (OTHERS => '0'); 
	WHEN 180 TO 239 =>	
				red  <=  (OTHERS => '0');  
				green <= (OTHERS => '1'); 
				blue  <= (OTHERS => '1'); 				
	WHEN 120 TO 179 => 	
				red  <=  (OTHERS => '1');  
				green <= (OTHERS => '0'); 
				blue  <= (OTHERS => '1'); 						
	WHEN 60 TO 119 => 
				red  <=  "11101101";  
				green <= "10111001";
				blue  <= "01101111"; 				
	WHEN OTHERS  => 
				red   <= (7 => red_switch, others => '0');  
				green <= (7 => green_switch, others => '0'); 
				blue  <= (7 => blue_switch, others => '0'); 
	END CASE;	
	
-- same as above but using the IF statement
--		IF pixel_row >= 420 THEN	      			
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 360 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 300 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 
--		ELSIF pixel_row >= 240 THEN
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '0'); 
--		ELSIF pixel_row >= 180 THEN
--				red  <=  (OTHERS => '0');  
--				green <= (OTHERS => '1'); 
--				blue  <= (OTHERS => '1'); 				
--		ELSIF pixel_row >= 120 THEN
--				red  <=  (OTHERS => '1');  
--				green <= (OTHERS => '0'); 
--				blue  <= (OTHERS => '1'); 						
--		ELSIF pixel_row >= 60 THEN
--				red  <=  "11101101";  
--				green <= "10111001";
--				blue  <= "01101111"; 				
--		ELSE 
--				red   <= (7 => red_switch, others => '0');  
--				green <= (7 => green_switch, others => '0'); 
--				blue  <= (7 => blue_switch, others => '0'); 
--		END IF;
	END PROCESS stripes;
END;
