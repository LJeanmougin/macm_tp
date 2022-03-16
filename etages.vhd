-------------------------------------------------

-- Etage FE

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageFE is
  port(
    npc, npc_fw_br : in std_logic_vector(31 downto 0);
    PCSrc_ER, Bpris_EX, GEL_LI, clk : in std_logic;
    pc_plus_4, i_FE : out std_logic_vector(31 downto 0)
);
end entity;


architecture etageFE_arch of etageFE is
  signal pc_inter, pc_reg_in, pc_reg_out, sig_pc_plus_4, sig_4: std_logic_vector(31 downto 0);
begin

  sig_4 <= (2=>'1', others => '0');
  pc_inter <= npc when PCSrc_ER = '1' else 
              sig_pc_plus_4 when PCSrc_ER = '0' else
              (others => 'X');
  pc_reg_in <= pc_inter when Bpris_EX = '0' else 
               npc_fw_br when Bpris_EX = '1' else
               (others => 'X');
  pc : ENTITY work.Reg32
    PORT MAP(
      pc_reg_in,
      pc_reg_out,
      GEL_LI,
      '1',
      clk
    );
  mem_inst : ENTITY work.inst_mem
    PORT MAP(
      pc_reg_out,
      i_FE
    );
  adder : ENTITY work.addComplex
    PORT MAP(
      sig_4,
      pc_reg_out,
      '0',
      sig_pc_plus_4
    );
  pc_plus_4 <= sig_pc_plus_4;
end architecture;

-- -------------------------------------------------

-- -- Etage DE

-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;

-- entity etageDE is
-- end entity

-- -------------------------------------------------

-- -- Etage EX

-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;

-- entity etageEX is
-- end entity
-- -------------------------------------------------

-- -- Etage ME

-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;

-- entity etageME is
-- end entity
-- -------------------------------------------------

-- -- Etage ER

-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;

-- entity etageER is
-- end entity
