----------------------------------------------------------------
--
-- HW 02 Problem 4 - AL_Unit
-- 
-- Author: Jim Lynch
-- Date:   01.23.2023
--
----------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --need this package to use addition

entity al_unit is
port
 ( sel: in std_logic_vector (3 downto 0);
    y: out std_logic_vector (7 downto 0));
end al_unit;

architecture dataflow of al_unit is

component logic_unit
    port
        ( a, b: in std_logic_vector( 7 downto 0);
        sel: in std_logic_vector (3 downto 0);
        lout: out std_logic_vector (7 downto 0));
end component logic_unit;

component arith_unit
port
    ( a, b: in std_logic_vector( 7 downto 0);
    sel: in std_logic_vector (3 downto 0);
    cin: in std_logic;
    aout: out std_logic_vector (7 downto 0));
end component arith_unit;

signal arith, logic: std_logic_vector(7 downto 0);

begin
arith <= aout;
logic <= lout;
with sel(3) select
	y <= 	arith when '0',
		logic when others;
end architecture al_unit;