library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--q is a when sel is 1, and b when sel is 0
entity mux_2_1 is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           sel : in STD_LOGIC;
           q : out STD_LOGIC);
end mux_2_1;

architecture RTL of mux_2_1 is

begin
    
    q <= (a AND sel) OR (b AND (NOT sel) );

end RTL;
