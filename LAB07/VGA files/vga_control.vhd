-- this program sets the timing for the screen sweep
-- don't change this program
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------
entity vga_control is
generic (
	Ha: integer := 96;
	Hb: integer := 144; --beginning of hactive
	Hc: integer := 784; -- end of hactive
	Hd: integer := 800;
	Va: integer := 2;
	Vb: integer := 35; --beginning of vactive
	Vc: integer := 515; --end of vactive
	Vd: integer := 525);
port (
	clk50M: in std_logic;
	pixel_clk: buffer std_logic :='0';
	hsync, vsync: buffer std_logic :='0';
	red_in, green_in, blue_in: in std_logic_vector(7 downto 0);
	pixel_row:  buffer integer range 0 to 480; 
	pixel_column: buffer integer range 0 to 641;
	r, g, b: out std_logic_vector(7 downto 0);
	nblank, nsync: out std_logic);
end vga_control;
--------------------------------------------------------------------	
architecture vga of vga_control is
	signal hactive, vactive: std_logic := '0';
	signal display_on: std_logic;
	signal display_on_vector: std_logic_vector(7 downto 0);
	
	-- hactive is the portion of hsync during which pixels are displayed
	-- vactive is the portion of vsync during which pixels are displayed
	-- display_on (display enable) must be low during retrace
begin
	
	nblank <= '1'; -- static signal for DAC
	nsync <= '0'; -- static signal for DAC
	
	display_on <= hactive and vactive;
	display_on_vector <= (others => '1') when display_on = '1' else 
								       (others => '0');
								
	r <= red_in and display_on_vector;
	g <= green_in and display_on_vector;
	b <= blue_in and display_on_vector;	
	
	--creates a 25MHz clock
	process (clk50M)  
		begin
		if (clk50M'event and clk50M = '1') then
			pixel_clk <= not pixel_clk;
		end if;
	end process;
	
	--horizontal signal generator
	process (pixel_clk)
		variable hcount: integer range 0 to Hd;
	begin
		if (pixel_clk'event and pixel_clk = '1') then
			hcount := hcount + 1;
			if (hcount = Ha) then
				hsync <= '1';     
			elsif (hcount = Hb) then
				hactive <= '1';  
			elsif (hcount = Hc) then
				hactive <= '0';
			elsif (hcount = Hd) then
				hsync <= '0';
				hcount := 0;   
			end if;
			if hcount >= Hb and hcount < Hc then
			  pixel_column <= pixel_column + 1;
			else
			  pixel_column <= 0; 
			end if;		    
		end if;
	end process;
	
	-- vertical signal generation
	process (hsync)
		variable vcount: integer range 0 to Vd;
	begin
		if (hsync'event and hsync = '1') then
			vcount := vcount + 1;
			if (vcount = Va) then
				vsync <= '1';       
			elsif (vcount = Vb) then
				vactive <= '1';
			elsif (vcount = Vc) then
				vactive <= '0';
			elsif (vcount = Vd) then
				vsync <= '0';
				vcount := 0;    
			end if;
			if vcount >= Vb and vcount < Vc then
				pixel_row <= pixel_row + 1;
			else
				pixel_row <= 0;
			end if;
		end if;
	end process;	
	
	end;
					
	