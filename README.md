
# TP MACM

## Getting started

1. Clone the repository 
    `git clone git@github.com:LJeanmougin/macm_tp.git`

2. Make sure you have ghdl and gtkwave installed, if not you can run 
    `sudo apt install ghdl gtkwave`

## How to use it

1. Go to the directory using `cd macm_tp`.

3. You can configure the instruction memory by editing `memfile.dat`.

4. The test file for the completed cpu is `testbench/test_file.vhd` and is configured to make the cpu run for 200ns.
You can however edit the duration if needed.

5. To run your tests got to the `macm_tp` directory and use the command
    `make complete_cpu -i` to ignore the simulation termination error.

6. This will compile all the necessary files, run the simulation and open gtkwave.

7. Check your signals.

## What has been done

1. The whole architecture of the simplified ARM processor.

2. Simple tests on additions and register writing.

## What has to be done

1. Extensive testbench to determine if the processor is able to load and store data from and to the memory and verify that the processor can manage data hazards.