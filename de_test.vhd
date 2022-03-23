-- ghdl -a --ieee=synopsys -fexplicit mem.vhd combi.vhd reg_bank.vhd etages.vhd de_test.vhd
-- ghdl -e --ieee=synopsys -fexplicit de_test_bench
-- ghdl -r --ieee=synopsys -fexplicit de_test_bench --wave=output.ghw
-- gtkwave output.ghw
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY WORK;
USE WORK.ALL;

--Declaration de l'entite test

entity de_test_bench is
end entity;

--Architecture de test

architecture de_tb_arch of de_test_bench is
    signal E_i_DE, E_WD_ER, E_pc_plus_4, E_Op1, E_Op2, E_extImm : std_logic_vector(31 downto 0);
    signal E_Op3_ER, E_Reg1, E_Reg2, E_Op3_DE : std_logic_vector(3 downto 0);
    signal E_RegSrc, E_immSrc : std_logic_vector(1 downto 0);
    signal E_RegWr, E_clk : std_logic;
begin
    decode : entity work.etageDE
        PORT MAP(
            E_i_DE, E_WD_ER, E_pc_plus_4,
            E_Op3_ER, 
            E_RegSrc, E_immSrc,
            E_RegWr, E_clk,
            E_Reg1, E_Reg2,
            E_Op1, E_Op2, E_extImm,
            E_Op3_DE
        );
    process
    begin
        E_i_DE <= (others => '0');
        E_RegSrc(1) <= '0';
        E_RegSrc(0) <= '0';
        --on remplit les registres avant de les lire
        E_RegWr <= '1';
        E_immSrc <= (others => '0');
        E_clk <= '0';
        E_WD_ER <= (others => '0');
        E_Op3_ER <= (others => '0');
        E_pc_plus_4(0) <= '1';
        E_pc_plus_4(31 downto 1) <= (others => '0');
        for i in 0 to 10 loop -- test de l'incrementation d'adresse
            wait for 5 ns;
            E_clk <= '1';
            wait for 5 ns;
            E_clk <= '0';
            E_WD_ER <= E_WD_ER + '1';
            E_Op3_ER <= E_Op3_ER + '1';
        end loop;
        E_RegWr <= '0';
        E_i_DE(16) <= '1';
        E_i_DE(1 downto 0) <= "11";
        wait for 5 ns;
        E_clk <= '1';
        wait for 5 ns;
        E_clk <= '0';
        wait;
    end process;
end architecture;