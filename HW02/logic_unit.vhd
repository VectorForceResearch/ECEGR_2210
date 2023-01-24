----------------------------------------------------------------
--
-- HW 02 Problem 4 - Logic_Unit
-- 
-- Author: Jim Lynch
-- Date:   01.23.2023
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --need this package to use addition

entity logic_unit is
port
 ( a, b: in std_logic_vector( 7 downto 0);
    sel: in std_logic_vector (3 downto 0);
    lout: out std_logic_vector (7 downto 0));
end logic_unit;

architecture ldataflow of logic_unit is
	
BEGIN

with sel(2 downto 0) select
	lout <= not a when "000",
		not b when "001",
		a and b when "010",
		a or b when "011",
		a nand b when "100",
		a nor b when "101",
		a xor b when "110",
		not (a xor b)  when others;

end architecture ldataflow;
