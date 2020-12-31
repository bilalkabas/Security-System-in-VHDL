# Security System in VHDL
[![license](https://img.shields.io/badge/license-MIT-%23F65314?style=flat-square)](LICENSE)
[![Vivado](https://img.shields.io/badge/Vivado-2019.2-%2F65314?style=flat-square)]()

This repository contains a basic security system implementation in VHDL.

## Getting Started
You need Vivado installed to be able to simulate the testbench file. You can create a new project, then add the [main.vhd](source/main.vhd) file as a design source. Then, add the [main_tb.vhd](testbench/main_tb.vhd) as a simulation source. Be careful about the naming of these files that is design source should be named as "main.vhd" and the simulation source should be named as "main_tb.vhd".

### Running Simulation
To run and get an output from simulation, you need to specify the location of the simulation input and output file directories. You can find the simulation file [here](simulation-source). Open up main_tb.vhd testbench file and find the lines below. Locate the simulation input file on your computer and paste that path there. Also, you should specify the location where you want simulation to save the output file. 

```
-- File handling
file_open(input_buf, "replace_with_your_simulation_input_directory\simulation.txt",  read_mode);
file_open(output_buf, "replace_with_your_simulation_output_directory\output.txt",  write_mode);
```

## Inputs, Outputs and States
<img src="/images/inputs_outputs_states.PNG"/>

## State Diagram

<img src="/images/state_diagram.PNG"/>

## Built with

- Vivado 2019.2

## Authors

- [Bilal Kabaş](https://github.com/bilalkabas)

## License

This project is licensed under the [MIT License](https://github.com/bilalkabas/Security-System-in-VHDL/blob/master/LICENSE).

