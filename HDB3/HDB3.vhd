--HDB3.vhd--HDB3 Encoder by VHDL------

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity hdb3 is
port(
		codein: in std_logic;  
		clk   : in std_logic;
		clr   : in std_logic;               --复位信号
		codeout: out std_logic_vector(1 downto 0)
     );
end hdb3;
--========================================================
architecture rtl of hdb3 is

signal count0  : integer:=0;
signal codeoutv: std_logic_vector(1 downto 0);
signal s0      : std_logic_vector(4 downto 0):="00000";	--初始为单极性双相码
signal s1      : std_logic_vector(4 downto 0):="00000";	
signal clkb    : std_logic;
signal count1  : integer range 1 downto 0;
signal codeoutb: std_logic_vector(1 downto 0);
signal flagv   : integer range 1 downto 0;
signal firstv  : integer range 0 to 1;
signal flag1b  : integer range 1 downto 0;
--=============================================
component dff                            --调用元件dff
  port (
			d   : in std_logic;
			clk : in std_logic;
			q   : out std_logic
       );
end component;
------------------------------------------------------------
begin
  add_v:process(clk,clr)                 --插符号V进程(只考虑插V(11)操作)
        begin
          if(rising_edge(clk)) then      --时钟驱动
            if(clr='1') then             --清零，则初始化
              codeoutv<="00";            --用00代表0
              count0<=0;                 --连'0'个数计数器
            else 
              case codein is 
				when '1'=>
                    codeoutv<="01";      --用01代表1
                    count0<=0;
                when '0'=>
                    if(count0=3)then     --当有4个连续的0时插入V
                        codeoutv<="11";  --用11代表V
                        count0<=0;
                    else
                    	codeoutv<="00";
                        count0<=count0+1;
                        
                    end if;
                when others=>
                    codeoutv<="00"; --自己设定状态(仿真时避免其出现)
                    count0<=count0;
              end case;
             end if;
           end if;
  end process add_v;
--=============================================
  s0(0)<=codeoutv(0);
  s1(0)<=codeoutv(1);  
  ds11: dff port map(s1(0),clk,s1(1));   --调用库中的D触发器来实现延迟作用
  ds01: dff port map(s0(0),clk,s0(1));
  ds12: dff port map(s1(1),clk,s1(2));
  ds02: dff port map(s0(1),clk,s0(2));
  ds13: dff port map(s1(2),clk,s1(3));
  ds03: dff port map(s0(2),clk,s0(3));
  bclk: clkb<=not clk;
-----------------------------------------------------------
  add_b:process(clkb)                    --插入符号B进程
      begin
        if(rising_edge(clkb)) then
          if(codeoutv="11") then
          
          --保证在两个V码之间判断        --为了使脉冲序列不含直流分量，必须使相邻的破坏点V脉冲极性交替
          --从而必须使相邻破坏点之间有奇数个'1'码
            if(firstv=0) then            --记"11"(V)的个数，是否是第一个V码
              count1<=0;                 --记"01"(1)的个数，判断奇偶性
              firstv<=1;
              s1(4)<=s1(3);
              s0(4)<=s0(3);
            else                         --下一个时钟周期
              if(count1=0) then          --用10代表B
                  s1(4)<='1';
                  s0(4)<='0';
                  count1<=0;
              else
                  s1(4)<=s1(3);          --不插
                  s0(4)<=s0(3);
                  count1<=0;             --一次处理完毕后，1的累积个数清零重新开始计数(1的个数)
              end if;
            end if;
            
          elsif(codeoutv="01") then
            count1<=count1+1;            --为V码判断模块标志
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
  output:process(clk)                    --单极性变双极性的进程
      begin
        if(rising_edge(clk)) then
          if((codeoutb="01")or(codeoutb="10"))then   --1 or B(交替出现)采集信号
            if(flag1b=1) then            --记"+V"与"-V"之间'1'的奇偶性
              codeout<="01";             -- +1
              flag1b<=0;
            else
              codeout<="11";             -- -1 --实现双极性
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