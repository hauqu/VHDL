library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity pcmencode is 
port(
clk:in std_logic; --2.048MB/s  1:1
en:in std_logic;  --8K 1:32
d:in std_logic_vector(12 downto 0);--
b:out std_logic);--
end pcmencode;
architecture rs1 of pcmencode is
signal count:std_logic_vector(2 downto 0);--
begin
process(clk,en)
variable c:std_logic_vector(7 downto 0);-- 
begin
if (clk'event and clk='0')then
    if (en='1')then
        if count="000" then
            if d(11)='1'then c:=d(12)&"111"&d(10 downto 7);
            elsif d(10)='1'then c:=d(12)&"110"&d(9 downto 6);
            elsif d(9)='1'then c:=d(12)&"101"&d(8 downto 5);
            elsif d(8)='1'then c:=d(12)&"100"&d(7 downto 4);
            elsif d(7)='1'then c:=d(12)&"011"&d(6 downto 3);
            elsif d(6)='1'then c:=d(12)&"010"&d(5 downto 2);
            elsif d(5)='1'then c:=d(12)&"001"&d(4 downto 1);
            else
                  c:=d(12)&"000"&d(4 downto 1); 
            end if;
        end if;
        if (count="000")then
        b<=c(7);
        elsif (count="001")then
        b<=c(6);
        elsif (count="010")then
        b<=c(5);
        elsif (count="011")then
        b<=c(4);
        elsif (count="100")then
        b<=c(3);
        elsif (count="101")then
        b<=c(2);
        elsif (count="110")then
        b<=c(1);
        elsif (count="111")then 
        b<=c(0);
        else b<='0';
        end if;
        count<=count+1;
    else b<='0'; 
    end if;
end if;
end process;
end rs1;