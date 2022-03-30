-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd proc.vhd test_data_path.vhd
-- ghdl -e --ieee=synopsys -fexplicit data_path_testbench
-- ghdl -r --ieee=synopsys -fexplicit data_path_testbench --wave=output.ghw
-- gtkwave output.ghw
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY WORK;
USE WORK.ALL;