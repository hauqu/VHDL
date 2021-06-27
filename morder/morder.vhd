LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
entity morder is
port(
	clk : in std_logic;
	en : in std_logic;
	D0:in std_logic_vector(3 downto 0);
	y:out std_logic_vector(3 downto 0)
);
end morder;
architecture rt1 of morder is
begin 
	process(clk,en)
	variable D2:std_logic_vector(3 downto 0);
	variable D1:std_logic_vector(3 downto 0);
		begin 
		if en ='1' then 
		D1 := D0;
		elsif clk'event and clk ='1' then
		D2(3):=(D1(3) xor D1(0));
		D2(2):=D1(3);
		D2(1):=D1(2);
		D2(0):=D1(1);
		D1(3):=D2(3);
		D1(2):=D2(2);
		D1(1):=D2(1);
		D1(0):=D2(0);
		end if;
	y<=D1;
	end process;
end rt1;

