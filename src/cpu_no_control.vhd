-------------------------------------------------------

-- Chemin de données

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity dataPath is
  port(
    clk,  ALUSrc_EX, MemWr_Mem, PCSrc_ER, Bpris_EX, Gel_LI, Gel_DI, RAZ_DI, RegWR, Clr_EX, MemToReg_RE : in std_logic;
    RegSrc, EA_EX, EB_EX, immSrc, ALUCtrl_EX : in std_logic_vector(1 downto 0);
    instr_DE: out std_logic_vector(31 downto 0);
    a1, a2, CC: out std_logic_vector(3 downto 0);
    Op3_EX_Out_alea, Op3_ME_Out_alea, Op3_RE_Out_alea : out std_logic_vector(3 downto 0)
);      
end entity;

architecture dataPath_arch of dataPath is
  signal Res_RE, npc_fwd_br, pc_plus_4, i_FE, i_DE, Op1_DE, Op2_DE, Op1_EX, Op2_EX, extImm_DE, extImm_EX, Res_EX, Res_ME, WD_EX, WD_ME, Res_Mem_ME, Res_Mem_RE, Res_ALU_ME, Res_ALU_RE, Res_fwd_ME : std_logic_vector(31 downto 0);
  signal Op3_DE, Op3_EX, a1_DE, a1_EX, a2_DE, a2_EX, Op3_EX_out, Op3_ME, Op3_ME_out, Op3_RE, Op3_RE_out : std_logic_vector(3 downto 0);
begin

  -- FE
  fe : ENTITY work.etageFE
    PORT MAP(
      Res_RE,
      npc_fwd_br,
      PCSrc_ER,
      Bpris_EX,
      Gel_LI,
      clk,
      pc_plus_4,
      i_FE
    );
  -- DE
  de : ENTITY work.etageDE
    PORT MAP(
      i_DE,
      Res_RE,
      pc_plus_4,
      Op3_RE_out,
      RegSrc,
      immSrc,
      RegWR,
      clk,
      a1_DE,
      a2_DE,
      Op1_DE,
      Op2_DE,
      extImm_DE,
      Op3_DE
    );

  instr_DE <= i_DE;

  -- EX
  ex : ENTITY work.etageEX
    PORT MAP(
      Op1_EX,
      Op2_EX,
      extImm_EX,
      Res_fwd_ME,
      Res_RE,
      Op3_EX,
      EA_EX,
      EB_EX,
      ALUSrc_EX,
      ALUCtrl_EX,
      CC,
      Res_EX,
      WD_EX,
      npc_fwd_br,
      Op3_EX_out
    );
    Op3_EX_Out_alea <= Op3_EX_out;
  -- ME
  me : ENTITY work.etageME
    PORT MAP(
      Res_ME,
      WD_ME,
      Op3_ME,
      clk,
      MemWr_Mem,
      Res_Mem_ME,
      Res_ALU_ME,
      Op3_ME_out,
      Res_fwd_ME
    );
    Op3_ME_Out_alea <= Op3_ME_out;
  -- RE
  re : ENTITY work.etageER
    PORT MAP(
      Res_Mem_RE,
      Res_ALU_RE,
      Op3_RE,
      MemToReg_RE,
      Res_RE,
      Op3_RE_out
    );
    Op3_RE_Out_alea <= Op3_RE_out;
  -- inter FE DE
  regFEDE : ENTITY work.Reg32sync
    PORT MAP(
      i_FE,
      i_DE,
      Gel_DI,
      RAZ_DI,
      clk
    );

  -- inter DE EX
  regDEEXa1 : ENTITY work.Reg4
    PORT MAP(
      a1_DE,
      a1,
      '1',
      Clr_EX,
      clk
    );
  
  regDEEXa2 : ENTITY work.Reg4
    PORT MAP(
      a2_DE,
      a2,
      '1',
      Clr_EX,
      clk
    );

  regDEEXOp1 : ENTITY work.Reg32sync
    PORT MAP(
      Op1_DE,
      Op1_EX,
      '1',
      Clr_EX,
      clk
    );
   
  regDEEXOp2 : ENTITY work.Reg32sync
    PORT MAP(
      Op2_DE,
      Op2_EX,
      '1',
      Clr_EX,
      clk
    );

  regDEEXextImm : ENTITY work.Reg32sync
    PORT MAP(
      extImm_DE,
      extImm_EX,
      '1',
      Clr_EX,
      clk
    );
  
  regDEEXOp3 : ENTITY work.Reg4
    PORT MAP(
      Op3_DE,
      Op3_EX,
      '1',
      Clr_EX,
      clk
    );
  
  -- inter EX ME

  regEXMERes : ENTITY work.Reg32sync
    PORT MAP(
      Res_EX,
      Res_ME,
      '1',
      '1',
      clk
    );
  
  regEXMEWD : ENTITY work.Reg32sync
    PORT MAP(
      WD_EX,
      WD_ME,
      '1',
      '1',
      clk
    );
  
  regEXMEOp3 : ENTITY work.Reg4
    PORT MAP(
      Op3_EX_out,
      Op3_ME,
      '1',
      '1',
      clk
    );

  -- inter ME RE

  regMERERes : ENTITY work.Reg32sync
    PORT MAP(
      Res_Mem_ME,
      Res_Mem_RE,
      '1',
      '1',
      clk
    );

  regMERERes_alu : ENTITY work.Reg32sync
    PORT MAP(
      Res_ALU_ME,
      Res_ALU_RE,
      '1',
      '1',
      clk
    );
  
  regMEREOp3 : ENTITY work.Reg4
    PORT MAP(
      Op3_ME_out,
      Op3_RE,
      '1',
      '1',
      clk
    );
end architecture;
