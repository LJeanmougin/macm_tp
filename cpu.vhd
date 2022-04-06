LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity cpu is
    PORT(
        CLK
    );
end entity;
--FE DE EX ME RE
architecture cpu_arch of cpu is
    -- signaux chemin des données
    signal ALUSrc_EX, MemWr_Mem, PCSrc_ER, Bpris_EX, RAZ_DI, RegWR, Clr_EX, MemToReg_RE : std_logic;
    signal RegSrc, immSrc, ALUCtrl_EX : std_logic_vector(1 downto 0);
    signal instr_DE : std_logic_vector(31 downto 0);
    signal a1, a2, CC : std_logic_vector(3 downto 0);
    -- signaux unité de contrôle DE
    signal PCSrc_DE, RegWR_DE, MemToReg_DE, MemWR_DE, Branch_DE, CCWr_DE, AluSrc_DE : std_logic;
    signal AluCtrl_DE : std_logic_vector(1 downto 0);
    signal Cond_DE : std_logic_vector(3 downto 0);
    -- signaux unité de contrôle EX
    signal RegWr_EX, PCSrc_EX, CCWr_EX, MemWr_EX, MemToReg_EX : std_logic;
    signal AluCtrl : std_logic_vector(1 downto 0)
begin
    -- Chemin des données
    d_path : entity work.dataPath
        PORT MAP(
            CLK, ALUSrc_EX, MemWr_Mem, PCSrc_ER, Bpris_EX, '1', '1', RAZ_DI, RegWR, Clr_EX, MemToReg_RE,
            RegSrc, "00", "00", immSrc, ALUCtrl_EX,
            instr_DE,
            a1, a2, CC
        );
    -- Unité de contrôle
    ctrl : entity work.controlUnit
        PORT MAP(
            instr_DE,
            PCSrc_DE,
            RegWR_DE,
            MemToReg_DE,
            MemWR_DE,
            Branch_DE,
            CCWr_DE,
            AluSrc_DE,
            AluCtrl_DE,
            immSrc,
            RegSrc,
            Cond_DE
        );
    -- Registres DE|EX
    RegWr_DE_register : entity work.Reg1
        PORT MAP(
            RegWr_DE,
            RegWr_EX,
            clk
        );
    
    PCSrc_DE_register : entity work.Reg1
        PORT MAP(
            PCSrc_DE,
            PCSrc_EX,
            clk
        );
    
    CCWr_DE_register : entity work.Reg1
        PORT MAP(
            CCWr_DE,
            CCWr_EX,
            clk
        );
    
    MemWr_DE_register : entity work.Reg1
        PORT MAP(
            MemWR_DE,
            MemWR_EX,
            clk
        );
    
    AluCtrl_DE_register : entity work.Reg2
        PORT MAP(
            AluCtrl_DE,
            AluCtrl_EX,
            clk
        );

    Branch_DE_register : entity work.Reg1
        PORT MAP(
            Branch_DE,
            Bpris_EX,
            clk
        );
    
    MemToReg_DE_register : entity work.Reg1
        PORT MAP(
            MemToReg_DE,
            MemToReg_EX,
            clk
        );
    
    AluSrc_DE_register : entity work.Reg1
        PORT MAP(
            AluSrc_DE,
            AluSrc_EX,
            clk
        );
end architecture;