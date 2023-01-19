----------------------------------------------------------------
--
-- HW 02 Problem 1 - Full Adder
-- 
-- Author: Jim Lynch
-- Date:   01.17.2023
--
----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fulladder IS
    PORT (x, y, Cin: IN std_logic;
          sum, Cout: OUT std_logic);
END ENTITY fulladder;

ARCHITECTURE logicfunc OF fulladder IS
BEGIN
  sum  <= x XOR y XOR Cin;
  Cout <= (x AND y) OR (Cin AND x) OR (Cin AND y);
END ARCHITECTURE logicfunc;