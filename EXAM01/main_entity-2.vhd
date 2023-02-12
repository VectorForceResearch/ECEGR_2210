library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.mypack.all;
---------------------
entity main_entity is
	generic(	n: integer := 6);
	port(	clock_in: std_logic;
		segment: out std_logic_vector(6 downto 0) );
end entity main_entity;
-------------------------------------------------
architecture segment_controller of main_entity is
---------------------
-- this is where we create components from entities, this is done using work.mypack.all for this example
---------------------
--signal CD_to_ODC: std_logic;
--signal ODC_to_SSD: out integer range 0 to 9;

signal slow_clock: std_logic;
signal count: integer range 0 to 10;
signal count_temp: std_logic_vector(3 downto 0);

begin
--CD_to_ODC <= clk_out;
--clk <= CD_to_ODC;

--ODC_to_SSD <= count;
--count_temp <= ODC_to_SSD;

s1: clock_divider generic map(n) port map (clock_in, slow_clock);
s2: counter 	port map (slow_clock, count);
s3: sevenseg_disp 	port map (count_temp, segment);
count_temp <= conv_std_logic_vector(count,4);

end architecture segment_controller;