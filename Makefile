complete_cpu:
	ghdl -a --ieee=synopsys -fexplicit src/mem.vhd src/combi.vhd src/reg_bank.vhd src/etages.vhd src/control.vhd src/cpu_no_control.vhd src/cpu_with_alea_ports.vhd src/complete_cpu.vhd testbench/test_file.vhd
	ghdl -e --ieee=synopsys -fexplicit test_file
	ghdl -r --ieee=synopsys -fexplicit test_file --wave=output.ghw
	gtkwave output.ghw

