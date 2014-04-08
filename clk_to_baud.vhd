----------------------------------------------------------------------------------
--Nik Taormina
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity clk_to_baud is
    port ( clk         : in std_logic;  -- 25 MHz
           reset       : in std_logic;
           baud_16x_en : out std_logic -- 16*9.6 kHz
        );
end clk_to_baud;

architecture Behavioral of clk_to_baud is

signal baud_count : integer range 0 to 652 ;
signal en_16_x_baud : std_logic ;

begin

baud_rate: process(clk, reset)
	begin
		if(reset = '1') then
			baud_count <= 0;
		elsif rising_edge(clk) then
			if baud_count = 651 then
				baud_count <= 0;
				en_16_x_baud <= '1';
			else
				baud_count <= baud_count + 1;
				en_16_x_baud <= '0';
			end if;
		end if;
end process baud_rate;

baud_16x_en <= en_16_x_baud;

end Behavioral;

