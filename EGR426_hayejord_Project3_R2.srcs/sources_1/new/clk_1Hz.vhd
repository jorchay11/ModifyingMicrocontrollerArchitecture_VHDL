----------------------------------------------------------------------------------
-- Company: Grand Valley State University
-- Engineer: Joshua Johnston and Jordan Hayes
-- Create Date: 02/05/2022 
-- Project Name: Project 1: UART Serial Decoder 
-- Module Name: Clk_1K
-- Description: Generates a 1 KHz clock signal from the master clock 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
library UNISIM;
use UNISIM.VComponents.all;



entity Clk_1Hz is
    Port ( clk_in       : in std_logic; 
            reset       : in STD_LOGIC; 
            clk_out     : out STD_LOGIC
            );
end Clk_1Hz;

architecture Behavioral of Clk_1Hz is

--16 bit count 
signal clk_count : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
signal clk_out_temp : std_logic := '0';

begin
    process(clk_in, reset)
        begin         
        if(reset = '1') then
            clk_out_temp <= '0'; 
            clk_count <= X"0000";
        
        --elsif    
        elsif ((clk_in'event) and (clk_in = '1') ) then
           if(clk_count = 500) then              
                clk_count <= X"0000"; 
                clk_out_temp <=  not clk_out_temp; 
            else 
                clk_count <= clk_count + 1; 
                clk_out_temp <= clk_out_temp;           
            end if;
            end if; 
       end process;
      
   clk_out <= clk_out_temp;
                    
end Behavioral;

