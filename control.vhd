
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
    RegWr <= '0' when instr(24 downto 21) = "1O1O" else
             '1' when instr(27 downto 26) = "00" else
             instr(26) and instr(20);
    -- Peut etre ca marche avec truc to machin
    RegSrc(1) <= instr(26);
    RegSrc(0) <= instr(27);
    PCSrc <= '1' when instr(15 downto 12) = "1111" else
             '0';
    CCWr <= '1' when instr(27 downto 26) = "00" and instr(20) = '1' else
            '0';
    Cond <= instr(31 downto 28);
end architecture;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

constant N : natural := 3;
constant Z : natural := 2;
constant C : natural := 1;
constant V : natural := 0;


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
                CC_EX(N) = CC_EX(V) when Cond = "1010" else
                CC_EX(N) /= CC_EX(V) when Cond = "1011" else
                not(CC_EX(Z)) and (CC_EX(N) = CC_EX(V)) when Cond = "1100" else
                CC_EX(Z) and (CC_EX(N) /= CC_EX(V)) when Cond = "1101" else
                '1' when Cond = "1110" else
                '0';
    CC_quote <= CC when CCWr_EX = '1' and CondEx_s = '1' else
                CC_EX;
end architecture;