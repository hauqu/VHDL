library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity demultiplex is
port(
    datain: in std_logic;
    clkin:  in std_logic;

    hua_lu01,hua_lu02,hua_lu03,hua_lu04,hua_lu05,
    hua_lu06,hua_lu07,hua_lu08,hua_lu09,hua_lu10,
    hua_lu11,hua_lu12,hua_lu13,hua_lu14,hua_lu15,
    hua_lu16,hua_lu17,hua_lu18,hua_lu19,hua_lu20,
    hua_lu21,hua_lu22,hua_lu23,hua_lu24,hua_lu25,
    hua_lu26,hua_lu27,hua_lu28,hua_lu29,hua_lu30
    : out std_logic;

    dataout: out std_logic;
    clkout:  out std_logic
);
end demultiplex;

architecture fj of demultiplex is

signal reg, single32: std_logic_vector(7 downto 0) :="00000000";
--reg,����ͬ���� single32 ,��֡������
signal double64     : std_logic_vector(8 downto 0) :="000000000";
--˫֡������
signal state        : std_logic:='0';
--0 ����̬ 1 ͬ��̬
signal tong_bu,shi_bu:std_logic_vector(1 downto 0):="00";
--ͬ����������ʧ��������
begin 

    P1:process(clkin)
        begin
            if clkin'event and clkin = '1' then
                reg <= reg(6 downto 0)&datain;
            end if;
        end process P1;

    P2:process(clkin)
        begin
            if clkin'event and clkin = '0' then
                double64 <= double64 + 1;   
                single32 <= double64(7 downto 0);
                if state = '0' then
                    if tong_bu = "00" then
                        if reg = "10011011" then
                            tong_bu <= tong_bu +1;
                            double64 <= "000000111";
                        end if;
                    elsif double64 = "000000110" then
                            if reg = "10011011" then
                                if tong_bu = "10" then
                                    state<='1';
                                    tong_bu <= "00";
                                else 
                                    tong_bu <= tong_bu + 1;
                                end if;
                            else
                                tong_bu <= "00";
                            end if;
                    end if;
                else
                    if double64 = "000000110" and reg/="10011011" then
                        if shi_bu = "10" then
                            state <= '0';
                            shi_bu <= "00";
                        else
                            shi_bu <= shi_bu + 1;
                        end if;
                    end if;
                end if;
            end if;
        end process P2;

    P3:process(clkin,single32,state)
        begin
            if clkin'event and clkin = '1' then
                if state = '1' then 
                    dataout <= datain;
                    if single32 >= "00001000" and single32 <= "00001111" then
                        hua_lu01 <= datain;
                    else hua_lu01 <= '0' ;
                    end if;
                    if single32 >= "00010000" and single32 <= "000010111" then
                        hua_lu02 <= datain;
                    else hua_lu02 <= '0' ;
                    end if;
                    if single32 >= "00011000" and single32 <= "00011111" then
                        hua_lu03 <= datain;
                    else hua_lu03 <= '0' ;
                    end if;
                    if single32 >= "00100000" and single32 <= "00100111" then
                        hua_lu04 <= datain;
                    else hua_lu04 <= '0' ;
                    end if;
                    if single32 >= "00101000" and single32 <= "00101111" then
                        hua_lu05 <= datain;
                    else hua_lu05 <= '0' ;
                    end if;

                    if single32 >= "00110000" and single32 <= "00110111" then
                        hua_lu06 <= datain;
                    else hua_lu06 <= '0' ;
                    end if;
                    if single32 >= "00111000" and single32 <= "00111111" then
                        hua_lu07 <= datain;
                    else hua_lu07 <= '0' ;
                    end if;
                    if single32 >= "01000000" and single32 <= "01000111" then
                        hua_lu08 <= datain;
                    else hua_lu08 <= '0' ;
                    end if;
                    if single32 >= "01001000" and single32 <= "01001111" then
                        hua_lu09 <= datain;
                    else hua_lu09 <= '0' ;
                    end if;
                    if single32 >= "01010000" and single32 <= "01010111" then
                        hua_lu10 <= datain;
                    else hua_lu10 <= '0' ;
                    end if;

                    if single32 >= "01011000" and single32 <= "01011111" then
                        hua_lu11 <= datain;
                    else hua_lu11 <= '0' ;
                    end if;
                    if single32 >= "01100000" and single32 <= "01100111" then
                        hua_lu12 <= datain;
                    else hua_lu12 <= '0' ;
                    end if;
                    if single32 >= "01101000" and single32 <= "01101111" then
                        hua_lu13 <= datain;
                    else hua_lu13 <= '0' ;
                    end if;
                    if single32 >= "01110000" and single32 <= "01110111" then
                        hua_lu14 <= datain;
                    else hua_lu14 <= '0' ;
                    end if;
                    if single32 >= "01111000" and single32 <= "01111111" then
                        hua_lu15 <= datain;
                    else hua_lu15 <= '0' ;
                    end if;

                    if single32 >= "10001000" and single32 <= "10001111" then
                        hua_lu16 <= datain;
                    else hua_lu16 <= '0' ;
                    end if;
                    if single32 >= "10010000" and single32 <= "10010111" then
                        hua_lu17 <= datain;
                    else hua_lu17 <= '0' ;
                    end if;
                    if single32 >= "10011000" and single32 <= "10011111" then
                        hua_lu18 <= datain;
                    else hua_lu18 <= '0' ;
                    end if;
                    if single32 >= "10100000" and single32 <= "10100111" then
                        hua_lu19 <= datain;
                    else hua_lu19 <= '0' ;
                    end if;
                    if single32 >= "10101000" and single32 <= "10101111" then
                        hua_lu20 <= datain;
                    else hua_lu20 <= '0' ;
                    end if;

                    if single32 >= "10110000" and single32 <= "10110111" then
                        hua_lu21 <= datain;
                    else hua_lu21 <= '0' ;
                    end if;
                    if single32 >= "10111000" and single32 <= "10111111" then
                        hua_lu22 <= datain;
                    else hua_lu22 <= '0' ;
                    end if;
                    if single32 >= "11000000" and single32 <= "11000111" then
                        hua_lu23 <= datain;
                    else hua_lu23 <= '0' ;
                    end if;
                    if single32 >= "11001000" and single32 <= "11001111" then
                        hua_lu24 <= datain;
                    else hua_lu24 <= '0' ;
                    end if;
                    if single32 >= "11010000" and single32 <= "11010111" then
                        hua_lu25 <= datain;
                    else hua_lu25 <= '0' ;
                    end if;

                    if single32 >= "11011000" and single32 <= "11011111" then
                        hua_lu26 <= datain;
                    else hua_lu26 <= '0' ;
                    end if;
                    if single32 >= "11100000" and single32 <= "11100111" then
                        hua_lu27 <= datain;
                    else hua_lu27 <= '0' ;
                    end if;
                    if single32 >= "11101000" and single32 <= "11101111" then
                        hua_lu28 <= datain;
                    else hua_lu28 <= '0' ;
                    end if;
                    if single32 >= "11110000" and single32 <= "11110111" then
                        hua_lu29 <= datain;
                    else hua_lu29 <= '0' ;
                    end if;
                    if single32 >= "11111000" and single32 <= "11111111" then
                        hua_lu30 <= datain;
                    else hua_lu30 <= '0' ;
                    end if;

                end if;
            end if;
        end process P3;
        
    clkout <= clkin;

end fj;