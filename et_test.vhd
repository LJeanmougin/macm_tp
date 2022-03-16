-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd et_test.vhd
-- ghdl -e --ieee=synopsys -fexplicit et_test
-- ghdl -r --ieee=synopsys -fexplicit et_test --wave=output.ghw
-- gtkwave output.ghw
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY WORK;
USE WORK.ALL;

--Declaration de l'entite test

entity test_bench is
end entity;

--Architecture de test

architecture tb_arch of test_bench is
    signal E_npc, E_npc_fw_br, E_pc_plus_4, E_i_FE : std_logic_vector(31 downto 0);
    signal E_PCSrc_ER, E_Bpris_EX, E_GEL_LI, E_clk : std_logic;
begin
    fetch_read : ENTITY work.etageFE
    PORT MAP(
        E_npc,
        E_npc_fw_br,
        E_PCSrc_ER,
        E_Bpris_EX,
        E_GEL_LI,
        E_clk,
        E_pc_plus_4,
        E_i_FE
    );
    process
    begin
        E_npc <= (others => '0');
        E_PCSrc_ER <= '0';
        E_npc_fw_br <= (others => '0');
        E_Bpris_EX <= '0';
        E_GEL_LI <= '1';
        E_clk <= '0';
        for i in 0 to 5 loop -- test de l'incrementation d'adresse
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_clk <= '0';
        end loop;
        E_GEL_LI <= '0'; -- test du gel d'instruction
        for i in 0 to 5 loop
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_clk <= '0';
        end loop;
        E_GEL_LI <= '1';
        E_Bpris_EX <= '1'; -- test du branchement
        E_npc_fw_br <= (others => '0'); -- doit reset l'adresse a 0
        for i in 0 to 1 loop
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_Bpris_EX <= '0';
            E_clk <= '0';
        end loop;
        for i in 0 to 5 loop
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_clk <= '0';
        end loop;
        E_PCSrc_ER <= '1';
        E_npc <= (others => '0'); --test de PCSrc doit remettre les instruction à 0
        wait for 5 ns;
        E_clk <= '1';
        wait for 5 ns;
        E_PCSrc_ER <= '0';
        E_clk <= '0';
        for i in 0 to 5 loop
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_clk <= '0';
        end loop;
        wait;
    end process;
end architecture;