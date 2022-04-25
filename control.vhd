
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity controlUnit is
    port(
        instr : in std_logic_vector(31 downto 0);
        PCSrc, RegWr, MemToReg, MemWr, Branch, CCWr, AluSrc : out std_logic;
        AluCtrl, ImmSrc, RegSrc : out std_logic_vector(1 downto 0);
        Cond : out std_logic_vector(3 downto 0)
    );
end entity;

architecture controlUnit_arch of controlUnit is

begin
    Branch <= instr(27);
    MemToReg <= instr(26);
    MemWr <= instr(26) and not(instr(20));
    AluSrc <= instr(27) or instr(26) or instr(25);
    ImmSrc <= instr(27 downto 26);
    RegWr <= '0' when instr(24 downto 21) = "1010" else
             '1' when instr(27 downto 26) = "00" else
             instr(26) and instr(20);
    RegSrc(1) <= instr(26);
    RegSrc(0) <= instr(27);
    PCSrc <= '1' when instr(15 downto 12) = "1111" else
             '0';
    CCWr <= '1' when instr(27 downto 26) = "00" and instr(20) = '1' else
            '0';
    AluSrc <= '0' when Instr(27 downto 25) = "000" else
              '1';
    Cond <= instr(31 downto 28);
    AluCtrl <= "00" when instr(27 downto 26) = "10" else
               "00" when (instr(27 downto 26) = "00" and instr(24 downto 21) = "0100") else
               "00" when instr(27 downto 26) = "01" and instr(23) = '0' else
               "01" when instr(27 downto 26) = "00" and (instr(24 downto 21) = "0010" or (instr(24 downto 21) = "1010")) else
               "01" when instr(27 downto 26) = "01" and instr(23) = '1' else
               "10" when instr(27 downto 26) = "00" and instr(24 downto 21) = "0000" else
               "11" when instr(27 downto 26) = "00" and instr(24 downto 21) = "1100" else
               "XX";

end architecture;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity condManagementUnit is
    port(
        Cond, CC_EX, CC : in std_logic_vector(3 downto 0);
        CCWr_EX : in std_logic;
        CC_quote : out std_logic_vector(3 downto 0);
        CondEx : out std_logic
    );
end entity;

architecture condManagementUnit_arch of condManagementUnit is
    signal CondEx_s : std_logic;
    constant N : integer := 3;
    constant Z : integer := 2;
    constant C : integer := 1;
    constant V : integer := 0;

begin
    --ordre des bits : N, Z, C, V
    CondEx_s <= CC_EX(Z) when Cond = "0000" else
                not(CC_EX(Z)) when Cond = "0001" else
                CC_EX(C) when Cond = "0010" else
                not(CC_EX(C)) when Cond = "0011" else
                CC_EX(N) when Cond = "0100" else
                not(CC_EX(N)) when Cond = "0101" else
                CC_EX(V) when Cond = "0110" else
                not(CC_EX(V)) when Cond = "0111" else
                CC_EX(C) and not(CC_EX(Z)) when Cond = "1000" else
                not(CC_EX(C)) and CC_EX(Z) when Cond = "1001" else
                '1' when CC_EX(N) = CC_EX(V) and Cond = "1010" else
                '1' when CC_EX(N) /= CC_EX(V) and Cond = "1011" else
                '1' when ((not CC_EX(Z) = '1') and (CC_EX(N) = CC_EX(V))) and Cond = "1100" else
                '1' when CC_EX(Z) = '1' and (CC_EX(N) /= CC_EX(V)) and Cond = "1101" else
                '1' when Cond = "1110" else
                '0';
    CC_quote <= CC when CCWr_EX = '1' and CondEx_s = '1' else
                CC_EX;
    CondEx <= Condex_s;
end architecture;