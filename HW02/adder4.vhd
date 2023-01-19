----------------------------------------------------------------
--
-- HW 02 Problem 1 - Adder 4
-- 
-- Author: Jim Lynch
-- Date:   01.17.2023
--
----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY adder4 IS
    PORT (a, b: IN std_logic_vector(3 DOWNTO 0);
          cin: IN std_logic;
          s: OUT std_logic_vector(3 DOWNTO 0)
          cout: OUT std_logic);
END ENTITY adder4;

ARCHITECTURE structure OF adder4 IS
  
  COMPONENT fulladder 
    PORT (x, y, Cin:  IN std_logic;
          sum, Cout: OUT std_logic);
  END COMPONENT fulladder;

  SIGNAL C: std_loic_vector(4 DOWNTO 0);

BEGIN
  C(0) <= cin;
  cout <= C(4);
  FullAdd4: FOR i IN 0 TO 3 GENERATE
    FAi: fulladder PORT MAP (x(i), y(i), C(i),  s(i), C(i+1);
  END GENERATE;

END ARCHITECTURE structure;