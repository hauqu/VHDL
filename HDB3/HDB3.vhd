--HDB3.vhd--HDB3 Encoder by VHDL------

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity hdb3 is
port(
		codein: in std_logic;  
		clk   : in std_logic;
		clr   : in std_logic;               --��λ�ź�
		codeout: out std_logic_vector(1 downto 0)
     );
end hdb3;
--========================================================
architecture rtl of hdb3 is

signal count0  : integer:=0;
signal codeoutv: std_logic_vector(1 downto 0);
signal s0      : std_logic_vector(4 downto 0):="00000";	--��ʼΪ������˫����
signal s1      : std_logic_vector(4 downto 0):="00000";	
signal clkb    : std_logic;
signal count1  : integer range 1 downto 0;
signal codeoutb: std_logic_vector(1 downto 0);
signal flagv   : integer range 1 downto 0;
signal firstv  : integer range 0 to 1;
signal flag1b  : integer range 1 downto 0;
--=============================================
component dff                            --����Ԫ��dff
  port (
			d   : in std_logic;
			clk : in std_logic;
			q   : out std_logic
       );
end component;
------------------------------------------------------------
begin
  add_v:process(clk,clr)                 --�����V����(ֻ���ǲ�V(11)����)
        begin
          if(rising_edge(clk)) then      --ʱ������
            if(clr='1') then             --���㣬���ʼ��
              codeoutv<="00";            --��00����0
              count0<=0;                 --��'0'����������
            else 
              case codein is 
				when '1'=>
                    codeoutv<="01";      --��01����1
                    count0<=0;
                when '0'=>
                    if(count0=3)then     --����4��������0ʱ����V
                        codeoutv<="11";  --��11����V
                        count0<=0;
                    else
                    	codeoutv<="00";
                        count0<=count0+1;
                        
                    end if;
                when others=>
                    codeoutv<="00"; --�Լ��趨״̬(����ʱ���������)
                    count0<=count0;
              end case;
             end if;
           end if;
  end process add_v;
--=============================================
  s0(0)<=codeoutv(0);
  s1(0)<=codeoutv(1);  
  ds11: dff port map(s1(0),clk,s1(1));   --���ÿ��е�D��������ʵ���ӳ�����
  ds01: dff port map(s0(0),clk,s0(1));
  ds12: dff port map(s1(1),clk,s1(2));
  ds02: dff port map(s0(1),clk,s0(2));
  ds13: dff port map(s1(2),clk,s1(3));
  ds03: dff port map(s0(2),clk,s0(3));
  bclk: clkb<=not clk;
-----------------------------------------------------------
  add_b:process(clkb)                    --�������B����
      begin
        if(rising_edge(clkb)) then
          if(codeoutv="11") then
          
          --��֤������V��֮���ж�        --Ϊ��ʹ�������в���ֱ������������ʹ���ڵ��ƻ���V���弫�Խ���
          --�Ӷ�����ʹ�����ƻ���֮����������'1'��
            if(firstv=0) then            --��"11"(V)�ĸ������Ƿ��ǵ�һ��V��
              count1<=0;                 --��"01"(1)�ĸ������ж���ż��
              firstv<=1;
              s1(4)<=s1(3);
              s0(4)<=s0(3);
            else                         --��һ��ʱ������
              if(count1=0) then          --��10����B
                  s1(4)<='1';
                  s0(4)<='0';
                  count1<=0;
              else
                  s1(4)<=s1(3);          --����
                  s0(4)<=s0(3);
                  count1<=0;             --һ�δ�����Ϻ�1���ۻ������������¿�ʼ����(1�ĸ���)
              end if;
            end if;
            
          elsif(codeoutv="01") then
            count1<=count1+1;            --ΪV���ж�ģ���־
            s1(4)<=s1(3);
            s0(4)<=s0(3);
          else
            s1(4)<=s1(3);
            s0(4)<=s0(3);
            count1<=count1;
          end if;
        end if;
  end process add_b;
  codeoutb<=s1(4)&s0(4);
-------------------------------------------------------------------------
  output:process(clk)                    --�����Ա�˫���ԵĽ���
      begin
        if(rising_edge(clk)) then
          if((codeoutb="01")or(codeoutb="10"))then   --1 or B(�������)�ɼ��ź�
            if(flag1b=1) then            --��"+V"��"-V"֮��'1'����ż��
              codeout<="01";             -- +1
              flag1b<=0;
            else
              codeout<="11";             -- -1 --ʵ��˫����
              flag1b<=1;
            end if;
          elsif(codeoutb="11") then      --V
            if(flag1b=1) then
              codeout<="11";
            else 
              codeout<="01";
            end if;
          else 
            codeout<="00";               -- 0 
            flag1b<=flag1b;
          end if;
        end if;
  end process output;

  end rtl;   