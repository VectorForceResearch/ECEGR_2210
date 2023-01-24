----------------------------------------------------------------
--
-- HW 02 Problem 1 - Adder 4 b
-- 
-- Author: Jim Lynch
-- Date:   01.17.2023
--
----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY adder4b IS
  GENERIC(n: INTEGGER := 7);
  PORT (a, b: IN std_logic_vector(n DOWNTO 0);
        Cin: IN std_logic;
        s: OUT std_logic_vector(n DOWNTO 0);
        Cout: OUT std_logic);
END ENTITY adder4b;

ARCHITECTURE structure OF adder4b IS
  
  COMPONENT fulladder 
    PORT (x, y, cin:  IN std_logic;
          sum, cout: OUT std_logic);
  END COMPONENT fulladder;

  SIGNAL C: std_logic_vector(n+1 DOWNTO 0);

BEGIN
  C(0) <= cin;
  cout <= C(n+1);
  FullAdd4: FOR i IN 0 TO 3 GENERATE
    FAi: fulladder PORT MAP (x(i), b(i), C(i),  s(i), C(i+1));
  END GENERATE;

END ARCHITECTURE structure;