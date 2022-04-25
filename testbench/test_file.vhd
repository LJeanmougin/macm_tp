-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd control.vhd proc.vhd cpu.vhd control_test.vhd 
-- ghdl -e --ieee=synopsys -fexplicit control_test
-- ghdl -r --ieee=synopsys -fexplicit control_test --wave=output.ghw
-- gtkwave output.ghw

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY WORK;
USE WORK.ALL;

entity control_test is
end control_test;

architecture behavior of control_test is
    constant clkpulse : Time := 5 ns;
    signal E_CLK : std_logic;
begin
    P_CLK : process
    begin
        E_CLK <= '1';
        wait for clkpulse;
        E_CLK <= '0';
        wait for clkpulse;
    end process;
    my_cpu : entity work.complete_cpu
    PORT MAP(
        E_CLK
    );
    P_TIMEOUT : process
    begin
        wait for 200 ns;
        assert FALSE report "TIMEOUT SIMULATION !!!" severity FAILURE;
    end process;
end architecture;