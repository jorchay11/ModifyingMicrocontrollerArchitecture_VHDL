----------------------------------------------------------------------------------
-- Company: Grand Valley State University 
-- Engineer: Jordan Hayes
-- 
-- Create Date: 4/19/2022 
-- Module Name: Project3_top - Behavioral
-- Project Name: Project 3: Microcontroller Architecture 
-- Target Devices: Spartan - 7

-- Description: Top level to connect the CPU output to Mux for outputting 
-- onto the Boolean Board, Clocks are also generated and used as input  
----------------------------------------------------------------------------------
--11110000
--00000000
--00010101
--00010000
--01100000
--00001110
--00000000
--00010110
--00010000
--10100000
--01100000
--00000001
--00010000
--00000001
--00010111
--00010001
--10000000
--00010000
--11110000
--01100000
--00000001
--00000001
--00010101
--00100011
--;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Project3_top is
  Port (mclk                    : in STD_LOGIC; 
        reset                   : in STD_LOGIC; 
        Inport0, Inport1        : in STD_LOGIC_VECTOR(7 downto 0); 
        left_Segs, right_Segs   : out STD_LOGIC_VECTOR(7 downto 0); 
        Outport0, Outport1      : out STD_LOGIC_VECTOR(7 downto 0);
        left_Anode, right_Anode : out STD_LOGIC_VECTOR(3 downto 0)
        );
end Project3_top;

----------------------------------------------------------------------------------
architecture Behavioral of Project3_top is

----------------------------------------------------------------------------------
component cpu is
PORT(clk : in STD_LOGIC;
     clk_1K : in STD_LOGIC; 
	 reset : in STD_LOGIC;
	 Inport0, Inport1 : in STD_LOGIC_VECTOR(7 downto 0);
	 Outport0, Outport1	: out STD_LOGIC_VECTOR(7 downto 0);
	 PC100_seg, PC10_seg, PC1_seg : out STD_LOGIC_VECTOR(7 downto 0); 
	 WDT_reset_out                    : out STD_LOGIC; 
	 A_right, A_left, B_right, B_left : out STD_LOGIC_VECTOR(7 downto 0)
	 );
end component; 

----------------------------------------------------------------------------------
--multiplexer for segs and anodes
component mux_4to1 is
    Port ( reset : in STD_LOGIC; 
           WDT_reset : in STD_LOGIC; 
           clk_1K : in std_logiC;                    
           
           A_left, A_right, B_left, B_right : in STD_LOGIC_VECTOR(7 downto 0); 
           PC100_seg, PC10_seg, PC1_seg : in STD_LOGIC_VECTOR(7 downto 0);  
           
           left_Anode, right_Anode : out STD_LOGIC_VECTOR(3 downto 0);            --output is Anode selection and Seg data 
           left_Segs, right_Segs  : out STD_LOGIC_VECTOR(7 downto 0)                     
           );
end component;

----------------------------------------------------------------------------------
--1 KHz Clock
component Clk_1K is
    Port ( clk_in       : in std_logic; 
            reset       : in STD_LOGIC; 
            clk_out     : out STD_LOGIC
            );
end component;

----------------------------------------------------------------------------------
--1 Hz Clock 
component clk_1Hz is 
    Port ( clk_in       : in std_logic; 
            reset       : in STD_LOGIC; 
            clk_out     : out STD_LOGIC
         );
end component; 

----------------------------------------------------------------------------------
--top level signals
signal clk_1K_input     : std_logic; 
signal clk_1Hz_input : std_logic; 
signal Outport0_top : STD_LOGIC_VECTOR(7 downto 0); 
signal Outport1_top : STD_LOGIC_VECTOR(7 downto 0);

--signals from cpu to mux
signal A_left_SegData, A_right_SegData : STD_LOGIC_VECTOR(7 downto 0);
signal  B_left_SegData, B_right_SegData : STD_LOGIC_VECTOR(7 downto 0);
signal PC100_seg, PC10_seg, PC1_seg : STD_LOGIC_VECTOR(7 downto 0);

--wdt reset
signal WDT_reset : STD_LOGIC;   

begin
--contains majority of Projet functions
CPU1 : cpu PORT MAP (clk => clk_1Hz_input, clk_1K => clk_1K_input, reset => reset, WDT_reset_out => WDT_reset, Inport0 => inPort0, inPort1 => inPort1, outPort0 => Outport0_top, outPort1 => Outport1_top,
                    A_right => A_right_SegData, A_left => A_left_SegData, B_right => B_right_SegData, B_left => B_left_SegData, 
                    PC100_seg => PC100_seg, PC10_seg => PC10_seg, PC1_seg => PC1_seg);  
                    
--clocks
--1K for anode and segment data selection. 
--Also for free running clock for WDT_reset and Debouncing  
clk1000 : clk_1k PORT MAP(clk_in => mclk, reset => reset, clk_out => clk_1K_input);

--run PC at 1 second per cycle execution 
clk1 : clk_1Hz PORT MAP(clk_in => clk_1K_input, reset => reset, clk_out => clk_1Hz_input); 

--mutiplex segments and anodes
CPU_mux : mux_4to1 PORT MAP(reset => reset, WDT_reset => WDT_reset, clk_1K => clk_1K_input, 
                            A_left => A_left_SegData, A_right => A_right_SegData, B_left => B_left_SegData, B_right => B_right_SegData, 
                            PC100_seg => PC100_seg, PC10_seg => PC10_seg, PC1_seg => PC1_seg,
                            left_Anode => left_Anode, right_Anode => right_Anode, left_segs => left_segs, right_segs => right_segs);
                            
 
Outport0 <= Outport0_top; 
Outport1 <= Outport1_top;

end Behavioral;
