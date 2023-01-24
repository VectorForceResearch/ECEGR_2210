----------------------------------------------------------------
--
-- HW 02 Problem 4 - Arith_Unit
-- 
-- Author: Jim Lynch
-- Date:   01.23.2023
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --need this package to use addition

entity arith_unit is
port
 ( a, b: in std_logic_vector( 7 downto 0);
    sel: in std_logic_vector (3 downto 0);
    cin: in std_logic;
    aout: out std_logic_vector (7 downto 0));
end arith_unit;

architecture adataflow of arith_unit is
BEGIN
with sel(2 downto 0) select
	aout <= a when "000",
		a+1 when "001",
		a-1 when "010",
		b   when "011",
		b+1 when "100",
		b-1 when "101",
		a+b when "110",
		a+b+cin when others;
end architecture adataflow;
