-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd control.vhd proc.vhd cpu.vhd control_test.vhd 
-- ghdl -e --ieee=synopsys -fexplicit control_test
-- ghdl -r --ieee=synopsys -fexplicit control_test --wave=output.ghw
-- gtkwave output.ghw

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity cpu is
    PORT(
        CLK, Gel_LI, Gel_DI, RAZ_DI, Clr_EX: in std_logic;
        EA_EX, EB_EX : in std_logic_vector(1 downto 0);
        Op3_EX_Out, Op3_ME_Out, Op3_RE_Out : out std_logic_vector(3 downto 0);
        a1, a2 : out std_logic_vector(3 downto 0);
        RegWr_Mem : out std_logic;
        MemToReg_EX_out, Bpris_EX_out : out std_logic;
        PCSrc_DE_Out, PCSrc_EX_Out, PCSrc_ME_Out, PCSrc_ER_Out : out std_logic
    );
end entity;
--FE DE EX ME RE
architecture cpu_arch of cpu is
    signal raz : std_logic;
    -- signaux chemin des données
    signal ALUSrc_EX, MemWr_ME, PCSrc_ER, RegWR, MemToReg_RE, Bpris_EX : std_logic;
    signal RegSrc, immSrc, ALUCtrl_EX : std_logic_vector(1 downto 0);
    signal instr_DE : std_logic_vector(31 downto 0);
    signal CC : std_logic_vector(3 downto 0);
    -- signaux unité de contrôle DE
    signal PCSrc_DE, RegWR_DE, MemToReg_DE, MemWR_DE, Branch_DE, CCWr_DE, AluSrc_DE : std_logic;
    signal AluCtrl_DE : std_logic_vector(1 downto 0);
    signal Cond_DE : std_logic_vector(3 downto 0);
    -- signaux unité de contrôle EX
    signal RegWr_EX, PCSrc_EX, CCWr_EX, MemWR_EX, MemToReg_EX : std_logic;
    signal AluCtrl : std_logic_vector(1 downto 0);
    -- signaux gestion des conditions
    signal Cond_EX, Cond_EX_in, CC_quote, CC_EX : std_logic_vector(3 downto 0);
    signal CondEx, Branch_EX : std_logic;
    -- signaux de sortie des portes "et" de l'étage EX
    signal RegWr_CondEx, PCSrc_CondEx, MemWR_CondEx, Branch_CondEx : std_logic;
    -- signaux de contrôle ME
    signal RegWr_ME_cpu, PCSrc_ME, MemWr_ME_cpu, Branch_ME, MemToReg_ME : std_logic;
begin
    raz <= '1';

    -- Chemin des données
    d_path : entity work.dataPath
        PORT MAP(
            CLK, ALUSrc_EX, MemWr_ME_cpu, PCSrc_ER, Bpris_EX, Gel_LI, Gel_DI, RAZ_DI, RegWr, Clr_EX, MemToReg_RE,
            RegSrc, EA_EX, EB_EX, immSrc, ALUCtrl_EX,
            instr_DE,
            a1, a2, CC,
            Op3_EX_Out, Op3_ME_Out, Op3_RE_Out
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
            raz,
            clk
        );
    
    PCSrc_DE_register : entity work.Reg1
        PORT MAP(
            PCSrc_DE,
            PCSrc_EX,
            raz,
            clk
        );
    
    CCWr_DE_register : entity work.Reg1
        PORT MAP(
            CCWr_DE,
            CCWr_EX,
            raz,
            clk
        );
    
    MemWr_DE_register : entity work.Reg1
        PORT MAP(
            MemWR_DE,
            MemWR_EX,
            raz,
            clk
        );
    
    AluCtrl_DE_register : entity work.Reg2
        PORT MAP(
            AluCtrl_DE,
            AluCtrl_EX,
            raz,
            clk
        );

    Branch_DE_register : entity work.Reg1
        PORT MAP(
            Branch_DE,
            Branch_EX,
            raz,
            clk
        );
    
    MemToReg_DE_register : entity work.Reg1
        PORT MAP(
            MemToReg_DE,
            MemToReg_EX,
            raz,
            clk
        );
    
    MemToReg_EX_Out <= MemToReg_EX;
    
    AluSrc_DE_register : entity work.Reg1
        PORT MAP(
            AluSrc_DE,
            AluSrc_EX,
            raz,
            clk
        );

    Cond_DE_register : entity work.Reg4
        PORT MAP(
            Cond_DE,
            Cond_EX_in,
            '1',
            raz,
            clk
        );
    
    CC_DE_register : entity work.Reg4
        PORT MAP(
            CC_quote,
            CC_EX,
            '1',
            raz,
            clk
        );

    -- unité de gestion des condition

    cond_mng : entity work.condManagementUnit
        PORT MAP(
            Cond_EX_in,
            CC_EX,
            CC,
            CCWr_EX,
            CC_quote,
            CondEx
        );
    
    -- porte "et" de l'étage EX

    RegWr_and_CondEx : entity work.and_gate
        PORT MAP(
            RegWr_EX,
            CondEx,
            RegWr_CondEx
        );
    
    PCSrc_and_CondEx : entity work.and_gate
        PORT MAP(
            PCSrc_EX,
            CondEx,
            PCSrc_CondEx
        );
    
    MemWr_and_CondEx : entity work.and_gate
        PORT MAP(
            MemWR_EX,
            CondEx,
            MemWR_CondEx
        );

    Branch_and_CondEx : entity work.and_gate
        PORT MAP(
            Branch_EX,
            CondEx,
            Bpris_EX
        );
    
    Bpris_EX_out <= Bpris_EX;
    -- Registres inter EX ME

    RegWr_EX_register : entity work.Reg1
        PORT MAP(
            RegWr_CondEx,
            RegWr_ME_cpu,
            raz,
            clk
        );
    
    PCSrc_EX_register : entity work.Reg1
        PORT MAP(
            PCSrc_Condex,
            PCSrc_ME,
            raz,
            clk
        );

    MemWr_EX_register : entity work.Reg1
        PORT MAP(
            MemWR_CondEx,
            MemWr_ME_cpu,
            raz,
            clk
        );
    
    MemToReg_EX_register : entity work.Reg1
        PORT MAP(
            MemToReg_EX,
            MemToReg_ME,
            raz,
            clk
        );
    -- Registres inter ME ER
    
    RegWr_ME_cpu_register : entity work.Reg1
        PORT MAP(
            RegWr_ME_cpu,
            RegWr,
            raz,
            clk
        );

    RegWr_Mem <= RegWr;
    
    PCSrc_ME_register : entity work.Reg1
        PORT MAP(
            PCSrc_ME,
            PCSrc_ER,
            raz,
            clk
        );
    
    MemToReg_ME_register : entity work.Reg1
        PORT MAP(
            MemToReg_ME,
            MemToReg_RE,
            raz,
            clk
        );
    PCSrc_DE_Out <= PCSrc_DE;
    PCSrc_EX_Out <= PCSrc_EX;
    PCSrc_ME_Out <= PCSrc_ME;
    PCSrc_ER_Out <= PCSrc_ER;
end architecture;