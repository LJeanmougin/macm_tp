
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
end architecture;