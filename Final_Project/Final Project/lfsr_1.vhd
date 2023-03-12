library ieee; 
    use ieee.std_logic_1164.all; 
 
entity lfsr_1 is 
  port ( 
    cout   :out std_logic_vector (1 TO 9);-- Output of the counter 
   -- enable :in  std_logic;                    -- Enable counting 
    clk    :in  std_logic                    -- Input clock 
   -- reset  :in  std_logic                     -- Input reset 
  ); 
end entity; 
 
architecture rtl of lfsr_1 is 
    signal count           :std_logic_vector (1 to 9); 
    signal linear_feedback :std_logic; 
 
begin 
    linear_feedback <= not(count(3) xor count(5) xor count(6) xor count(9)); 
 
 
    process (clk) begin 
       -- if (reset = '1') then 
           -- count <= (others => '0'); 
        If (rising_edge(clk)) then 
           --if (enable = '1') then 
                count <= linear_feedback & count(1 to 8); 
            --end if; 
        end if; 
    end process; 
    cout <= count; 
end architecture;