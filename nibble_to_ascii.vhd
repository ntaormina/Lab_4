----------------------------------------------------------------------------------
--Nik Taormina
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity nibble_to_ascii is
    port ( nibble : in std_logic_vector(3 downto 0);
           ascii  : out std_logic_vector(7 downto 0)
         );
end nibble_to_ascii;

architecture Behavioral of nibble_to_ascii is

begin

process(nibble)
begin
	case nibble is
		when x"0" => ascii <= x"30";
		when x"1" => ascii <= x"31";
		when x"2" => ascii <= x"32";
		when x"3" => ascii <= x"33";
		when x"4" => ascii <= x"34";
		when x"5" => ascii <= x"35";
		when x"6" => ascii <= x"36";
		when x"7" => ascii <= x"37";
		when x"8" => ascii <= x"38";
		when x"9" => ascii <= x"39";
		when x"A" => ascii <= x"41";
		when x"B" => ascii <= x"42";
		when x"C" => ascii <= x"43";
		when x"D" => ascii <= x"44";
		when x"E" => ascii <= x"45";
		when x"F" => ascii <= x"46";		
		when others => ascii <= x"30";
	end case;
end process;

end Behavioral;

