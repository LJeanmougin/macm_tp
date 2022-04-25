-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd control.vhd cpu_no_control.vhd cpu_with_alea_ports.vhd control_test.vhd
-- ghdl -e --ieee=synopsys -fexplicit control_test
-- ghdl -r --ieee=synopsys -fexplicit control_test --wave=output.ghw
-- gtkwave output.ghw

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY WORK;
USE WORK.ALL;

entity complete_cpu is
    PORT(
        CLK : in std_logic
    );
end entity;

architecture complete_cpu_arch of complete_cpu is
    signal Gel_LI, Gel_DI, RAZ_DI, Clr_EX, RegWr_Mem, Bpris_EX : std_logic;
    signal EA_EX, EB_EX : std_logic_vector(1 downto 0);
    signal Op3_ME_Out, Op3_RE_Out, Op3_EX_Out, a1, a2 : std_logic_vector(3 downto 0);
    signal MemToReg_EX : std_logic;
    signal LDRStall : std_logic;
    signal PCSrc_DE, PCSrc_EX, PCSrc_ME, PCSrc_ER : std_logic;
    begin
        ctrl_cpu : entity work.cpu
            PORT MAP(
                CLK,
                Gel_LI,
                Gel_DI,
                RAZ_DI,
                Clr_EX,
                EA_EX,
                EB_EX,
                Op3_EX_Out,
                Op3_ME_Out,
                Op3_RE_Out,
                a1,
                a2,
                RegWr_Mem,
                MemToReg_EX,
                Bpris_EX,
                PCSrc_DE, 
                PCSrc_EX, 
                PCSrc_ME, 
                PCSrc_ER
            );
            EA_EX <= "10" when a1 = Op3_ME_Out and RegWr_Mem = '1' else
                     "01" when a1 = Op3_RE_Out and RegWr_Mem = '1' else
                     "00";
            EB_EX <= "10" when a2 = Op3_ME_Out and RegWr_Mem = '1' else
                     "01" when a2 = Op3_RE_Out and RegWr_Mem = '1' else
                     "00";
            LDRStall <= '1' when (a1 = Op3_EX_Out or a2 = Op3_EX_Out) and MemToReg_EX = '1' else
                        '0';
            Gel_LI <= not (LDRStall or PCSrc_DE or PCSrc_EX or PCSrc_ME);
            Gel_DI <= not LDRStall;
            Clr_EX <= not (LDRStall or Bpris_EX);
            RAZ_DI <= not (PCSrc_DE or PCSrc_EX or PCSrc_ME or PCSrc_ER or Bpris_EX);

    end architecture;
            