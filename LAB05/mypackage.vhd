library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------
package mypack is
---------------------
component clock_divider
	generic( n: integer := 4);
	port(	clk_in: in std_logic;
		clk_out: out std_logic);
end component clock_divider;
---------------------
component counter
	port(	clk: in std_logic;
		count: out integer range 0 to 9);
end component counter;
---------------------
component sevenseg_disp
	port(	input: in std_logic_vector(3 downto 0);
		output: out std_logic_vector(6 downto 0) );
end component sevenseg_disp;
---------------------
end package mypack;

